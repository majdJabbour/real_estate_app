import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/config/app_config.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/models/request_cancellation.dart';
import 'package:real_estate_app/core/network/api_client.dart';
import 'package:real_estate_app/features/favorites/application/favorites_providers.dart';
import 'package:real_estate_app/features/favorites/domain/favorites_repository.dart';

import '../../support/fake_dio_adapter.dart';
import '../../support/memory_locale_preferences.dart';
import '../properties/property_fixtures.dart';

ResponseBody _reply(Object? value, [int status = 200]) =>
    ResponseBody.fromString(
      jsonEncode(value),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  late ProviderContainer container;
  late FavoritesRepository repository;
  late RequestCancellation cancellation;
  late List<String> tokenAccounts;

  FakeAdapter connect(AdapterResponse respond) =>
      container.read(dioProvider).httpClientAdapter = FakeAdapter(respond);

  TypeMatcher<AppFailure> failure(FailureKind kind) =>
      isA<AppFailure>().having((error) => error.kind, 'kind', kind);

  setUp(() {
    tokenAccounts = [];
    container = ProviderContainer.test(
      overrides: [
        localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
        appConfigProvider.overrideWithValue(
          AppConfig.parse('https://fixture.test/api/v1'),
        ),
        accountApiTokenSourceProvider.overrideWithValue((id) async {
          tokenAccounts.add(id);
          return 'fixture.token';
        }),
      ],
    );
    repository = container.read(favoritesRepositoryProvider);
    cancellation = RequestCancellation();
  });

  test(
    'uses contract envelopes, protected methods and ordered summary data',
    () async {
      final adapter = connect((request, _) {
        if (request.method != 'GET') {
          return _reply({
            'success': true,
            'data': {
              'propertyId': 'one_~.id',
              'isFavorite': request.method == 'PUT',
            },
          });
        }
        if (request.uri.path.endsWith('/ids')) {
          return _reply({
            'success': true,
            'data': ['orphan', 'rental-022'],
          });
        }
        return _reply(listingEnvelope());
      });
      final ids = await repository.getIds('account', cancellation);
      final page = await repository.getPage('account', 2, cancellation);
      await repository.setFavorite('account', 'one_~.id', true, cancellation);
      await repository.setFavorite('account', 'one_~.id', false, cancellation);

      expect(ids, {'orphan', 'rental-022'});
      expect(page.items.single.id, 'rental-022');
      expect(page.pagination.hasNextPage, isTrue);
      expect(tokenAccounts, List.filled(4, 'account'));
      expect(adapter.requests.map((r) => (r.method, r.uri.path)), [
        ('GET', '/api/v1/favorites/ids'),
        ('GET', '/api/v1/favorites'),
        ('PUT', '/api/v1/favorites/one_~.id'),
        ('DELETE', '/api/v1/favorites/one_~.id'),
      ]);
      expect(adapter.requests[0].uri.queryParameters, isEmpty);
      expect(adapter.requests[1].uri.queryParameters, {
        'page': '2',
        'limit': '20',
      });
      for (final request in adapter.requests) {
        expect(request.headers['Authorization'], 'Bearer fixture.token');
        expect(request.headers['Accept-Language'], 'en');
      }
    },
  );

  test('rejects invalid paths without making a request', () async {
    final adapter = connect((_, _) => fail('Unexpected request'));
    for (final id in ['..', '__reserved__', 'a/b', 'a?b', 'a%2Fb', '']) {
      await expectLater(
        repository.setFavorite('account', id, true, cancellation),
        throwsA(failure(FailureKind.validation)),
      );
    }
    expect(adapter.requests, isEmpty);
  });

  test('maps unauthorized without a write retry', () async {
    final adapter = connect(
      (_, _) => _reply({
        'success': false,
        'error': {'code': 'UNAUTHORIZED', 'message': 'Fixture only'},
      }, 401),
    );
    await expectLater(
      repository.setFavorite('account', 'one', false, cancellation),
      throwsA(failure(FailureKind.unauthorized)),
    );
    expect(adapter.requests, hasLength(1));
  });

  test(
    'rejects malformed IDs, mismatched mutation results and missing pagination',
    () async {
      connect(
        (request, _) => _reply({
          'success': true,
          'data': switch (request.uri.path) {
            '/api/v1/favorites/ids' => ['one', 'one'],
            '/api/v1/favorites' => [],
            _ => {'propertyId': 'a-different-id', 'isFavorite': true},
          },
        }),
      );
      await expectLater(
        repository.getIds('account', cancellation),
        throwsA(failure(FailureKind.malformedResponse)),
      );
      await expectLater(
        repository.setFavorite('account', 'one', true, cancellation),
        throwsA(failure(FailureKind.malformedResponse)),
      );
      await expectLater(
        repository.getPage('account', 1, cancellation),
        throwsA(failure(FailureKind.malformedResponse)),
      );
    },
  );

  test('locale switch leaves in-flight IDs and mutations valid and rejects old summaries', () async {
    final ids = Completer<ResponseBody>();
    final list = Completer<ResponseBody>();
    final mutation = Completer<ResponseBody>();
    final sent = Completer<void>();
    var count = 0;
    connect((request, _) {
      if (++count == 3) sent.complete();
      if (request.method == 'PUT') return mutation.future;
      return request.uri.path.endsWith('/ids') ? ids.future : list.future;
    });
    final loadIds = repository.getIds('account', cancellation);
    final write = repository.setFavorite('account', 'one', true, cancellation);
    final loadPage = expectLater(
      repository.getPage('account', 2, cancellation),
      throwsA(failure(FailureKind.cancelled)),
    );
    await sent.future;
    await container.read(appLocaleProvider.notifier).select(AppLanguage.arabic);
    ids.complete(
      _reply({
        'success': true,
        'data': ['one'],
      }),
    );
    mutation.complete(
      _reply({
        'success': true,
        'data': {'propertyId': 'one', 'isFavorite': true},
      }),
    );
    list.complete(_reply(listingEnvelope()));
    expect(await loadIds, {'one'});
    await write;
    await loadPage;
  });
}
