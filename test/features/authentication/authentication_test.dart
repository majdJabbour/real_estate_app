import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/network/api_client.dart';
import 'package:real_estate_app/features/authentication/application/authentication_providers.dart';
import 'package:real_estate_app/features/authentication/domain/authentication_repository.dart';
import 'package:real_estate_app/features/authentication/presentation/auth_routes.dart';

import '../../support/fake_dio_adapter.dart';
import '../../support/memory_locale_preferences.dart';
import 'fake_authentication.dart';

ProviderContainer _container(FakeAuthentication repository) =>
    ProviderContainer.test(
      overrides: [
        authenticationInitializerProvider.overrideWithValue(
          () async => repository,
        ),
        localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
        apiTokenSourceProvider.overrideWith(authenticatedApiTokenSource),
      ],
    )..listen(authenticationSessionProvider, (_, _) {});

ResponseBody _profile(String id) => ResponseBody.fromString(
  jsonEncode({
    'success': true,
    'data': {'id': id, 'email': null, 'name': null, 'avatar': null},
  }),
  200,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  for (final initial in [null, firstUser]) {
    test(
      'restores ${initial?.id ?? 'guest'} and observes account switches',
      () async {
        final repository = FakeAuthentication(user: initial);
        final container = _container(repository);
        addTearDown(repository.close);
        expect(
          await container.read(authenticationSessionProvider.future),
          initial,
        );
        await container.pump();
        repository.change(secondUser);
        await container.pump();
        expect(
          container.read(authenticationSessionProvider).requireValue,
          secondUser,
        );
      },
    );
  }

  test(
    'a pending sign-in blocks repeat sign-in and sign-out operations',
    () async {
      final result = Completer<void>();
      final repository = FakeAuthentication()
        ..beforeSignIn = () => result.future;
      final container = _container(repository);
      addTearDown(repository.close);
      await container.read(authenticationSessionProvider.future);
      final action = container.read(authenticationActionProvider.notifier);
      final active = action.signIn();
      await action.signIn();
      await action.signOut();
      expect(container.read(authenticationActionProvider).isLoading, isTrue);
      expect(repository.signInCalls, 1);
      expect(repository.signOutCalls, 0);
      result.complete();
      await active;
      await container.pump();
      expect(
        container.read(authenticationSessionProvider).requireValue,
        firstUser,
      );
      await action.signOut();
      await container.pump();
      expect(
        container.read(authenticationSessionProvider).requireValue,
        isNull,
      );
    },
  );

  for (final failure in [
    AuthenticationFailure.cancelled,
    AuthenticationFailure.connection,
    AuthenticationFailure.configuration,
  ]) {
    test('maps ${failure.name} and permits another attempt', () async {
      final repository = FakeAuthentication()
        ..beforeSignIn = () async => throw failure;
      final container = _container(repository);
      addTearDown(repository.close);
      await container.read(authenticationSessionProvider.future);
      final action = container.read(authenticationActionProvider.notifier);
      await action.signIn();
      expect(
        container.read(authenticationActionProvider).error,
        failure == AuthenticationFailure.cancelled ? null : failure,
      );
      expect(
        container.read(authenticationSessionProvider).requireValue,
        isNull,
      );
      repository.beforeSignIn = null;
      await action.signIn();
      await container.pump();
      expect(
        container.read(authenticationSessionProvider).requireValue,
        firstUser,
      );
    });
  }

  test(
    'fetches verified nullable profile with a protected token only',
    () async {
      final repository = FakeAuthentication(user: firstUser);
      final container = _container(repository);
      addTearDown(repository.close);
      final adapter = FakeAdapter((_, _) => _profile(firstUser.id));
      final client = container.read(dioProvider)..httpClientAdapter = adapter;
      await container.read(authenticationSessionProvider.future);
      final subscription = container.listen(verifiedProfileProvider, (_, _) {});
      addTearDown(subscription.close);
      final profile = await container.read(verifiedProfileProvider.future);
      expect(profile, AuthenticatedUser(id: firstUser.id));
      final request = adapter.requests.single;
      expect(request.uri.path, '/api/v1/auth/me');
      expect(request.headers['Authorization'], 'Bearer first');
      expect(request.followRedirects, isFalse);
      await requestApi(
        client,
        'properties',
        decodeData: (data) => data,
        access: ApiAccess.public,
      );
      expect(adapter.requests.last.headers['Authorization'], isNull);
      expect(repository.tokenCalls, 1);
      await container.read(authenticationActionProvider.notifier).signOut();
      await container.pump();
      expect(container.read(verifiedProfileProvider).asData?.value, isNull);
      await expectLater(
        requestApi(
          client,
          'auth/me',
          decodeData: (data) => data,
          access: ApiAccess.protected,
        ),
        throwsA(
          isA<AppFailure>().having(
            (error) => error.kind,
            'kind',
            FailureKind.unauthorized,
          ),
        ),
      );
      expect(adapter.requests, hasLength(2));
    },
  );

  for (final (status, kind) in [
    (401, FailureKind.unauthorized),
    (503, FailureKind.serviceUnavailable),
  ]) {
    test(
      'profile HTTP $status retains the Firebase session and can retry',
      () async {
        final repository = FakeAuthentication(user: firstUser);
        final container = _container(repository);
        addTearDown(repository.close);
        var attempts = 0;
        final adapter = FakeAdapter(
          (_, _) => attempts++ == 0
              ? ResponseBody.fromString('{}', status)
              : _profile(firstUser.id),
        );
        container.read(dioProvider).httpClientAdapter = adapter;
        await container.read(authenticationSessionProvider.future);
        final subscription = container.listen(
          verifiedProfileProvider,
          (_, _) {},
        );
        addTearDown(subscription.close);
        await expectLater(
          container.read(verifiedProfileProvider.future),
          throwsA(
            isA<AppFailure>().having((error) => error.kind, 'kind', kind),
          ),
        );
        expect(
          container.read(authenticationSessionProvider).requireValue,
          firstUser,
        );
        expect(attempts, 1);
        container.invalidate(verifiedProfileProvider);
        expect(
          await container.read(verifiedProfileProvider.future),
          AuthenticatedUser(id: firstUser.id),
        );
      },
    );
  }

  test('a late profile from the previous account cannot replace the current profile', () async {
    final repository = FakeAuthentication(user: firstUser);
    final container = _container(repository);
    addTearDown(repository.close);
    final firstResponse = Completer<ResponseBody>();
    final firstStarted = Completer<void>();
    final firstCancelled = Completer<void>();
    container.read(dioProvider).httpClientAdapter = FakeAdapter((
      request,
      cancellation,
    ) {
      if (request.headers['Authorization'] == 'Bearer first') {
        firstStarted.complete();
        unawaited(cancellation!.then((_) => firstCancelled.complete()));
        return firstResponse.future;
      }
      return _profile(secondUser.id);
    });
    await container.read(authenticationSessionProvider.future);
    final subscription = container.listen(verifiedProfileProvider, (_, _) {});
    addTearDown(subscription.close);
    await firstStarted.future;
    repository.change(secondUser);
    await container.pump();
    await firstCancelled.future;
    expect(
      await container.read(verifiedProfileProvider.future),
      AuthenticatedUser(id: secondUser.id),
    );
    firstResponse.complete(_profile(firstUser.id));
    await container.pump();
    expect(
      container.read(verifiedProfileProvider).requireValue?.id,
      secondUser.id,
    );
  });

  test(
    'rejects a malformed profile envelope and a mismatched verified account',
    () async {
      final repository = FakeAuthentication(user: firstUser);
      final container = _container(repository);
      addTearDown(repository.close);
      await container.read(authenticationSessionProvider.future);
      var attempts = 0;
      container.read(dioProvider).httpClientAdapter = FakeAdapter((_, _) {
        if (attempts++ != 0) return _profile(secondUser.id);
        return ResponseBody.fromString(
          '{"success":true,"data":{"id":"first","name":null,"email":null}}',
          200,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      final subscription = container.listen(verifiedProfileProvider, (_, _) {});
      addTearDown(subscription.close);
      await expectLater(
        container.read(verifiedProfileProvider.future),
        throwsA(
          isA<AppFailure>().having(
            (error) => error.kind,
            'kind',
            FailureKind.malformedResponse,
          ),
        ),
      );
      container.invalidate(verifiedProfileProvider);
      await expectLater(
        container.read(verifiedProfileProvider.future),
        throwsA(
          isA<AppFailure>().having(
            (error) => error.kind,
            'kind',
            FailureKind.unauthorized,
          ),
        ),
      );
    },
  );

  test('return destinations accept public app paths only', () {
    expect(
      publicDestination('/properties/rental-001'),
      '/properties/rental-001',
    );
    expect(publicDestination('/explore?sort=price'), '/explore?sort=price');
    for (final value in [
      '/auth',
      '/splash',
      '//example.com/home',
      'https://example.com/home',
      '/properties/a%2Fb',
      '/properties/..',
    ]) {
      expect(publicDestination(value), isNull, reason: value);
    }
  });
}
