import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/app/navigation/app_router.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/presentation/details/property_gallery.dart';
import 'package:real_estate_app/features/properties/presentation/widgets/property_favorite_button.dart';

import '../../support/memory_locale_preferences.dart';
import 'home_fakes.dart';

Future<ProviderContainer> _open(
  WidgetTester tester,
  DetailsLoader loader, {
  Size size = const Size(430, 932),
  double scale = 1,
  bool arabic = false,
  AppThemeVariant variant = AppThemeVariant.blue,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = scale;
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
  final repo = FakeHomeRepository(
    loadListings: (_, _) => homePage([]),
    loadOptions: homeTestOptions,
    loadDetails: loader,
  );
  final container = ProviderContainer.test(
    overrides: [
      propertyRepositoryProvider.overrideWithValue(repo),
      localePreferencesProvider.overrideWithValue(
        MemoryLocalePreferences(arabic ? 'ar' : 'en'),
      ),
    ],
  );
  container.read(appRouterProvider).go('/properties/rental-001');
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RealEstateApp(variant: variant),
    ),
  );
  await tester.pump();
  return container;
}

Future<void> _reveal(WidgetTester tester, Finder finder) =>
    tester.scrollUntilVisible(
      finder,
      220,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );

void main() {
  testWidgets('direct entry loads, renders real values and can return home', (
    tester,
  ) async {
    final request = Completer<PropertyDetails>();
    final container = await _open(tester, (id, _) {
      expect(id, 'rental-001');
      return request.future;
    });
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byTooltip('Back'), findsOneWidget);
    request.complete(
      homeDetails('rental-001', facilities: ['gym', 'future-amenity']),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sunlit Townhome rental-001'), findsOneWidget);
    expect(find.text('Townhome'), findsOneWidget);
    expect(find.text('2 bedrooms'), findsOneWidget);
    expect(find.text('1 bathroom'), findsOneWidget);
    expect(find.text('85.5 m²'), findsOneWidget);
    expect(find.text(r'$1,275.50'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Favorites require sign-in.'),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<IconButton>(
            find.descendant(
              of: find.byType(PropertyFavoriteButton),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNull,
    );
    expect(find.byTooltip('Share'), findsNothing);
    expect(find.byType(PageView), findsNothing);
    expect(find.byType(InteractiveViewer), findsNothing);

    await _reveal(tester, find.text('Olivia Perez'));
    expect(find.byIcon(Icons.person_outline), findsWidgets);
    expect(find.byTooltip('Call'), findsNothing);
    expect(find.byTooltip('Chat'), findsNothing);
    await _reveal(tester, find.text('future amenity'));
    expect(find.byIcon(Icons.category_outlined), findsOneWidget);
    expect(find.text('Gym'), findsOneWidget);
    await _reveal(tester, find.text('No photos available.'));
    await _reveal(tester, find.text('Open in Maps'));
    expect(find.text('Garden District, Austin, TX'), findsOneWidget);
    await _reveal(tester, find.text('No reviews available.'));
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 2500));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(
      container.read(appRouterProvider).routeInformationProvider.value.uri.path,
      '/home',
    );
  });

  testWidgets(
    'map handoff uses API coordinates and retains the address on failure',
    (tester) async {
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      final messenger = tester.binding.defaultBinaryMessenger;
      MethodCall? launch;
      messenger.setMockMethodCallHandler(channel, (call) async {
        launch = call;
        return false;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      await _open(tester, (id, _) => homeDetails(id));
      await tester.pumpAndSettle();
      final mapAction = find.text('Open in Maps');
      await _reveal(tester, mapAction);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -180));
      await tester.pumpAndSettle();
      await tester.tap(mapAction);
      await tester.pumpAndSettle();

      expect(launch?.method, 'launch');
      final arguments = launch!.arguments as Map<Object?, Object?>;
      final uri = Uri.parse(arguments['url']! as String);
      expect(uri.host, 'www.google.com');
      expect(uri.path, '/maps/search/');
      expect(uri.queryParameters['api'], '1');
      final location = homeDetails('rental-001').location!;
      expect(
        uri.queryParameters['query'],
        '${location.latitude},${location.longitude}',
      );
      expect(find.text('Could not open Maps.'), findsOneWidget);
      expect(find.text('Garden District, Austin, TX'), findsOneWidget);
    },
  );

  testWidgets('invalid map coordinates leave the fictional address visible', (
    tester,
  ) async {
    await _open(
      tester,
      (id, _) => homeDetails(id).copyWith(
        location: const PropertyLocation(latitude: 91, longitude: -181),
      ),
    );
    await tester.pumpAndSettle();
    await _reveal(tester, find.text('Demo location for a fictional listing.'));
    expect(find.text('Garden District, Austin, TX'), findsOneWidget);
    expect(find.text('Open in Maps'), findsNothing);
  });

  for (final (kind, message) in [
    (FailureKind.notFound, 'This item could not be found.'),
    (FailureKind.validation, 'Check the information and try again.'),
    (
      FailureKind.connection,
      'Could not connect. Check your connection and try again.',
    ),
    (FailureKind.server, 'The server could not complete the request.'),
  ]) {
    testWidgets('shows ${kind.name} and retries the same ID', (tester) async {
      var calls = 0;
      await _open(tester, (id, _) {
        expect(id, 'rental-001');
        if (++calls == 1) throw AppFailure(kind);
        return homeDetails(id);
      });
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
      expect(find.byTooltip('Back'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text('Sunlit Townhome rental-001'), findsOneWidget);
    });
  }

  testWidgets('a single image opens without carousel dots and closes', (
    tester,
  ) async {
    await _open(tester, (id, _) => homeDetails(id, images: ['']));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Photo 1 of 1'), findsNothing);
    await tester.tap(find.bySemanticsLabel('Open photo 1 of 1').hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('Photo 1 of 1'), findsOneWidget);
    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(InteractiveViewer), findsNothing);
  });

  testWidgets(
    'swipes the hero and viewer and opens the indexed overflow thumbnail',
    (tester) async {
      await _open(
        tester,
        (id, _) => homeDetails(id, images: ['1', '2', '3', '4']),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Photo 2 of 4'), findsOneWidget);
      await tester.tap(
        find.bySemanticsLabel('Open photo 2 of 4').hitTestable(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Photo 2 of 4'), findsOneWidget);
      await tester.drag(find.byType(PageView), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(find.text('Photo 3 of 4'), findsOneWidget);
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      await _reveal(tester, find.byType(PropertyGallery));
      await _reveal(tester, find.text('+1'));
      await tester.tap(
        find.bySemanticsLabel('Open gallery, 1 more photo').hitTestable(),
      );
      await tester.pumpAndSettle();
      expect(find.text('Photo 3 of 4'), findsOneWidget);
    },
  );

  testWidgets('pinching a viewer photo zooms without changing pages', (
    tester,
  ) async {
    await _open(tester, (id, _) => homeDetails(id, images: ['1', '2']));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Open photo 1 of 2').hitTestable());
    await tester.pumpAndSettle();

    final viewer = find.byType(InteractiveViewer);
    final center = tester.getCenter(viewer);
    final left = await tester.startGesture(
      center - const Offset(40, 0),
      pointer: 1,
    );
    final right = await tester.startGesture(
      center + const Offset(40, 0),
      pointer: 2,
    );
    await tester.pump();
    await left.moveBy(const Offset(-30, 0));
    await right.moveBy(const Offset(30, 0));
    await left.moveBy(const Offset(-40, 0));
    await right.moveBy(const Offset(40, 0));
    await left.up();
    await right.up();
    await tester.pumpAndSettle();

    final zoom = tester
        .widget<InteractiveViewer>(viewer)
        .transformationController!;
    expect(zoom.value.getMaxScaleOnAxis(), greaterThan(1));
    expect(
      tester.widget<PageView>(find.byType(PageView)).physics,
      isA<NeverScrollableScrollPhysics>(),
    );
    expect(find.text('Photo 1 of 2'), findsOneWidget);
  });

  testWidgets(
    'locale change refreshes data and preserves the current hero photo',
    (tester) async {
      var calls = 0;
      final container = await _open(
        tester,
        (id, _) => homeDetails(id, arabic: calls++ != 0, images: ['1', '2']),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-270, 0));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Photo 2 of 2'), findsOneWidget);
      await container
          .read(appLocaleProvider.notifier)
          .select(AppLanguage.arabic);
      await tester.pumpAndSettle();

      final hero = tester.element(find.byType(PropertyHero));
      expect(Directionality.of(hero), TextDirection.rtl);
      expect(
        find.text('دوبلكس مشرق بالقرب من الحديقة rental-001'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('الصورة 2 من 2'), findsOneWidget);
      await tester.drag(find.byType(PageView), const Offset(-270, 0));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('الصورة 1 من 2'), findsOneWidget);
    },
  );

  for (final (size, arabic, scale, variant) in [
    (const Size(320, 700), false, 2.0, AppThemeVariant.blue),
    (const Size(375, 750), true, 2.0, AppThemeVariant.purple),
    (const Size(390, 844), false, 1.0, AppThemeVariant.orange),
    (const Size(430, 932), true, 1.0, AppThemeVariant.blue),
    (const Size(820, 1024), true, 2.0, AppThemeVariant.orange),
    (const Size(780, 340), false, 2.0, AppThemeVariant.purple),
  ]) {
    testWidgets(
      'lays out ${size.width} × ${size.height} ${variant.name}, Arabic $arabic, text $scale',
      (tester) async {
        await _open(
          tester,
          (id, _) => homeDetails(
            id,
            arabic: arabic,
            images: ['1', '2', '3', '4'],
            facilities: [
              'balcony',
              'ev-charging',
              'in-unit-laundry',
              'pet-friendly',
            ],
            reviews: [
              PropertyReview(
                id: 'review-1',
                reviewerName: 'Riley Adams',
                rating: 4.2,
                comment: arabic
                    ? List.filled(14, 'تعليق طويل عن هذا العقار.').join(' ')
                    : List.filled(
                        14,
                        'A long review about this property.',
                      ).join(' '),
                date: DateTime.utc(2026, 2, 3),
              ),
            ],
          ),
          size: size,
          scale: scale,
          arabic: arabic,
          variant: variant,
        );
        await tester.pumpAndSettle();
        await _reveal(tester, find.text('Riley Adams'));
        await _reveal(tester, find.text('4.2'));
        expect(
          find.text(
            DateFormat.yMMMd(arabic ? 'ar' : 'en')
                .format(DateTime.utc(2026, 2, 3)),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
