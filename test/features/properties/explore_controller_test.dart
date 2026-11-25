import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/features/properties/application/explore_controller.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_query.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';

import '../../support/memory_locale_preferences.dart';
import 'home_fakes.dart';

ProviderContainer createExploreContainer(FakeHomeRepository repository) {
  final container = ProviderContainer.test(
    overrides: [
      propertyRepositoryProvider.overrideWithValue(repository),
      localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
    ],
  );
  container.listen(exploreControllerProvider, (_, _) {});
  return container;
}

void main() {
  test('uses page one, twenty items, and no initial filters', () async {
    final repo = FakeHomeRepository(
      loadListings: (query, _) => resultPage(query.page, ['a']),
      loadOptions: homeTestOptions,
    );
    final container = createExploreContainer(repo);
    final controller = container.read(exploreControllerProvider.notifier);
    await controller.start();
    await controller.start();

    expect(repo.queries, [PropertyQuery()]);
    final state = container.read(exploreControllerProvider);
    expect(state.items.single.id, 'a');
    expect(state.pagination!.total, 30);
    expect(state.loading, isNull);
  });

  test('blocks duplicate page requests, appends in order and stops at the last page', () async {
    final pending = Completer<PaginatedResult<PropertySummary>>();
    final repo = FakeHomeRepository(
      loadListings: (query, _) => query.page == 1
          ? resultPage(1, ['a', 'b'], more: true)
          : pending.future,
      loadOptions: homeTestOptions,
    );
    final container = createExploreContainer(repo);
    final controller = container.read(exploreControllerProvider.notifier);
    await controller.start();
    final page = controller.loadMore();
    await controller.loadMore();
    expect(repo.queries.map((query) => query.page), [1, 2]);
    expect(container.read(exploreControllerProvider).loading, ExploreLoad.next);
    pending.complete(resultPage(2, ['b', 'c', 'c', 'd']));
    await page;
    await controller.loadMore();
    expect(
      container.read(exploreControllerProvider).items.map((item) => item.id),
      ['a', 'b', 'c', 'd'],
    );
    expect(repo.queries, hasLength(2));
  });

  test(
    'retains successful data and retries the exact failed page explicitly',
    () async {
      var failures = 0;
      final repo = FakeHomeRepository(
        loadListings: (query, _) {
          if (query.page == 1) return resultPage(1, ['a'], more: true);
          if (failures++ == 0) throw const AppFailure(FailureKind.connection);
          return resultPage(2, ['c']);
        },
        loadOptions: homeTestOptions,
      );
      final container = createExploreContainer(repo);
      final controller = container.read(exploreControllerProvider.notifier);
      await controller.start();
      await controller.loadMore();
      await controller.loadMore();
      final failed = container.read(exploreControllerProvider);
      expect(failed.items.single.id, 'a');
      expect(failed.failure?.operation, ExploreLoad.next);
      expect(repo.queries, hasLength(2));
      await controller.retry();
      expect(repo.queries.map((query) => query.page), [1, 2, 2]);
      expect(
        container.read(exploreControllerProvider).items.map((item) => item.id),
        ['a', 'c'],
      );
    },
  );

  test(
    'halts automatic paging when the response adds no unique property',
    () async {
      final repo = FakeHomeRepository(
        loadListings: (query, _) => resultPage(query.page, ['a'], more: true),
        loadOptions: homeTestOptions,
      );
      final container = createExploreContainer(repo);
      final controller = container.read(exploreControllerProvider.notifier);
      await controller.start();
      await controller.loadMore();
      await controller.loadMore();

      expect(repo.queries, hasLength(2));
      expect(container.read(exploreControllerProvider).pagingStalled, isTrue);
    },
  );

  test('query changes cancel obsolete pages and preserve the newly applied filters', () async {
    final pending = Completer<PaginatedResult<PropertySummary>>();
    final repo = FakeHomeRepository(
      loadListings: (query, _) => query.page > 1
          ? pending.future
          : resultPage(1, [
              query.types.isEmpty ? 'original' : 'condo',
            ], more: query.types.isEmpty),
      loadOptions: homeTestOptions,
    );
    final container = createExploreContainer(repo);
    final controller = container.read(exploreControllerProvider.notifier);
    await controller.start(
      PropertyQuery(sortBy: PropertySortBy.price, search: 'loft'),
    );
    final old = controller.loadMore();
    final updated = repo.queries.first.copyWith(
      types: {PropertyType.condo},
      maxPrice: 1500,
    );
    await controller.setQuery(updated);
    expect(repo.listingCancellations[1].isCancelled, isTrue);
    pending.complete(resultPage(2, ['obsolete']));
    await old;

    final state = container.read(exploreControllerProvider);
    expect(state.items.single.id, 'condo');
    expect(state.query, updated);
    expect(state.pagination!.page, 1);
  });

  test(
    'refresh keeps previous results until the new first page resolves',
    () async {
      final pending = Completer<PaginatedResult<PropertySummary>>();
      var pageOne = 0;
      final repo = FakeHomeRepository(
        loadListings: (query, _) =>
            pageOne++ == 0 ? resultPage(1, ['previous']) : pending.future,
        loadOptions: homeTestOptions,
      );
      final container = createExploreContainer(repo);
      final controller = container.read(exploreControllerProvider.notifier);
      await controller.start();
      final refresh = controller.refresh();
      expect(
        container.read(exploreControllerProvider).items.single.id,
        'previous',
      );
      expect(
        container.read(exploreControllerProvider).loading,
        ExploreLoad.refresh,
      );
      pending.complete(resultPage(1, ['replacement']));
      await refresh;
      expect(
        container.read(exploreControllerProvider).items.single.id,
        'replacement',
      );
    },
  );

  test(
    'locale reload cancels the previous response and preserves applied values',
    () async {
      final pending = Completer<PaginatedResult<PropertySummary>>();
      var calls = 0;
      final repo = FakeHomeRepository(
        loadListings: (query, _) =>
            calls++ == 0 ? pending.future : resultPage(1, ['arabic']),
        loadOptions: homeTestOptions,
      );
      final container = createExploreContainer(repo);
      final controller = container.read(exploreControllerProvider.notifier);
      final query = PropertyQuery(
        types: {PropertyType.condo},
        minBathrooms: 2,
        search: 'بيت',
      );
      final old = controller.start(query);
      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.arabic);
      await container.pump();

      expect(repo.listingCancellations.first.isCancelled, isTrue);
      pending.complete(resultPage(1, ['old']));
      await old;
      final state = container.read(exploreControllerProvider);
      expect(state.language, AppLanguage.arabic);
      expect(state.query, query);
      expect(state.items.single.id, 'arabic');
    },
  );
}
