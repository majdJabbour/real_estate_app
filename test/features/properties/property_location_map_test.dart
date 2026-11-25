import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/features/properties/presentation/details/property_location_map.dart';
import 'package:real_estate_app/l10n/app_localizations.dart';

class _UnavailableTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      const AssetImage('unavailable-test-tile.png');
}

void main() {
  for (final (locale, variant, point, loading, failure) in [
    (
      const Locale('en'),
      AppThemeVariant.blue,
      const LatLng(30.263, -97.722),
      'Loading map…',
      'Some map tiles could not load.',
    ),
    (
      const Locale('ar'),
      AppThemeVariant.orange,
      const LatLng(37.7749, -122.4194),
      'جارٍ تحميل الخريطة…',
      'تعذر تحميل بعض أجزاء الخريطة.',
    ),
  ]) {
    testWidgets(
      'map keeps its property marker and scrolls in ${locale.languageCode}',
      (tester) async {
        final scroll = ScrollController();
        addTearDown(scroll.dispose);
        final tiles = _UnavailableTileProvider();
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: appLocalizationDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 280,
                  height: 320,
                  child: SingleChildScrollView(
                    controller: scroll,
                    child: Column(
                      children: [
                        PropertyLocationMap(point: point, tileProvider: tiles),
                        const SizedBox(height: 500),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            theme: AppTheme.light(variant),
          ),
        );

        expect(find.text(loading), findsOneWidget);
        final map = tester.widget<FlutterMap>(find.byType(FlutterMap));
        final marker = tester
            .widget<MarkerLayer>(find.byType(MarkerLayer))
            .markers
            .single;
        expect(map.options.initialCenter, point);
        expect(marker.point, point);
        expect(
          (marker.child as Icon).color,
          AppTheme.light(variant).colorScheme.primary,
        );
        await tester.pumpAndSettle();
        expect(find.text(failure), findsOneWidget);
        expect(find.text('© OpenStreetMap contributors'), findsOneWidget);

        await tester.drag(find.byType(FlutterMap), const Offset(0, -100));
        await tester.pumpAndSettle();
        expect(scroll.offset, greaterThan(0));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
