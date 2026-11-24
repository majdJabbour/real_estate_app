import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/design_system/design_controls.dart';
import 'package:real_estate_app/core/layout/responsive_layout.dart';
import 'package:real_estate_app/preview/design_system_preview.dart';
import 'package:real_estate_app/preview/responsive_preview.dart';

const _sizes = [
  (Size(320, 568), 1),
  (Size(375, 667), 2),
  (Size(390, 844), 2),
  (Size(430, 932), 2),
  (Size(600, 960), 3),
  (Size(768, 1024), 3),
  (Size(1024, 768), 5),
];

void _setSurface(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _gridPreview({
  required TextDirection direction,
  required double scale,
  double? parentWidth,
  EdgeInsets safePadding = EdgeInsets.zero,
}) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(
    body: Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            padding: safePadding,
          ),
          child: Directionality(
            textDirection: direction,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: parentWidth,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomScrollView(
                        slivers: [
                          ResponsivePreview(
                            layout: ResponsiveLayout.fromConstraints(
                              constraints,
                            ),
                            viewportHeight: constraints.maxHeight,
                            arabic: direction == TextDirection.rtl,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  ),
);

void main() {
  for (final (size, columns) in _sizes) {
    testWidgets(
      'renders ${size.width.toInt()} × ${size.height.toInt()} at 1×',
      (tester) async {
        _setSurface(tester, size);
        await tester.pumpWidget(
          _gridPreview(direction: TextDirection.ltr, scale: 1),
        );

        final tiles = find.byType(AspectRatio);
        expect(find.textContaining('Columns $columns'), findsOneWidget);
        final first = tester.getRect(tiles.first);
        expect(first.left, greaterThanOrEqualTo(16));
        expect(first.right, lessThanOrEqualTo(size.width - 16));
        if (columns > 1) {
          final second = tester.getRect(tiles.at(1));
          expect(second.left - first.right, closeTo(16, 0.01));
          expect(second.top, closeTo(first.top, 0.01));
        }
        if (size.width == 430) {
          expect(first.width, 187);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final (scale, columns) in [(1.5, 4), (2.0, 3)]) {
    testWidgets('wide RTL grid reflows at $scale×', (tester) async {
      _setSurface(tester, const Size(1024, 768));
      await tester.pumpWidget(
        _gridPreview(direction: TextDirection.rtl, scale: scale),
      );

      expect(find.textContaining('الأعمدة $columns'), findsOneWidget);
      final tiles = find.byType(AspectRatio);
      final first = tester.getRect(tiles.first);
      final second = tester.getRect(tiles.at(1));
      expect(first.left - second.right, closeTo(16, 0.01));
      expect(
        MediaQuery.textScalerOf(tester.element(tiles.first)).scale(16),
        16 * scale,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('local width and safe insets override a wide window', (
    tester,
  ) async {
    _setSurface(tester, const Size(1024, 768));
    await tester.pumpWidget(
      _gridPreview(
        direction: TextDirection.ltr,
        scale: 1,
        parentWidth: 320,
        safePadding: const EdgeInsets.only(left: 48, right: 16),
      ),
    );

    expect(find.textContaining('Viewport 320'), findsOneWidget);
    expect(find.textContaining('Columns 1'), findsOneWidget);
    final tile = tester.getRect(find.byType(AspectRatio).first);
    expect(tile.width, 288);
    expect(tile.center.dx, 528);
  });

  testWidgets('a resize reflows existing slivers after orientation changes', (
    tester,
  ) async {
    _setSurface(tester, const Size(390, 844));
    await tester.pumpWidget(
      _gridPreview(direction: TextDirection.ltr, scale: 1),
    );
    expect(find.textContaining('Columns 2'), findsOneWidget);

    tester.view.physicalSize = const Size(844, 390);
    await tester.pump();
    expect(find.textContaining('Columns 4'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AdaptiveContent centers bounded and unbounded box children', (
    tester,
  ) async {
    _setSurface(tester, const Size(1024, 768));
    const bounded = Key('bounded');
    const unbounded = Key('unbounded');
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            const AdaptiveContent(
              maxContentWidth: ResponsiveLayout.detailsMaxWidth,
              child: SizedBox(key: bounded, height: 40),
            ),
            const Row(
              children: [
                AdaptiveContent(
                  maxContentWidth: ResponsiveLayout.authMaxWidth,
                  child: SizedBox(key: unbounded, height: 40),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    for (final (key, width) in [(bounded, 680), (unbounded, 480)]) {
      final content = tester.getRect(find.byKey(key));
      expect(content.width, width);
      expect(content.center.dx, 512);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('the full preview scrolls from controls to adaptive tiles', (
    tester,
  ) async {
    _setSurface(tester, const Size(430, 932));
    await tester.pumpWidget(const DesignSystemPreview());
    await tester.scrollUntilVisible(
      find.text('Adaptive layout'),
      280,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.textContaining('Tile width 187'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long RTL control labels fit a narrow local region at 2×', (
    tester,
  ) async {
    const label = 'تطبيق عوامل التصفية المحددة';
    var actions = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(2)),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                    child: SizedBox(
                      width: 136,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AppPrimaryButton(
                              label: label,
                              onPressed: () => actions++,
                            ),
                            AppPrimaryButton(
                              label: label,
                              loadingLabel: 'جارٍ تطبيق العوامل المحددة',
                              onPressed: () => actions++,
                            ),
                            const AppPrimaryButton(
                              label: label,
                              onPressed: null,
                            ),
                            AppChoiceChip(
                              label: label,
                              selected: true,
                              onSelected: (_) {},
                            ),
                            AppSearchField(
                              hintText: label,
                              filter: (label: label, onPressed: () {}),
                            ),
                            AppIconButton(
                              label: label,
                              icon: const Icon(Icons.tune),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    final buttons = find.byType(FilledButton);
    for (var index = 0; index < 3; index++) {
      final finder = buttons.at(index);
      expect(tester.getSize(finder).width, lessThanOrEqualTo(136));
      expect(tester.getSize(finder).height, greaterThan(54));
      expect(tester.widget<FilledButton>(finder).enabled, index == 0);
    }
    expect(tester.getSize(find.byType(ChoiceChip)).height, greaterThan(48));
    expect(tester.getSize(find.byType(TextField)).width, 136);
    final standalone = find.descendant(
      of: find.byType(AppIconButton),
      matching: find.byType(IconButton),
    );
    expect(tester.getSize(standalone), const Size(48, 48));
    await tester.ensureVisible(buttons.first);
    await tester.tap(buttons.first);
    expect(actions, 1);
    expect(tester.takeException(), isNull);
  });
}
