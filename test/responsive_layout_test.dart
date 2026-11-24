import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/core/layout/responsive_layout.dart';

ResponsiveLayout _layout(double width) =>
    ResponsiveLayout.fromConstraints(BoxConstraints.tightFor(width: width));

void main() {
  test('width classes change at 360, 600, and 840 dp', () {
    final widths = {
      359.99: LayoutWidth.compact,
      360.0: LayoutWidth.phone,
      599.99: LayoutWidth.phone,
      600.0: LayoutWidth.tablet,
      839.99: LayoutWidth.tablet,
      840.0: LayoutWidth.expanded,
    };
    for (final entry in widths.entries) {
      expect(
        _layout(entry.key).widthClass,
        entry.value,
        reason: '${entry.key}',
      );
    }
  });

  test('horizontal padding transitions independently at 390 dp', () {
    final widths = {
      359.99: 16.0,
      360.0: 16.0,
      389.99: 16.0,
      390.0: 20.0,
      599.99: 20.0,
      600.0: 24.0,
      839.99: 24.0,
      840.0: 32.0,
    };
    for (final entry in widths.entries) {
      expect(
        _layout(entry.key).horizontalPadding,
        entry.value,
        reason: '${entry.key}',
      );
    }
  });

  const references = [
    (320.0, 288.0, 1, 288.0),
    (375.0, 343.0, 2, 163.5),
    (390.0, 350.0, 2, 167.0),
    (430.0, 390.0, 2, 187.0),
    (600.0, 552.0, 3, 173.333333),
    (768.0, 720.0, 3, 229.333333),
    (1024.0, 960.0, 5, 179.2),
  ];
  for (final (width, contentWidth, columns, cardWidth) in references) {
    test(
      '${width.toInt()} dp uses $columns columns inside its padded content',
      () {
        final layout = _layout(width);
        expect(layout.contentWidth, contentWidth);
        expect(layout.grid().columns, columns);
        expect(layout.grid().cardWidth, closeTo(cardWidth, 0.001));
      },
    );
  }

  test(
    'zero width, exhausted gutters, and narrow content give finite geometry',
    () {
      for (final width in [0.0, 20.0, 32.0]) {
        final layout = _layout(width);
        expect(layout.contentWidth, 0);
        expect(layout.grid(), (columns: 0, cardWidth: 0.0));
        expect(layout.centeredInsets.horizontal, width);
      }
      expect(_layout(80).grid(), (columns: 1, cardWidth: 48.0));
    },
  );

  test('a content cap adds centered space beyond the breakpoint gutters', () {
    for (final cap in [
      ResponsiveLayout.collectionMaxWidth,
      ResponsiveLayout.detailsMaxWidth,
      ResponsiveLayout.filtersMaxWidth,
      ResponsiveLayout.authMaxWidth,
    ]) {
      final layout = ResponsiveLayout.fromConstraints(
        const BoxConstraints(maxWidth: 1600),
        maxContentWidth: cap,
      );
      expect(layout.contentWidth, cap);
      expect(layout.horizontalPadding, 32);
      expect(layout.centeredInsets.start, (1600 - cap) / 2);
      expect(layout.centeredInsets.end, layout.centeredInsets.start);
    }
    expect(_layout(1600).grid().columns, 6);
  });

  test('bounded parents win and unbounded width uses a finite fallback', () {
    final constrained = ResponsiveLayout.fromConstraints(
      const BoxConstraints(maxWidth: 320),
      fallbackWidth: 1024,
    );
    expect(constrained.grid().columns, 1);

    final withFallback = ResponsiveLayout.fromConstraints(
      const BoxConstraints(),
      fallbackWidth: 430,
    );
    expect(withFallback.grid().cardWidth, 187);

    final withoutFallback = ResponsiveLayout.fromConstraints(
      const BoxConstraints(),
      maxContentWidth: ResponsiveLayout.authMaxWidth,
    );
    expect(withoutFallback.contentWidth, 480);
    expect(withoutFallback.viewportWidth.isFinite, isTrue);
  });

  test('enlarged labels and caller minimum can reduce columns', () {
    final layout = _layout(1024);
    expect(layout.grid(textScaler: TextScaler.linear(1.5)).columns, 4);
    expect(layout.grid(textScaler: TextScaler.linear(2)).columns, 3);
    expect(_layout(430).grid(textScaler: TextScaler.linear(1.5)).columns, 1);
    expect(_layout(430).grid(minCardWidth: 190).columns, 1);
    expect(_layout(1024).grid(textScaler: TextScaler.linear(0.8)).columns, 5);
  });
}
