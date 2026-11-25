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
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/data/property_remote_data_source.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_filter_options.dart';
import 'package:real_estate_app/features/properties/domain/property_query.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';

import '../../support/fake_dio_adapter.dart';
import '../../support/memory_locale_preferences.dart';
import 'property_fixtures.dart';

ResponseBody _reply(Object? payload, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(payload),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

TypeMatcher<AppFailure> _failure(FailureKind kind) =>
    isA<AppFailure>().having((error) => error.kind, 'kind', kind);

void main() {
  late ProviderContainer container;
  late Dio client;
  late int tokenReads;

  setUp(() {
    tokenReads = 0;
    container = ProviderContainer.test(
      overrides: [
        localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
        apiTokenSourceProvider.overrideWithValue(() async {
          tokenReads++;
          return 'fixture.token';
        }),
        appConfigProvider.overrideWithValue(
          AppConfig.parse('https://example.test/api/v1'),
        ),
      ],
    );
    client = container.read(dioProvider);
    client.options.headers['Authorization'] = 'Bearer fixture.default';
  });

  (PropertyRepository, FakeAdapter) connect(AdapterResponse respond) {
    final adapter = FakeAdapter(respond);
    client.httpClientAdapter = adapter;
    return (container.read(propertyRepositoryProvider), adapter);
  }

  test(
    'listing uses the public GET path, canonical filters and one request',
    () async {
      final (repository, adapter) = connect(
        (_, _) => _reply(listingEnvelope()),
      );

      final page = await repository.getProperties(
        PropertyQuery(
          page: 2,
          limit: 1,
          search: ' شقة modern ',
          types: {PropertyType.duplex, PropertyType.apartment},
          minPrice: 1225.5,
          minBedrooms: 0,
          featured: false,
          sortBy: PropertySortBy.area,
          sortOrder: SortOrder.asc,
        ),
      );

      final request = adapter.requests.single;
      expect(request.method, 'GET');
      expect(request.uri.path, '/api/v1/properties');
      expect(request.uri.queryParameters, {
        'search': 'شقة modern',
        'types': 'apartment,duplex',
        'minPrice': '1225.5',
        'minBedrooms': '0',
        'featured': 'false',
        'sortBy': 'area',
        'sortOrder': 'asc',
        'page': '2',
        'limit': '1',
      });
      expect(request.headers['Accept-Language'], 'en');
      expect(request.headers['Authorization'], isNull);
      expect(tokenReads, 0);
      expect(page.items.single.id, 'rental-022');
      expect(page.items.single.title, 'Eastside Staircase Duplex');
      expect(() => page.items.clear(), throwsUnsupportedError);
      expect(page.pagination.page, 2);
      expect(page.pagination.limit, 1);
      expect(page.pagination.total, 30);
      expect(page.pagination.totalPages, 30);
      expect(page.pagination.hasNextPage, isTrue);
      expect(page.pagination.hasPreviousPage, isTrue);
    },
  );

  test(
    'details and filters use distinct public paths and request-time Arabic',
    () async {
      final (repository, adapter) = connect(
        (request, _) => _reply({
          'success': true,
          'data': request.uri.path.endsWith('filter-options')
              ? filterOptionsJson(arabic: true)
              : detailsJson(arabic: true),
        }),
      );

      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.arabic);
      final details = await repository.getPropertyDetails('rental_022.~dev');
      final filters = await repository.getFilterOptions();

      expect(adapter.requests.map((request) => request.uri.toString()), [
        'https://example.test/api/v1/properties/rental_022.~dev',
        'https://example.test/api/v1/properties/filter-options',
      ]);
      for (final request in adapter.requests) {
        expect(request.method, 'GET');
        expect(request.headers['Accept-Language'], 'ar');
        expect(request.headers['Authorization'], isNull);
      }
      expect(tokenReads, 0);
      expect(details.summary.title, 'دوبلكس بدرج داخلي في شرق أوستن');
      expect(details.reviews.single.comment, 'كان وجود حمام ثانٍ مريحاً.');
      expect(filters.types.single.label, 'دوبلكس');
    },
  );

  test(
    'rejects unsafe IDs and the reserved filter route before transport',
    () async {
      final (repository, adapter) = connect(
        (_, _) => fail('Unexpected request'),
      );
      for (final id in [
        '',
        '.',
        '..',
        'a/b',
        'a?b',
        'a#b',
        'a%2Fb',
        'a\n',
        'a' * 129,
      ]) {
        await expectLater(
          repository.getPropertyDetails(id),
          throwsA(_failure(FailureKind.validation)),
        );
      }
      await expectLater(
        repository.getPropertyDetails('filter-options'),
        throwsA(_failure(FailureKind.notFound)),
      );
      expect(adapter.requests, isEmpty);
    },
  );

  test('empty and out-of-range listing pages keep server metadata', () async {
    final (repository, _) = connect(
      (_, _) => _reply({
        'success': true,
        'data': [],
        'pagination': {
          'page': 50,
          'limit': 20,
          'total': 30,
          'totalPages': 2,
          'hasNextPage': false,
          'hasPreviousPage': true,
        },
      }),
    );
    final page = await repository.getProperties(PropertyQuery(page: 50));

    expect(page.items, isEmpty);
    expect(page.pagination.page, 50);
    expect(page.pagination.hasNextPage, isFalse);
    expect(page.pagination.hasPreviousPage, isTrue);
  });

  test('maps network errors without retry', () async {
    final (repository, adapter) = connect((request, _) {
      throw DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      );
    });
    await expectLater(
      repository.getProperties(PropertyQuery()),
      throwsA(_failure(FailureKind.connection)),
    );
    expect(adapter.requests, hasLength(1));
  });

  for (final (status, code, kind) in [
    (500, 'INTERNAL_SERVER_ERROR', FailureKind.server),
    (404, 'PROPERTY_NOT_FOUND', FailureKind.notFound),
  ]) {
    test('surfaces HTTP $status as a typed failure', () async {
      final (repository, adapter) = connect(
        (_, _) => _reply({
          'success': false,
          'error': {'code': code, 'message': 'Fixture diagnostic'},
        }, status: status),
      );

      await expectLater(
        repository.getPropertyDetails('rental-022'),
        throwsA(
          _failure(kind)
              .having((error) => error.statusCode, 'statusCode', status)
              .having((error) => error.apiCode, 'apiCode', code),
        ),
      );
      expect(adapter.requests, hasLength(1));
    });
  }

  for (final (issue, response) in <(String, Object)>[
    (
      'missing pagination',
      {
        'success': true,
        'data': [summaryJson()],
      },
    ),
    ('null pagination', {...listingEnvelope(), 'pagination': null}),
    ('non-list payload', {...listingEnvelope(), 'data': summaryJson()}),
    (
      'missing required title',
      {
        ...listingEnvelope(),
        'data': [summaryJson()..remove('title')],
      },
    ),
    (
      'malformed required price',
      {
        ...listingEnvelope(),
        'data': [
          {...summaryJson(), 'price': '2750'},
        ],
      },
    ),
  ]) {
    test('maps $issue to malformed response', () async {
      final (repository, _) = connect((_, _) => _reply(response));
      await expectLater(
        repository.getProperties(PropertyQuery()),
        throwsA(_failure(FailureKind.malformedResponse)),
      );
    });
  }

  test('pre-cancelled property requests never reach the adapter', () async {
    final (repository, adapter) = connect((_, _) => fail('Unexpected request'));
    final cancellation = RequestCancellation()..cancel();

    await expectLater(
      repository.getProperties(PropertyQuery(), cancellation: cancellation),
      throwsA(_failure(FailureKind.cancelled)),
    );
    await expectLater(
      repository.getPropertyDetails('rental-022', cancellation: cancellation),
      throwsA(_failure(FailureKind.cancelled)),
    );
    await expectLater(
      repository.getFilterOptions(cancellation: cancellation),
      throwsA(_failure(FailureKind.cancelled)),
    );
    expect(adapter.requests, isEmpty);
  });

  test('cancels a pending request without closing the shared client', () async {
    final started = Completer<void>();
    final (repository, adapter) = connect((_, cancelFuture) async {
      if (!started.isCompleted) {
        started.complete();
        await cancelFuture!;
      }
      return _reply(listingEnvelope());
    });
    final cancellation = RequestCancellation();
    final result = repository.getProperties(
      PropertyQuery(),
      cancellation: cancellation,
    );
    final checked = expectLater(
      result,
      throwsA(_failure(FailureKind.cancelled)),
    );
    await started.future;
    cancellation.cancel();
    cancellation.cancel();
    await checked;

    expect(
      (await repository.getProperties(PropertyQuery())).items,
      hasLength(1),
    );
    expect(adapter.requests, hasLength(2));
    expect(adapter.closed, isFalse);
  });

  test('late filter data from a previous locale is cancelled', () async {
    final started = Completer<void>();
    final oldResponse = Completer<ResponseBody>();
    final (repository, adapter) = connect((request, _) {
      if (request.headers['Accept-Language'] == 'en') {
        started.complete();
        return oldResponse.future;
      }
      return _reply({'success': true, 'data': filterOptionsJson(arabic: true)});
    });

    final oldResult = expectLater(
      repository.getFilterOptions(),
      throwsA(_failure(FailureKind.cancelled)),
    );
    await started.future;
    await container.read(appLocaleProvider.notifier).select(AppLanguage.arabic);
    expect((await repository.getFilterOptions()).types.single.label, 'دوبلكس');
    oldResponse.complete(
      _reply({'success': true, 'data': filterOptionsJson()}),
    );
    await oldResult;
    expect(adapter.requests, hasLength(2));
  });

  test('provider graph accepts a data source override', () async {
    final overrideClient = Dio(
      BaseOptions(baseUrl: 'https://override.test/api/v1/'),
    );
    addTearDown(() => overrideClient.close(force: true));
    final adapter = FakeAdapter((_, _) => _reply(listingEnvelope()));
    overrideClient.httpClientAdapter = adapter;
    final overrides = ProviderContainer.test(
      overrides: [
        propertyRemoteDataSourceProvider.overrideWithValue(
          PropertyRemoteDataSource(overrideClient),
        ),
      ],
    );

    final repository = overrides.read(propertyRepositoryProvider);
    expect(
      (await repository.getProperties(PropertyQuery())).items,
      hasLength(1),
    );
    expect(adapter.requests.single.uri.host, 'override.test');
  });

  test('application consumers can override the domain repository directly', () {
    final fake = _FakeRepository();
    final overrides = ProviderContainer.test(
      overrides: [propertyRepositoryProvider.overrideWithValue(fake)],
    );

    expect(overrides.read(propertyRepositoryProvider), same(fake));
  });

  test(
    'disposes unobserved dependencies while keeping the shared client',
    () async {
      final (_, adapter) = connect((_, _) => _reply(listingEnvelope()));
      final subscription = container.listen(
        propertyRepositoryProvider,
        (_, _) {},
      );
      final repository = subscription.read();
      final remote = container.read(propertyRemoteDataSourceProvider);

      subscription.close();
      await container.pump();
      await container.pump();

      expect(
        container.read(propertyRepositoryProvider),
        isNot(same(repository)),
      );
      expect(
        container.read(propertyRemoteDataSourceProvider),
        isNot(same(remote)),
      );
      expect(container.read(dioProvider), same(client));
      expect(adapter.closed, isFalse);
    },
  );
}

final class _FakeRepository implements PropertyRepository {
  @override
  Future<PaginatedResult<PropertySummary>> getProperties(
    PropertyQuery query, {
    RequestCancellation? cancellation,
  }) async => throw UnimplementedError();

  @override
  Future<PropertyDetails> getPropertyDetails(
    String propertyId, {
    RequestCancellation? cancellation,
  }) async => throw UnimplementedError();

  @override
  Future<PropertyFilterOptions> getFilterOptions({
    RequestCancellation? cancellation,
  }) async => throw UnimplementedError();
}
