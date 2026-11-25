import 'dart:ui' show SemanticsAction;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/design_system/design_controls.dart';
import 'package:real_estate_app/preview/preview_app.dart';

import 'support/memory_locale_preferences.dart';

Future<void> _pumpControl(
  WidgetTester tester,
  Widget control, {
  TextDirection direction = TextDirection.ltr,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: Directionality(
        textDirection: direction,
        child: Center(child: control),
      ),
    ),
  ),
);

void main() {
  testWidgets('preview starts in Blue and changes inherited themes', (
    tester,
  ) async {
    await tester.pumpWidget(createPreviewApp(MemoryLocalePreferences()));
    final button = find.widgetWithText(AppPrimaryButton, 'Apply filters');
    Color brand() => Theme.of(tester.element(button)).colorScheme.primary;

    expect(brand(), const Color(0xFF0061FF));

    await tester.tap(find.text('Purple'));
    await tester.pump();
    expect(brand(), const Color(0xFF8B5DFF));

    await tester.tap(find.text('Orange'));
    await tester.pump();
    expect(brand(), const Color(0xFFFF8000));
    expect(button, findsOneWidget);
  });

  testWidgets('primary action runs when enabled and stops when disabled', (
    tester,
  ) async {
    var calls = 0;
    await _pumpControl(
      tester,
      AppPrimaryButton(label: 'Apply', onPressed: () => calls++),
    );
    await tester.tap(find.text('Apply'));
    expect(calls, 1);

    await _pumpControl(
      tester,
      const AppPrimaryButton(label: 'Apply', onPressed: null),
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).enabled,
      isFalse,
    );
    await tester.tap(find.text('Apply'));
    expect(calls, 1);
  });

  testWidgets('loading announces progress and blocks the callback', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var calls = 0;
    await _pumpControl(
      tester,
      AppPrimaryButton(
        label: 'Apply',
        loadingLabel: 'Applying filters',
        onPressed: () => calls++,
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel('Applying filters'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).enabled,
      isFalse,
    );
    await tester.tap(find.text('Applying filters'));
    expect(calls, 0);
    semantics.dispose();
  });

  testWidgets('choice toggles both ways and ignores disabled taps', (
    tester,
  ) async {
    final selections = <bool>[];
    await _pumpControl(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppChoiceChip(
              label: 'Apartments',
              selected: selections.lastOrNull ?? false,
              onSelected: (selected) =>
                  setState(() => selections.add(selected)),
            ),
            const AppChoiceChip(
              label: 'Unavailable chip',
              selected: false,
              onSelected: null,
            ),
          ],
        ),
      ),
    );
    final chip = find.widgetWithText(ChoiceChip, 'Apartments');
    expect(tester.widget<ChoiceChip>(chip).selected, isFalse);
    await tester.tap(chip);
    await tester.pump();
    expect(tester.widget<ChoiceChip>(chip).selected, isTrue);
    await tester.tap(chip);
    await tester.pump();
    await tester.tap(find.text('Unavailable chip'));
    expect(selections, [true, false]);
  });

  testWidgets('search forwards changes, submission and filter action', (
    tester,
  ) async {
    final changes = <String>[];
    final submissions = <String>[];
    var filterCalls = 0;
    await _pumpControl(
      tester,
      AppSearchField(
        hintText: 'Search properties',
        onChanged: changes.add,
        onSubmitted: submissions.add,
        filter: (label: 'Open filters', onPressed: () => filterCalls++),
      ),
    );
    final field = find.byType(TextField);
    expect(tester.getSize(field).height, greaterThanOrEqualTo(52));
    await tester.enterText(field, 'apartment');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.tap(find.byTooltip('Open filters'));

    expect(changes, ['apartment']);
    expect(submissions, ['apartment']);
    expect(filterCalls, 1);
  });

  testWidgets('disabled search disables its trailing filter action', (
    tester,
  ) async {
    var filterCalls = 0;
    await _pumpControl(
      tester,
      AppSearchField(
        hintText: 'Search properties',
        enabled: false,
        filter: (label: 'Open filters', onPressed: () => filterCalls++),
      ),
    );

    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('Open filters'), warnIfMissed: false);
    expect(filterCalls, 0);
  });

  testWidgets('icon action exposes a named tap target', (tester) async {
    final semantics = tester.ensureSemantics();
    var calls = 0;
    await _pumpControl(
      tester,
      AppIconButton(
        label: 'Open filters',
        icon: const Icon(Icons.tune),
        onPressed: () => calls++,
      ),
    );

    final target = find.bySemanticsLabel('Open filters');
    expect(target, findsOneWidget);
    expect(
      tester.getSize(find.byType(IconButton)).width,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byType(IconButton)).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester
          .getSemantics(target)
          .getSemanticsData()
          .hasAction(SemanticsAction.tap),
      isTrue,
    );
    await tester.tap(find.byType(IconButton));
    expect(calls, 1);
    semantics.dispose();
  });

  testWidgets('favorite preview changes outline to filled and back', (
    tester,
  ) async {
    await tester.pumpWidget(createPreviewApp(MemoryLocalePreferences()));
    final outline = find.byIcon(Icons.favorite_border);
    final filled = find.byIcon(Icons.favorite);
    expect(outline, findsOneWidget);

    await tester.tap(outline);
    await tester.pump();
    expect(filled, findsOneWidget);
    expect(outline, findsNothing);

    await tester.tap(filled);
    await tester.pump();
    expect(outline, findsOneWidget);
    expect(filled, findsNothing);
  });

  testWidgets('search icons follow logical start and end in RTL', (
    tester,
  ) async {
    await _pumpControl(
      tester,
      AppSearchField(
        hintText: 'ابحث عن عقار',
        filter: (label: 'الفلاتر', onPressed: () {}),
      ),
      direction: TextDirection.rtl,
    );

    final search = tester.getCenter(find.byIcon(Icons.search));
    final filter = tester.getCenter(find.byIcon(Icons.tune));
    expect(search.dx, greaterThan(filter.dx));
  });

  for (final size in [
    const Size(320, 640),
    const Size(375, 667),
    const Size(390, 844),
    const Size(430, 932),
    const Size(640, 320),
  ]) {
    testWidgets(
      'preview fits ${size.width.toInt()}×${size.height.toInt()} with enlarged RTL text',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(() async {
          await tester.binding.setSurfaceSize(null);
          tester.platformDispatcher.clearTextScaleFactorTestValue();
        });

        await tester.pumpWidget(createPreviewApp(MemoryLocalePreferences()));
        final languageToggle = find.text('العربية');
        await tester.ensureVisible(languageToggle);
        await tester.pump();
        await tester.tap(languageToggle);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        final title = find.text('نظام التصميم');
        final context = tester.element(title);
        expect(Directionality.of(context), TextDirection.rtl);
        expect(MediaQuery.textScalerOf(context).scale(16), 32);
        expect(tester.getRect(title).right, lessThanOrEqualTo(size.width));
        final loading = find.text('جارٍ تطبيق الفلاتر…');
        await tester.ensureVisible(loading);
        await tester.pump();
        expect(loading.hitTestable(), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
