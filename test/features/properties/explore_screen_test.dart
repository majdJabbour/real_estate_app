import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/app/navigation/app_router.dart';
import 'package:real_estate_app/app/navigation/temporary_destinations.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/design_system/design_controls.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/features/properties/application/explore_controller.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_filter_options.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';
import 'package:real_estate_app/features/properties/domain/property_type.dart';
import 'package:real_estate_app/features/properties/presentation/explore/explore_screen.dart';
import 'package:real_estate_app/features/properties/presentation/filters/property_filter_sheet.dart';
import 'package:real_estate_app/features/properties/presentation/filters/property_range_control.dart';
import 'package:real_estate_app/features/properties/presentation/widgets/property_cards.dart';

import '../../support/memory_locale_preferences.dart';
import 'home_fakes.dart';

FakeHomeRepository repository({bool arabic = false}) => FakeHomeRepository(
  loadListings: (query, _) => homePage([
    for (var i = 1; i <= 6; i++) homeProperty('item-$i', arabic: arabic),
  ]),
  loadOptions: () => homeTestOptions(arabic: arabic),
);

Future<ProviderContainer> pumpApp(
  WidgetTester tester,
  FakeHomeRepository repo, {
  Size size = const Size(430, 932),
  bool arabic = false,
  double scale = 1,
  AppThemeVariant variant = AppThemeVariant.blue,
  bool openExplore = true,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() async {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    await tester.binding.setSurfaceSize(null);
  });
  final container = ProviderContainer.test(
    overrides: [
      propertyRepositoryProvider.overrideWithValue(repo),
      localePreferencesProvider.overrideWithValue(
        MemoryLocalePreferences(arabic ? 'ar' : 'en'),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RealEstateApp(variant: variant),
    ),
  );
  await tester.pumpAndSettle();
  if (openExplore) {
    container.read(appRouterProvider).go('/explore');
    await tester.pumpAndSettle();
  }
  return container;
}

Future<void> openFilters(WidgetTester tester, {bool arabic = false}) async {
  await tester.tap(
    find.byTooltip(arabic ? 'فتح فلاتر العقارات' : 'Open property filters'),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'grid and list share results, count, details navigation and branch state',
    (tester) async {
      final repo = repository();
      await pumpApp(tester, repo);
      expect(find.text('Found 6 properties'), findsOneWidget);
      expect(find.byType(PropertyGridCard), findsWidgets);
      final queries = repo.queries.length;
      await tester.tap(find.bySemanticsLabel('Show list'));
      await tester.pumpAndSettle();
      expect(find.byType(PropertyListCard), findsWidgets);
      expect(repo.queries, hasLength(queries));

      await tester.tap(find.text('Sunlit Townhome item-1').hitTestable());
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<PropertyDetailsDestination>(
              find.byType(PropertyDetailsDestination),
            )
            .propertyId,
        'item-1',
      );
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Explore').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.byType(PropertyListCard), findsWidgets);
      expect(repo.queries, hasLength(queries));
    },
  );

  testWidgets(
    'debounces for 400 ms, cancels old queries, clears and submits immediately',
    (tester) async {
      final pending = Completer<PaginatedResult<PropertySummary>>();
      final repo = FakeHomeRepository(
        loadListings: (query, _) => query.search == 'older'
            ? pending.future
            : homePage([homeProperty(query.search ?? 'all')]),
        loadOptions: homeTestOptions,
      );
      await pumpApp(tester, repo);
      final text = find.byType(TextField);
      final before = repo.queries.length;
      await tester.enterText(text, 'old');
      await tester.pump(const Duration(milliseconds: 390));
      await tester.enterText(text, 'older');
      await tester.pump(const Duration(milliseconds: 399));
      expect(repo.queries, hasLength(before));
      await tester.pump(const Duration(milliseconds: 1));
      expect(repo.queries.last.search, 'older');
      final old = repo.listingCancellations.last;

      await tester.enterText(text, 'بيت');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(repo.queries.last.search, 'بيت');
      expect(old.isCancelled, isTrue);
      pending.complete(homePage([homeProperty('obsolete')]));
      await tester.pumpAndSettle();
      expect(find.textContaining('obsolete'), findsNothing);
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(repo.queries.last.search, isNull);
      expect(repo.queries.last.page, 1);
    },
  );

  testWidgets(
    'editing, cancelling and resetting drafts preserve the applied query',
    (tester) async {
      final repo = repository();
      final container = await pumpApp(
        tester,
        repo,
        size: const Size(430, 1000),
      );
      final initial = repo.queries.length;
      await openFilters(tester);
      await tester.tap(find.text('Townhome').hitTestable().last);
      await tester.tap(find.text('Condo').hitTestable().last);
      await tester.tap(
        find.byTooltip('Increase Minimum bedrooms').hitTestable(),
      );
      await tester.pumpAndSettle();
      expect(repo.queries, hasLength(initial));
      await tester.tap(find.text('Set Filter'));
      await tester.pumpAndSettle();
      expect(repo.queries, hasLength(initial + 1));
      expect(repo.queries.last.types, {
        PropertyType.townhome,
        PropertyType.condo,
      });
      expect(repo.queries.last.minBedrooms, 1);
      expect(repo.queries.last.minPrice, isNull);

      await openFilters(tester);
      final selected = find.byWidgetPredicate(
        (widget) => widget is FilterChip && widget.selected,
      );
      expect(selected, findsNWidgets(2));
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(selected, findsNothing);
      await tester.tap(find.bySemanticsLabel('Cancel'));
      await tester.pumpAndSettle();
      expect(repo.queries, hasLength(initial + 1));
      expect(
        container.read(exploreControllerProvider).query.types,
        hasLength(2),
      );

      await openFilters(tester);
      await tester.tap(find.text('Set Filter'));
      await tester.pumpAndSettle();
      expect(repo.queries, hasLength(initial + 1));
    },
  );

  testWidgets(
    'loads another page when a short first page leaves space in the viewport',
    (tester) async {
      final repo = FakeHomeRepository(
        loadListings: (query, _) => query.limit != 20
            ? homePage([])
            : resultPage(query.page, [
                'page-${query.page}',
              ], more: query.page == 1),
        loadOptions: homeTestOptions,
      );
      await pumpApp(tester, repo, size: const Size(430, 1050));
      expect(
        repo.queries
            .where((query) => query.limit == 20)
            .map((query) => query.page),
        [1, 2],
      );
      expect(find.text('Found 30 properties'), findsOneWidget);
      expect(find.text('Sunlit Townhome page-2'), findsOneWidget);
    },
  );

  testWidgets(
    'shows a local retry for an initial failure and then the empty state',
    (tester) async {
      var attempts = 0;
      final repo = FakeHomeRepository(
        loadListings: (query, _) {
          if (query.limit == 20 && attempts++ == 0) {
            throw const AppFailure(FailureKind.connection);
          }
          return homePage([]);
        },
        loadOptions: homeTestOptions,
      );
      await pumpApp(tester, repo);
      expect(find.textContaining('Could not connect'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('No results'), findsOneWidget);
    },
  );

  testWidgets(
    'Home filter intents open once and repeat only after a new Home action',
    (tester) async {
      final repo = repository();
      await pumpApp(tester, repo, openExplore: false);
      await tester.tap(find.byTooltip('Open property filters'));
      await tester.pumpAndSettle();
      expect(find.byType(PropertyFilterSheet), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Explore').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.byType(PropertyFilterSheet), findsNothing);
      await tester.tap(find.text('Home').hitTestable().last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Open property filters'));
      await tester.pumpAndSettle();
      expect(find.byType(PropertyFilterSheet), findsOneWidget);
      expect(repo.filterCancellations, hasLength(1));
    },
  );

  testWidgets('Featured intent can be cleared without a new navigation', (
    tester,
  ) async {
    final repo = repository();
    await pumpApp(tester, repo, openExplore: false);
    await tester.tap(find.text('See All').hitTestable().first);
    await tester.pumpAndSettle();
    expect(repo.queries.last.featured, isTrue);
    await tester.tap(find.byTooltip('Clear featured filter'));
    await tester.pumpAndSettle();
    expect(repo.queries.last.featured, isNull);
    expect(find.byType(ExploreScreen), findsOneWidget);
  });

  testWidgets(
    'mirrors the real slider gesture and server histogram in Arabic',
    (tester) async {
      final options = homeTestOptions(arabic: true);
      final repo = FakeHomeRepository(
        loadListings: (_, _) => homePage([]),
        loadOptions: () => options.copyWith(
          price: options.price.copyWith(
            histogram: const [
              PriceHistogramBucket(from: 975, to: 1700, count: 3),
              PriceHistogramBucket(from: 1700, to: 4250, count: 1),
            ],
          ),
        ),
      );
      final container = await pumpApp(
        tester,
        repo,
        arabic: true,
        size: const Size(430, 1000),
      );
      await openFilters(tester, arabic: true);
      final slider = find.byType(RangeSlider).first;
      final before = tester.widget<RangeSlider>(slider).values;
      final rect = tester.getRect(slider);
      final painter = tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .map((paint) => paint.painter)
          .whereType<PriceHistogramPainter>()
          .single;
      expect(painter.direction, TextDirection.rtl);
      await tester.dragFrom(
        Offset(rect.right - 12, rect.center.dy),
        const Offset(-86, 0),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<RangeSlider>(slider).values.start,
        greaterThan(before.start),
      );
      expect(container.read(exploreControllerProvider).query.minPrice, isNull);
      await tester.tap(find.text('تطبيق الفلاتر'));
      await tester.pumpAndSettle();
      expect(repo.queries.last.minPrice, greaterThan(975));
    },
  );

  testWidgets('equal price, absent area and server room bounds stay usable', (
    tester,
  ) async {
    final sample = homeTestOptions();
    final repo = FakeHomeRepository(
      loadListings: (_, _) => homePage([]),
      loadOptions: () => sample.copyWith(
        price: sample.price.copyWith(
          bounds: (min: 1200, max: 1200),
          histogram: const [
            PriceHistogramBucket(from: 1200, to: 1200, count: 2),
          ],
        ),
        area: (min: null, max: null),
        bedrooms: (min: 2, max: 2),
        bathrooms: (min: null, max: null),
      ),
    );
    await pumpApp(tester, repo, size: const Size(430, 1000));
    await openFilters(tester);
    expect(find.byType(RangeSlider), findsNothing);
    expect(find.text(r'$1,200/mo'), findsOneWidget);
    expect(find.text('Range unavailable'), findsOneWidget);
    final increment = find.byWidgetPredicate(
      (widget) =>
          widget is IconButton && widget.tooltip == 'Increase Minimum bedrooms',
    );
    expect(tester.widget<IconButton>(increment).onPressed, isNotNull);
    await tester.tap(increment);
    await tester.pump();
    expect(tester.widget<IconButton>(increment).onPressed, isNull);
    await tester.tap(find.text('Set Filter'));
    await tester.pumpAndSettle();
    expect(repo.queries.last.minBedrooms, 2);
    expect(repo.queries.last.minPrice, isNull);
  });

  testWidgets(
    'returning from a localized Profile preserves Explore filters and reloads labels',
    (tester) async {
      var arabic = false;
      final repo = FakeHomeRepository(
        loadListings: (_, _) =>
            homePage([homeProperty('localized', arabic: arabic)]),
        loadOptions: () => homeTestOptions(arabic: arabic),
      );
      final container = await pumpApp(tester, repo);
      await tester.tap(find.text('Townhome'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Profile').hitTestable().last);
      await tester.pumpAndSettle();
      arabic = true;
      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('استكشاف').hitTestable().last);
      await tester.pumpAndSettle();
      expect(find.textContaining('دوبلكس مشرق'), findsOneWidget);
      expect(find.text('منزل متلاصق'), findsOneWidget);
      expect(container.read(exploreControllerProvider).query.types, {
        PropertyType.townhome,
      });
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'histogram painting retains bucket width, height and RTL direction',
    (tester) async {
      Future<bool> paintedAt(TextDirection direction, int x, int y) async {
        const size = Size(100, 40);
        final recorder = ui.PictureRecorder();
        PriceHistogramPainter(
          minimum: 0,
          maximum: 100,
          color: Colors.blue,
          direction: direction,
          buckets: const [
            PriceHistogramBucket(from: 0, to: 25, count: 4),
            PriceHistogramBucket(from: 25, to: 100, count: 1),
          ],
        ).paint(ui.Canvas(recorder), size);
        final picture = recorder.endRecording();
        final image = await picture.toImage(100, 40);
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        final alpha = bytes.getUint8((y * 100 + x) * 4 + 3);
        image.dispose();
        picture.dispose();
        return alpha > 0;
      }

      await tester.runAsync(() async {
        expect(await paintedAt(TextDirection.ltr, 10, 5), isTrue);
        expect(await paintedAt(TextDirection.ltr, 85, 5), isFalse);
        expect(await paintedAt(TextDirection.ltr, 85, 36), isTrue);
        expect(await paintedAt(TextDirection.rtl, 90, 5), isTrue);
        expect(await paintedAt(TextDirection.rtl, 15, 5), isFalse);
      });
    },
  );

  test('range normalization snaps full endpoints to unrestricted values', () {
    const bounds = (min: 0.005, max: 12.347);
    expect(unrestrictedEndpoints(bounds, const RangeValues(0.005, 12.347)), (
      min: null,
      max: null,
    ));
    expect(rangeWithinBounds(bounds, 0, 99), const RangeValues(0.005, 12.347));
    expect(unrestrictedEndpoints(bounds, const RangeValues(2.213, 8.256)), (
      min: 2.21,
      max: 8.26,
    ));
  });

  for (final (width, height, variant) in [
    (320.0, 590.0, AppThemeVariant.blue),
    (768.0, 920.0, AppThemeVariant.purple),
    (852.0, 390.0, AppThemeVariant.orange),
  ]) {
    testWidgets(
      'renders Explore and reachable Filters at ${width.toInt()} dp in ${variant.name}',
      (tester) async {
        await pumpApp(
          tester,
          repository(arabic: true),
          arabic: true,
          scale: 2,
          size: Size(width, height),
          variant: variant,
        );
        final toggle = find.byWidgetPredicate(
          (widget) => widget is AppIconButton && widget.label == 'عرض القائمة',
        );
        await tester.scrollUntilVisible(
          toggle,
          75,
          scrollable: find.byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(toggle);
        await tester.pumpAndSettle();
        expect(find.byType(PropertyListCard), findsWidgets);
        expect(tester.takeException(), isNull);
        tester
            .widget<CustomScrollView>(
              find.byKey(const PageStorageKey('explore-scroll')),
            )
            .controller!
            .jumpTo(0);
        await tester.pumpAndSettle();
        await openFilters(tester, arabic: true);
        expect(find.text('تطبيق الفلاتر').hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
