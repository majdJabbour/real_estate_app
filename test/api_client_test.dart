import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/config/app_config.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/network/api_client.dart';

import 'support/fake_dio_adapter.dart';
import 'support/memory_locale_preferences.dart';

ResponseBody _body([
  String json = '{"success":true,"data":"sample"}',
  int status = 200,
]) => ResponseBody.fromString(
  json,
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

ProviderContainer _container({ApiTokenSource? token}) => ProviderContainer.test(
  overrides: [
    appConfigProvider.overrideWithValue(
      AppConfig.parse('https://api.example.test/api/v1'),
    ),
    localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
    if (token != null) apiTokenSourceProvider.overrideWithValue(token),
  ],
);

Dio _client(ProviderContainer container, FakeAdapter adapter) =>
    container.read(dioProvider)..httpClientAdapter = adapter;

TypeMatcher<AppFailure> _failure(FailureKind kind) =>
    isA<AppFailure>().having((error) => error.kind, 'kind', kind);

void main() {
  test('Dio encodes a structured request body as JSON', () async {
    final adapter = FakeAdapter((_, _) => _body());
    final client = _client(_container(), adapter);
    await requestApi(
      client,
      'fixture',
      method: 'POST',
      data: {'example': 1},
      access: ApiAccess.public,
      decodeData: (data) => data,
    );
    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.contentType, Headers.jsonContentType);
    expect(String.fromCharCodes(adapter.sentBodies.single), '{"example":1}');
  });
  test(
    'shared client sends JSON headers, timeouts and v1-relative endpoints',
    () async {
      final container = _container();
      final adapter = FakeAdapter((_, _) => _body());
      final client = _client(container, adapter);
      for (final path in ['properties', '/properties']) {
        final result = await requestApi(
          client,
          path,
          queryParameters: {'limit': 1},
          access: ApiAccess.public,
          decodeData: (data) => data as String,
        );
        expect(result.data, 'sample');
      }
      for (final request in adapter.requests) {
        expect(
          request.uri.toString(),
          'https://api.example.test/api/v1/properties?limit=1',
        );
        expect(request.headers['Accept'], 'application/json');
        expect(request.headers['Accept-Language'], 'en');
        expect(request.responseType, ResponseType.json);
        expect(request.connectTimeout, const Duration(seconds: 15));
        expect(request.sendTimeout, const Duration(seconds: 15));
        expect(request.receiveTimeout, const Duration(seconds: 20));
      }
    },
  );

  test('requests read the selected language without rebuilding Dio', () async {
    final container = _container();
    final adapter = FakeAdapter((_, _) => _body());
    final client = _client(container, adapter);
    await client.get<Object?>('health');
    await container.read(appLocaleProvider.notifier).select(AppLanguage.arabic);
    expect(container.read(dioProvider), same(client));
    await client.get<Object?>('health');
    expect(
      adapter.requests.map((request) => request.headers['Accept-Language']),
      ['en', 'ar'],
    );
  });

  test(
    'an in-flight response is discarded even when the language changes back',
    () async {
      final started = Completer<void>();
      final reply = Completer<ResponseBody>();
      final container = _container();
      final client = _client(
        container,
        FakeAdapter((_, _) {
          started.complete();
          return reply.future;
        }),
      );
      final result = requestApi(
        client,
        'health',
        access: ApiAccess.public,
        decodeData: (data) => data,
      );

      await started.future;
      final check = expectLater(
        result,
        throwsA(_failure(FailureKind.cancelled)),
      );
      final locale = container.read(appLocaleProvider.notifier);
      await locale.select(AppLanguage.arabic);
      await locale.select(AppLanguage.english);
      reply.complete(_body());
      await check;
    },
  );

  test(
    'public traffic removes even a caller-supplied Authorization header',
    () async {
      var tokenReads = 0;
      final container = _container(
        token: () async {
          tokenReads++;
          return 'fixture.token';
        },
      );
      final adapter = FakeAdapter((_, _) => _body());
      final client = _client(container, adapter);
      await client.get<Object?>(
        'health',
        options: Options(headers: {'authorization': 'Bearer leaked'}),
      );

      expect(tokenReads, 0);
      expect(
        adapter.requests.single.headers.containsKey('Authorization'),
        isFalse,
      );
    },
  );

  test(
    'protected requests attach the token and disable automatic redirects',
    () async {
      final adapter = FakeAdapter((_, _) => _body());
      final client = _client(
        _container(token: () async => 'fixture.token'),
        adapter,
      );
      await requestApi(
        client,
        'auth/me',
        access: ApiAccess.protected,
        decodeData: (data) => data,
      );

      final request = adapter.requests.single;
      expect(request.headers['Authorization'], 'Bearer fixture.token');
      expect(request.followRedirects, isFalse);
    },
  );

  test(
    'a protected request rejects missing or malformed tokens before transport',
    () async {
      for (final token in [null, '', 'bad token', 'fixture\nheader']) {
        final adapter = FakeAdapter(
          (_, _) => throw StateError('unexpected request'),
        );
        final client = _client(_container(token: () async => token), adapter);
        await expectLater(
          requestApi(
            client,
            'auth/me',
            access: ApiAccess.protected,
            decodeData: (data) => data,
          ),
          throwsA(_failure(FailureKind.unauthorized)),
        );
        expect(adapter.requests, isEmpty);
      }
    },
  );

  test(
    'protected traffic rejects destinations outside the protected API routes',
    () async {
      var tokenReads = 0;
      final container = _container(
        token: () async {
          tokenReads++;
          return 'fixture.token';
        },
      );
      final adapter = FakeAdapter(
        (_, _) => throw StateError('unexpected request'),
      );
      final client = _client(container, adapter);
      for (final path in [
        'https://unrelated.example.test/api/v1/auth/me',
        'http://api.example.test/api/v1/auth/me',
        'https://api.example.test:8443/api/v1/auth/me',
        '../auth/me',
        'properties',
        'health',
        'favorites/example',
      ]) {
        await expectLater(
          requestApi(
            client,
            path,
            access: ApiAccess.protected,
            decodeData: (data) => data,
          ),
          throwsA(_failure(FailureKind.forbidden)),
        );
      }
      expect(adapter.requests, isEmpty);
      expect(tokenReads, 0);
    },
  );

  test('writes attach credentials only to a single favorite ID', () async {
    final adapter = FakeAdapter((_, _) => _body());
    final client = _client(
      _container(token: () async => 'fixture.token'),
      adapter,
    );
    for (final method in ['PUT', 'DELETE']) {
      await requestApi(
        client,
        'favorites/rental-001',
        method: method,
        access: ApiAccess.protected,
        decodeData: (data) => data,
      );
      for (final path in ['auth/me', 'favorites/a/b', 'favorites/a%2Fb']) {
        await expectLater(
          requestApi(
            client,
            path,
            method: method,
            access: ApiAccess.protected,
            decodeData: (data) => data,
          ),
          throwsA(_failure(FailureKind.forbidden)),
        );
      }
    }
    expect(adapter.requests, hasLength(2));
    for (final request in adapter.requests) {
      expect(request.headers['Authorization'], 'Bearer fixture.token');
      expect(request.followRedirects, isFalse);
    }
  });

  test(
    'a token source failure keeps the type and never exposes its message',
    () async {
      final client = _client(
        _container(
          token: () => Future.error(StateError('private token value')),
        ),
        FakeAdapter((_, _) => _body()),
      );
      await expectLater(
        requestApi(
          client,
          'auth/me',
          access: ApiAccess.protected,
          decodeData: (data) => data,
        ),
        throwsA(
          _failure(FailureKind.unexpected)
              .having((error) => error.diagnosticType, 'type', StateError)
              .having(
                (error) => error.toString(),
                'diagnostic',
                isNot(contains('private token')),
              ),
        ),
      );
    },
  );

  test(
    'caller cancellation reaches the adapter and is typed as cancelled',
    () async {
      final started = Completer<void>();
      final finished = Completer<void>();
      final adapter = FakeAdapter((_, cancellation) async {
        started.complete();
        await cancellation!;
        finished.complete();
        return _body();
      });
      final client = _client(_container(), adapter);
      final token = CancelToken();
      final result = requestApi(
        client,
        'health',
        access: ApiAccess.public,
        cancelToken: token,
        decodeData: (data) => data,
      );
      await started.future;
      final check = expectLater(
        result,
        throwsA(_failure(FailureKind.cancelled)),
      );
      token.cancel();
      await finished.future;
      await check;
    },
  );

  for (final (status, kind) in [
    (400, FailureKind.validation),
    (401, FailureKind.unauthorized),
    (403, FailureKind.forbidden),
    (404, FailureKind.notFound),
    (429, FailureKind.rateLimited),
    (500, FailureKind.server),
    (503, FailureKind.serviceUnavailable),
  ]) {
    test(
      'HTTP $status maps to ${kind.name} even without the API envelope',
      () async {
        final client = _client(
          _container(),
          FakeAdapter((_, _) => _body('{}', status)),
        );
        await expectLater(
          requestApi(
            client,
            'health',
            access: ApiAccess.public,
            decodeData: (data) => data,
          ),
          throwsA(
            _failure(kind)
                .having((failure) => failure.statusCode, 'status', status),
          ),
        );
      },
    );
  }

  test(
    'HTTP errors keep sanitized backend codes without printing payloads',
    () async {
      final diagnostics = <String>[];
      final client = _client(
        _container(token: () async => 'fixture.token'),
        FakeAdapter(
          (_, _) => _body(
            '{"success":false,"error":{"code":"UNAUTHORIZED","message":"private server text"}}',
            401,
          ),
        ),
      );
      await runZoned(
        () => expectLater(
          requestApi(
            client,
            'auth/me',
            access: ApiAccess.protected,
            decodeData: (data) => data,
          ),
          throwsA(
            _failure(FailureKind.unauthorized)
                .having((failure) => failure.apiCode, 'code', 'UNAUTHORIZED')
                .having(
                  (failure) => failure.toString(),
                  'diagnostic',
                  isNot(contains('private server text')),
                )
                .having(
                  (failure) => failure.toString(),
                  'diagnostic',
                  isNot(contains('fixture.token')),
                ),
          ),
        ),
        zoneSpecification: ZoneSpecification(
          print: (_, _, _, line) => diagnostics.add(line),
        ),
      );
      expect(diagnostics, isEmpty);
    },
  );

  test('invalid JSON from the adapter maps to a malformed response', () async {
    final client = _client(
      _container(),
      FakeAdapter((_, _) => _body('{broken')),
    );
    await expectLater(
      requestApi(
        client,
        'health',
        access: ApiAccess.public,
        decodeData: (data) => data,
      ),
      throwsA(_failure(FailureKind.malformedResponse)),
    );
  });

  for (final (type, kind) in [
    (DioExceptionType.connectionTimeout, FailureKind.timeout),
    (DioExceptionType.sendTimeout, FailureKind.timeout),
    (DioExceptionType.receiveTimeout, FailureKind.timeout),
    (DioExceptionType.connectionError, FailureKind.connection),
    (DioExceptionType.unknown, FailureKind.unexpected),
  ]) {
    test('transport ${type.name} maps to ${kind.name}', () async {
      final client = _client(
        _container(),
        FakeAdapter((request, _) {
          throw DioException(requestOptions: request, type: type);
        }),
      );
      await expectLater(
        requestApi(
          client,
          'health',
          access: ApiAccess.public,
          decodeData: (data) => data,
        ),
        throwsA(_failure(kind)),
      );
    });
  }

  test('disposing the provider closes its owned adapter', () {
    final container = ProviderContainer(
      overrides: [
        localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
      ],
    );
    final adapter = FakeAdapter((_, _) => _body());
    _client(container, adapter);
    container.dispose();
    expect(adapter.closed, isTrue);
  });
}
