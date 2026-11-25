import 'dart:async';
import 'dart:ui' show Tristate;

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/app/navigation/app_router.dart';
import 'package:real_estate_app/app/navigation/app_tab_shell.dart';
import 'package:real_estate_app/app/navigation/explore_intent.dart';
import 'package:real_estate_app/app/navigation/temporary_destinations.dart';
import 'package:real_estate_app/core/design_system/app_icon.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';
import 'package:real_estate_app/features/properties/presentation/explore/explore_screen.dart';
import 'package:real_estate_app/features/properties/presentation/filters/property_filter_sheet.dart';
import 'package:real_estate_app/features/properties/presentation/home/home_screen.dart';
import 'package:real_estate_app/features/properties/presentation/widgets/property_cards.dart';
import 'package:real_estate_app/features/properties/presentation/widgets/property_image.dart';

import '../../support/memory_locale_preferences.dart';
import 'home_fakes.dart';

FakeHomeRepository _repository({bool arabic = false}) => FakeHomeRepository(
  loadListings: (query, _) => homePage([
    for (var i = 0; i < query.limit; i++)
      homeProperty(
        query.featured == true
            ? 'featured-$i'
            : '${query.types.firstOrNull?.id ?? 'recommendation'}-$i',
        arabic: arabic,
        featured: query.featured == true,
      ),
  ]),
  loadOptions: () => homeTestOptions(arabic: arabic),
);

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  FakeHomeRepository? repository,
  Size size = const Size(430, 932),
  AppThemeVariant variant = AppThemeVariant.blue,
  bool arabic = false,
  double scale = 1,
  bool settle = true,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() async {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    await tester.binding.setSurfaceSize(null);
  });
  final container = ProviderContainer.test(
    overrides: [
      localePreferencesProvider.overrideWithValue(
        MemoryLocalePreferences(arabic ? 'ar' : 'en'),
      ),
      propertyRepositoryProvider.overrideWithValue(
        repository ?? _repository(arabic: arabic),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RealEstateApp(variant: variant),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return container;
}

Finder _tab(String name) => find
    .descendant(of: find.byType(AppTabShell), matching: find.text(name))
    .last;

Finder _tabSemantics(String label) => find.byWidgetPredicate(
  (widget) =>
      widget is Semantics &&
      widget.properties.label == label &&
      widget.properties.selected != null,
);

Finder _homeScroll() => find.byKey(const PageStorageKey('home-scroll'));

Future<void> _scrollToFirstGridCard(WidgetTester tester) async {
  await tester.drag(_homeScroll(), const Offset(0, -450));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'starts on Home and preserves the scroll position across tabs and details',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final container = await _pump(tester);
      final router = container.read(appRouterProvider);
      expect(router.routerDelegate.currentConfiguration.uri.path, '/home');
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(
        tester.getSemantics(_tabSemantics('Home')).flagsCollection.isSelected,
        Tristate.isTrue,
      );

      await _scrollToFirstGridCard(tester);
      final card = find.byKey(const ValueKey('recommended-recommendation-0'));
      final cardTop = tester.getTopLeft(card).dy;

      await tester.tap(_tab('Explore'));
      await tester.pumpAndSettle();
      expect(find.byType(ExploreScreen), findsOneWidget);
      expect(
        tester
            .getSemantics(_tabSemantics('Explore'))
            .flagsCollection
            .isSelected,
        Tristate.isTrue,
      );
      await tester.tap(_tab('Profile'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileDestination), findsOneWidget);
      await tester.tap(_tab('Home'));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(card).dy, closeTo(cardTop, 0.5));

      await tester.tap(
        find.descendant(
          of: card,
          matching: find.text('Sunlit Townhome recommendation-0'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(AppTabShell), findsNothing);
      final details = tester.widget<PropertyDetailsDestination>(
        find.byType(PropertyDetailsDestination),
      );
      expect(details.propertyId, 'recommendation-0');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(card).dy, closeTo(cardTop, 0.5));
      semantics.dispose();
    },
  );

  testWidgets(
    'search, filters, and featured See All open the appropriate Explore intent',
    (tester) async {
      await _pump(tester);
      for (final (target, entry) in [
        (find.byType(TextField), ExploreEntry.search),
        (find.byTooltip('Open property filters'), ExploreEntry.filters),
        (find.text('See All').first, ExploreEntry.featured),
      ]) {
        await tester.tap(target);
        await tester.pumpAndSettle();
        final page = tester.widget<ExploreScreen>(find.byType(ExploreScreen));
        expect(page.intent.entry, entry);
        if (entry == ExploreEntry.filters) {
          expect(find.byType(PropertyFilterSheet), findsOneWidget);
          await tester.tap(find.bySemanticsLabel('Cancel'));
          await tester.pumpAndSettle();
        }
        await tester.tap(_tab('Home'));
        await tester.pumpAndSettle();
      }
    },
  );

  testWidgets(
    'category refetches only recommendations and passes its ID to Explore',
    (tester) async {
      final repository = _repository();
      await _pump(tester, repository: repository);
      await tester.drag(_homeScroll(), const Offset(0, -190));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Townhome'));
      await tester.pumpAndSettle();
      expect(repository.queries.last.types, {PropertyType.townhome});
      expect(
        repository.queries.where((query) => query.featured == true),
        hasLength(1),
      );
      expect(repository.filterCancellations, hasLength(1));

      final actions = find.text('See All').hitTestable();
      await tester.tap(actions.last);
      await tester.pumpAndSettle();
      final page = tester.widget<ExploreScreen>(find.byType(ExploreScreen));
      expect(page.intent.entry, ExploreEntry.recommendations);
      expect(page.intent.category, PropertyType.townhome);
    },
  );

  testWidgets(
    'placeholder cards retain geometry and featured failure retries independently',
    (tester) async {
      final pending = Completer<PaginatedResult<PropertySummary>>();
      var featuredCalls = 0;
      final repository = FakeHomeRepository(
        loadListings: (query, _) {
          if (query.featured == true && featuredCalls++ == 0) {
            return pending.future;
          }
          return homePage([
            homeProperty(
              query.featured == true ? 'featured-retried' : 'recommendation',
            ),
          ]);
        },
        loadOptions: homeTestOptions,
      );
      await _pump(tester, repository: repository, settle: false);
      await tester.pump();
      expect(find.byKey(const ValueKey('featured-loading')), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const ValueKey('featured-loading'))).height,
        340,
      );
      pending.completeError(const AppFailure(FailureKind.connection));
      await tester.pumpAndSettle();

      expect(find.textContaining('Could not connect'), findsOneWidget);
      expect(find.text('Sunlit Townhome recommendation'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Sunlit Townhome featured-retried'), findsOneWidget);
      expect(
        repository.queries.where((query) => query.featured == null),
        hasLength(1),
      );
    },
  );

  testWidgets(
    'empty sections and category errors leave the rest of Home available',
    (tester) async {
      final repository = FakeHomeRepository(
        loadListings: (_, _) => homePage([]),
        loadOptions: () => throw const AppFailure(FailureKind.timeout),
      );
      await _pump(tester, repository: repository);
      expect(
        find.text('No featured properties are available.'),
        findsOneWidget,
      );
      expect(find.text('No properties in this category.'), findsOneWidget);
      expect(
        find.text('Categories are unavailable. You can still view properties.'),
        findsOneWidget,
      );
      expect(find.text('All'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(repository.filterCancellations, hasLength(2));
      expect(repository.queries, hasLength(2));
    },
  );

  testWidgets('refreshes all Home reads and keeps the current card visible', (
    tester,
  ) async {
    final pending = Completer<PaginatedResult<PropertySummary>>();
    var featuredCalls = 0;
    final repository = FakeHomeRepository(
      loadListings: (query, _) {
        if (query.featured == true && featuredCalls++ == 1) {
          return pending.future;
        }
        return homePage([homeProperty('before')]);
      },
      loadOptions: homeTestOptions,
    );
    await _pump(tester, repository: repository);
    final refresh = tester
        .widget<RefreshIndicator>(find.byType(RefreshIndicator))
        .onRefresh();
    await tester.pump();
    expect(find.byKey(const ValueKey('featured-before')), findsOneWidget);
    expect(repository.queries, hasLength(4));
    expect(repository.filterCancellations, hasLength(2));
    pending.complete(homePage([homeProperty('after')]));
    await refresh;
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('featured-after')), findsOneWidget);
  });

  testWidgets('cancelled section shows no ordinary error or retry button', (
    tester,
  ) async {
    await _pump(
      tester,
      repository: FakeHomeRepository(
        loadListings: (query, _) {
          if (query.featured == true) {
            throw const AppFailure(FailureKind.cancelled);
          }
          return homePage([homeProperty('available')]);
        },
        loadOptions: homeTestOptions,
      ),
    );
    expect(find.text('Retry'), findsNothing);
    expect(find.text('Something went wrong'), findsNothing);
    expect(find.text('Sunlit Townhome available'), findsOneWidget);
  });

  testWidgets(
    'uses image fallback, formatted prices, and a disabled separate favorite target',
    (tester) async {
      await _pump(tester);
      final card = find.byKey(const ValueKey('featured-featured-0'));
      expect(tester.getSize(card), const Size(250, 340));
      expect(
        find.descendant(of: card, matching: find.text(r'$1,275.50/mo')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: card,
          matching: find.byIcon(Icons.broken_image_outlined),
        ),
        findsOneWidget,
      );
      final favorite = find.descendant(
        of: card,
        matching: find.byTooltip('Favorites require sign-in.'),
      );
      await tester.tap(favorite);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(PropertyDetailsDestination), findsNothing);
      expect(find.byType(PropertyImage), findsWidgets);
    },
  );

  testWidgets(
    'Profile language switch preserves the Home route and localizes the shell',
    (tester) async {
      await _pump(tester);
      await tester.tap(_tab('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();
      expect(find.text('الملف الشخصي'), findsWidgets);
      await tester.tap(_tab('الرئيسية'));
      await tester.pumpAndSettle();
      final greeting = find.text('أهلاً بك');
      expect(greeting, findsOneWidget);
      expect(Directionality.of(tester.element(greeting)), TextDirection.rtl);
    },
  );

  testWidgets('tab taps remain valid while a locale change is saving', (
    tester,
  ) async {
    final container = await _pump(tester);
    final preferences =
        container.read(localePreferencesProvider) as MemoryLocalePreferences;
    final save = Completer<void>();
    preferences.beforeWrite = (_) => save.future;

    await tester.tap(_tab('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية'));
    await tester.pump();
    await tester.tap(_tab('Explore'));
    save.complete();
    await tester.pumpAndSettle();

    expect(find.byType(ExploreScreen), findsOneWidget);
    expect(_tab('استكشاف'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(_tab('الرئيسية'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final (variant, brand) in [
    (AppThemeVariant.blue, const Color(0xFF0061FF)),
    (AppThemeVariant.purple, const Color(0xFF6338C6)),
    (AppThemeVariant.orange, const Color(0xFF9A4500)),
  ]) {
    testWidgets(
      'uses the shared ${variant.name} palette for the selected tab',
      (tester) async {
        await _pump(tester, variant: variant);
        final icon = tester.widget<AppIcon>(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppIcon && widget.icon == AppIcons.homeSelected,
          ),
        );
        expect(icon.color, brand);
        expect(find.byType(FeaturedPropertyCard), findsWidgets);
      },
    );
  }

  for (final size in [
    const Size(320, 690),
    const Size(375, 812),
    const Size(390, 844),
    const Size(430, 932),
    const Size(600, 920),
    const Size(768, 1000),
    const Size(852, 390),
  ]) {
    for (final arabic in [false, true]) {
      testWidgets(
        'fits ${size.width}×${size.height} with ${arabic ? 'Arabic at 2×' : 'English'} data',
        (tester) async {
          await _pump(
            tester,
            size: size,
            arabic: arabic,
            scale: arabic ? 2 : 1,
          );
          final heading = find.text(arabic ? 'عقارات مميزة' : 'Featured');
          expect(
            Directionality.of(tester.element(heading)),
            arabic ? TextDirection.rtl : TextDirection.ltr,
          );
          if (arabic && size.height > 500) {
            expect(find.textContaining('شهرياً'), findsWidgets);
            expect(
              tester.getCenter(_tab('الرئيسية')).dx,
              greaterThan(tester.getCenter(_tab('الملف الشخصي')).dx),
            );
          }
          final firstGridCard = find.byKey(
            const ValueKey('recommended-recommendation-0'),
          );
          await tester.scrollUntilVisible(
            firstGridCard,
            180,
            scrollable: find
                .byWidgetPredicate(
                  (widget) =>
                      widget is Scrollable &&
                      widget.axisDirection == AxisDirection.down,
                )
                .first,
          );
          await tester.pumpAndSettle();
          if (arabic) {
            expect(
              find.descendant(
                of: firstGridCard,
                matching: find.textContaining('شهرياً'),
              ),
              findsOneWidget,
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
