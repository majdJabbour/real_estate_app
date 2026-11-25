import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/core/design_system/app_icon.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/design_system/design_controls.dart';

Widget _host(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

Future<ByteData> _pixels(ui.Image image) async {
  try {
    return (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  } finally {
    image.dispose();
  }
}

int _pixel(ByteData data, int x, int y) => data.getUint32((y * 24 + x) * 4);

void main() {
  test(
    'every registered source SVG loads and paints nonempty artwork',
    () async {
      expect(AppIcons.values.map((icon) => icon.asset).toSet(), hasLength(11));
      for (final icon in AppIcons.values) {
        final svg = await rootBundle.loadString(icon.asset);
        expect(svg, contains('viewBox='));
        expect(svg, isNot(contains('https://')));
        expect(svg, isNot(contains('<script')));
        final picture = await vg.loadPicture(SvgAssetLoader(icon.asset), null);
        try {
          final pixels = await _pixels(
            await picture.picture.toImage(
              picture.size.width.round(),
              picture.size.height.round(),
            ),
          );
          expect(
            List.generate(
              pixels.lengthInBytes ~/ 4,
              (i) => pixels.getUint8(i * 4 + 3),
            ).any((alpha) => alpha > 0),
            isTrue,
            reason: icon.name,
          );
        } finally {
          picture.picture.dispose();
        }
      }
    },
  );

  testWidgets('uses logical size and exposes labels only when supplied', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(AppIcons.homeSelected, size: 24),
            AppIcon(
              AppIcons.heartOutline,
              size: 20,
              semanticLabel: 'Saved listing',
            ),
          ],
        ),
      ),
    );
    final pictures = tester
        .widgetList<SvgPicture>(find.byType(SvgPicture))
        .toList();
    expect(
      tester.getSize(find.byType(SvgPicture).first),
      const Size.square(24),
    );
    expect(tester.getSize(find.byType(SvgPicture).last), const Size.square(20));
    expect(pictures.first.excludeFromSemantics, isTrue);
    expect(pictures.last.excludeFromSemantics, isFalse);
    expect(find.bySemanticsLabel('Saved listing'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets(
    'selected and outline tabs use distinct assets and semantic tint',
    (tester) async {
      await tester.pumpWidget(
        _host(
          const Row(
            children: [
              AppIcon(AppIcons.homeOutline, color: Color(0xFF666876)),
              AppIcon(AppIcons.homeSelected, color: Color(0xFF6338C6)),
              AppIcon(AppIcons.profileOutline),
              AppIcon(AppIcons.profileSelected),
            ],
          ),
        ),
      );
      final pictures = tester
          .widgetList<SvgPicture>(find.byType(SvgPicture))
          .toList();
      final paths = pictures.map(
        (picture) => (picture.bytesLoader as SvgAssetLoader).assetName,
      );
      expect(paths, [
        AppIcons.homeOutline.asset,
        AppIcons.homeSelected.asset,
        AppIcons.profileOutline.asset,
        AppIcons.profileSelected.asset,
      ]);
      expect(
        pictures[0].colorFilter,
        const ColorFilter.mode(Color(0xFF666876), BlendMode.srcIn),
      );
      expect(
        pictures[1].colorFilter,
        const ColorFilter.mode(Color(0xFF6338C6), BlendMode.srcIn),
      );
    },
  );

  testWidgets(
    'tints the Explore main path and retains the pale accent and rating gradient',
    (tester) async {
      await tester.pumpWidget(
        _host(
          const Row(
            children: [
              AppIcon(AppIcons.exploreSelected, color: Color(0xFF6338C6)),
              AppIcon(AppIcons.ratingStar, color: Colors.green),
            ],
          ),
        ),
      );
      final pictures = tester
          .widgetList<SvgPicture>(find.byType(SvgPicture))
          .toList();
      expect(
        pictures.map((picture) => picture.colorFilter),
        everyElement(isNull),
      );
      await tester.runAsync(() async {
        final explore = await vg.loadPicture(pictures[0].bytesLoader, null);
        final star = await vg.loadPicture(pictures[1].bytesLoader, null);
        try {
          final recorder = ui.PictureRecorder();
          final canvas = ui.Canvas(recorder);
          canvas.scale(3);
          canvas.drawPicture(explore.picture);
          final scaled = recorder.endRecording();
          final exploreBytes = await _pixels(await scaled.toImage(72, 72));
          scaled.dispose();
          int pixel(int x, int y) => exploreBytes.getUint32((y * 72 + x) * 4);
          expect(pixel(30, 30), 0x6338C6FF);
          final handleColors = {
            for (var y = 54; y < 66; y++)
              for (var x = 54; x < 66; x++) pixel(x, y),
          };
          expect(handleColors, contains(0xF9F9FAFF));
          expect(handleColors, contains(0x6338C6FF));
          final starBytes = await _pixels(await star.picture.toImage(14, 14));
          final starColors = {
            for (var i = 0; i < starBytes.lengthInBytes; i += 4)
              if (starBytes.getUint8(i + 3) == 255) starBytes.getUint32(i),
          };
          expect(starColors.length, greaterThan(2));
          expect(starColors.every((color) => (color >> 24) >= 251), isTrue);
        } finally {
          explore.picture.dispose();
          star.picture.dispose();
        }
      });
    },
  );

  testWidgets(
    'mirrors the back asset in RTL and keeps search geometry unchanged',
    (tester) async {
      Widget icon(AppIcons icon, TextDirection direction, String name) =>
          Directionality(
            textDirection: direction,
            child: RepaintBoundary(
              key: ValueKey(name),
              child: AppIcon(icon, size: 24, color: Colors.black),
            ),
          );
      await tester.pumpWidget(
        _host(
          Row(
            children: [
              icon(AppIcons.back, TextDirection.ltr, 'back-ltr'),
              icon(AppIcons.back, TextDirection.rtl, 'back-rtl'),
              icon(AppIcons.exploreOutline, TextDirection.ltr, 'search-ltr'),
              icon(AppIcons.exploreOutline, TextDirection.rtl, 'search-rtl'),
            ],
          ),
        ),
      );
      await tester.runAsync(() async {
        for (final picture in tester.widgetList<SvgPicture>(
          find.byType(SvgPicture),
        )) {
          final parsed = await vg.loadPicture(picture.bytesLoader, null);
          parsed.picture.dispose();
        }
      });
      await tester.pumpAndSettle();
      Future<ByteData> paint(String name) => _pixels(
        tester
            .renderObject<RenderRepaintBoundary>(find.byKey(ValueKey(name)))
            .toImageSync(),
      );
      await tester.runAsync(() async {
        final backLtr = await paint('back-ltr');
        final backRtl = await paint('back-rtl');
        final searchLtr = await paint('search-ltr');
        final searchRtl = await paint('search-rtl');
        var covered = 0;
        var asymmetric = 0;
        var mirrored = 0;
        for (var y = 0; y < 24; y++) {
          for (var x = 0; x < 24; x++) {
            expect(_pixel(searchLtr, x, y), _pixel(searchRtl, x, y));
            final left = _pixel(backLtr, x, y) & 255;
            final right = _pixel(backRtl, x, y) & 255;
            final reflected = _pixel(backRtl, 23 - x, y) & 255;
            if (left > 64) covered++;
            if ((left - right).abs() > 64) asymmetric++;
            if ((left - reflected).abs() < 24) mirrored++;
          }
        }
        expect(covered, greaterThan(10));
        expect(asymmetric, greaterThan(5));
        expect(mirrored, greaterThan(560));
      });
    },
  );

  testWidgets(
    'the icon button carries the action label and a separate touch target',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var presses = 0;
      await tester.pumpWidget(
        _host(
          AppIconButton(
            label: 'Open filters',
            icon: const AppIcon(AppIcons.filter, size: 20),
            onPressed: () => presses++,
          ),
        ),
      );
      final button = find.byType(IconButton);
      expect(find.bySemanticsLabel('Open filters'), findsOneWidget);
      expect(tester.getSize(button).shortestSide, greaterThanOrEqualTo(48));
      expect(tester.getSize(find.byType(SvgPicture)), const Size.square(20));
      await tester.tap(button);
      expect(presses, 1);
      semantics.dispose();
    },
  );
}
