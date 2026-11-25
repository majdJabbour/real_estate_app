import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/features/properties/application/home_providers.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_query.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';

import '../../support/memory_locale_preferences.dart';
import 'home_fakes.dart';

ProviderContainer _container(FakeHomeRepository repository) =>
    ProviderContainer.test(
      overrides: [
        localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
        propertyRepositoryProvider.overrideWithValue(repository),
      ],
    );

void main() {
  test(
    'Home uses independent default queries and one options request',
    () async {
      final repo = FakeHomeRepository(
        loadListings: (query, _) => homePage([homeProperty('id')]),
        loadOptions: homeTestOptions,
      );
      final container = _container(repo);
      container.listen(homeFeaturedProvider, (_, _) {});
      container.listen(homeRecommendationsProvider, (_, _) {});
      container.listen(propertyFilterOptionsProvider, (_, _) {});
      await container.read(homeFeaturedProvider.future);
      await container.read(homeRecommendationsProvider.future);
      await container.read(propertyFilterOptionsProvider.future);

      expect(repo.queries, [
        PropertyQuery(featured: true, limit: 5),
        PropertyQuery(limit: 6),
      ]);
      expect(repo.filterCancellations, hasLength(1));
    },
  );

  test(
    'changing category cancels recommendations and drops the older result',
    () async {
      final pending = <Completer<PaginatedResult<PropertySummary>>>[];
      final repo = FakeHomeRepository(
        loadListings: (query, _) {
          if (query.featured == true) {
            return homePage([homeProperty('featured')]);
          }
          final request = Completer<PaginatedResult<PropertySummary>>();
          pending.add(request);
          return request.future;
        },
        loadOptions: homeTestOptions,
      );
      final container = _container(repo);
      container.listen(homeFeaturedProvider, (_, _) {});
      container.listen(homeRecommendationsProvider, (_, _) {});
      container.listen(propertyFilterOptionsProvider, (_, _) {});
      await container.read(homeFeaturedProvider.future);
      final oldToken = repo.listingCancellations.last;
      container.read(homeCategoryProvider.notifier).select(PropertyType.condo);
      final next = container.read(homeRecommendationsProvider.future);
      expect(oldToken.isCancelled, isTrue);
      expect(
        repo.queries.last,
        PropertyQuery(types: {PropertyType.condo}, limit: 6),
      );

      pending.last.complete(homePage([homeProperty('condo')]));
      expect((await next).single.id, 'condo');
      pending.first.complete(homePage([homeProperty('obsolete')]));
      await container.pump();
      expect(
        container.read(homeRecommendationsProvider).requireValue.single.id,
        'condo',
      );
      expect(
        repo.queries.where((query) => query.featured == true),
        hasLength(1),
      );
      expect(repo.filterCancellations, hasLength(1));

      container.read(homeCategoryProvider.notifier).select(null);
      final all = container.read(homeRecommendationsProvider.future);
      pending.last.complete(homePage([]));
      expect(await all, isEmpty);
      expect(repo.queries.last, PropertyQuery(limit: 6));
    },
  );

  test(
    'locale change preserves the category and rejects a late English result',
    () async {
      late ProviderContainer container;
      final pending = Completer<PaginatedResult<PropertySummary>>();
      final repo = FakeHomeRepository(
        loadListings: (query, _) {
          final arabic =
              container.read(appLocaleProvider) == AppLanguage.arabic;
          return arabic
              ? homePage([homeProperty('ar', arabic: true)])
              : pending.future;
        },
        loadOptions: () => homeTestOptions(
          arabic: container.read(appLocaleProvider) == AppLanguage.arabic,
        ),
      );
      container = _container(repo);
      container.listen(homeCategoryProvider, (_, _) {});
      container
          .read(homeCategoryProvider.notifier)
          .select(PropertyType.townhome);
      container.listen(homeFeaturedProvider, (_, _) {});
      container.listen(homeRecommendationsProvider, (_, _) {});
      container.listen(propertyFilterOptionsProvider, (_, _) {});
      final englishTokens = [...repo.listingCancellations];

      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.arabic);
      final featured = await container.read(homeFeaturedProvider.future);
      final recommended = await container.read(
        homeRecommendationsProvider.future,
      );
      final categories = await container.read(
        propertyFilterOptionsProvider.future,
      );

      expect(featured.single.title, contains('دوبلكس'));
      expect(recommended.single.title, contains('دوبلكس'));
      expect(categories.types.first.label, 'منزل متلاصق');
      expect(container.read(homeCategoryProvider), PropertyType.townhome);
      expect(repo.queries.last.types, {PropertyType.townhome});
      expect(englishTokens.every((token) => token.isCancelled), isTrue);
      expect(repo.filterCancellations.first.isCancelled, isTrue);

      pending.complete(homePage([homeProperty('stale')]));
      await container.pump();
      expect(container.read(homeFeaturedProvider).requireValue.single.id, 'ar');
      expect(
        container.read(homeRecommendationsProvider).requireValue.single.id,
        'ar',
      );
    },
  );

  test(
    'same-query refresh retains values and only reruns the requested section',
    () async {
      final pending = Completer<PaginatedResult<PropertySummary>>();
      var featuredCalls = 0;
      final repo = FakeHomeRepository(
        loadListings: (query, _) {
          if (query.featured == true && featuredCalls++ > 0) {
            return pending.future;
          }
          return homePage([homeProperty('first')]);
        },
        loadOptions: homeTestOptions,
      );
      final container = _container(repo);
      container.listen(homeFeaturedProvider, (_, _) {});
      container.listen(homeRecommendationsProvider, (_, _) {});
      await container.read(homeFeaturedProvider.future);
      await container.read(homeRecommendationsProvider.future);
      final refreshed = container.refresh(homeFeaturedProvider.future);

      final state = container.read(homeFeaturedProvider);
      expect(state.isRefreshing, isTrue);
      expect(state.requireValue.single.id, 'first');
      pending.complete(homePage([homeProperty('updated')]));
      expect((await refreshed).single.id, 'updated');
      expect(
        repo.queries.where((query) => query.featured == null),
        hasLength(1),
      );
    },
  );

  test(
    'typed cancellation is never retried and manual retry remains independent',
    () async {
      var calls = 0;
      final repo = FakeHomeRepository(
        loadListings: (query, _) {
          if (query.featured == true && calls++ == 0) {
            throw const AppFailure(FailureKind.cancelled);
          }
          return homePage([homeProperty('retried')]);
        },
        loadOptions: homeTestOptions,
      );
      final container = _container(repo);
      container.listen(homeFeaturedProvider, (_, _) {});
      container.listen(homeRecommendationsProvider, (_, _) {});
      await expectLater(
        container.read(homeFeaturedProvider.future),
        throwsA(isA<AppFailure>()),
      );
      await container.pump();
      expect(calls, 1);
      expect(
        (await container.refresh(homeFeaturedProvider.future)).single.id,
        'retried',
      );
      expect(
        repo.queries.where((query) => query.featured == null),
        hasLength(1),
      );
    },
  );

  test('unobserved Home requests are cancelled on disposal', () async {
    final pending = Completer<PaginatedResult<PropertySummary>>();
    final repo = FakeHomeRepository(
      loadListings: (_, _) => pending.future,
      loadOptions: homeTestOptions,
    );
    final container = _container(repo);
    final subscription = container.listen(homeFeaturedProvider, (_, _) {});
    subscription.close();
    await container.pump();

    expect(repo.listingCancellations.single.isCancelled, isTrue);
    pending.complete(homePage([]));
  });
}
