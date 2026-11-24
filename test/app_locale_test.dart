import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/localization/failure_message.dart';
import 'package:real_estate_app/l10n/app_localizations.dart';

import 'support/memory_locale_preferences.dart';

void main() {
  for (final (code, expected) in [
    (null, AppLanguage.english),
    ('ar', AppLanguage.arabic),
    ('fr', AppLanguage.english),
    ('ar-SY', AppLanguage.english),
  ]) {
    test('restores stored ${code ?? 'missing'} as ${expected.code}', () {
      final container = ProviderContainer.test(
        overrides: [
          localePreferencesProvider.overrideWithValue(
            MemoryLocalePreferences(code),
          ),
        ],
      );
      expect(container.read(appLocaleProvider), expected);
    });
  }

  test('rapid changes persist in order', () async {
    final firstWrite = Completer<void>();
    final preferences = MemoryLocalePreferences()
      ..beforeWrite = (code) =>
          code == 'ar' ? firstWrite.future : Future.value();
    final container = ProviderContainer.test(
      overrides: [localePreferencesProvider.overrideWithValue(preferences)],
    );
    final controller = container.read(appLocaleProvider.notifier);
    final first = controller.select(AppLanguage.arabic);
    final second = controller.select(AppLanguage.english);

    expect(container.read(appLocaleProvider), AppLanguage.english);
    firstWrite.complete();
    await Future.wait([first, second]);
    expect(preferences.languageCode, 'en');
    expect(container.read(appLocaleProvider), AppLanguage.english);
  });

  test(
    'a failed write keeps the old locale and allows another attempt',
    () async {
      final preferences = MemoryLocalePreferences()
        ..beforeWrite = (_) =>
            Future<void>.error(StateError('storage failure'));
      final container = ProviderContainer.test(
        overrides: [localePreferencesProvider.overrideWithValue(preferences)],
      );
      final controller = container.read(appLocaleProvider.notifier);

      await expectLater(
        controller.select(AppLanguage.arabic),
        throwsStateError,
      );
      expect(container.read(appLocaleProvider), AppLanguage.english);
      expect(preferences.languageCode, isNull);
      preferences.beforeWrite = null;
      await controller.select(AppLanguage.arabic);
      expect(container.read(appLocaleProvider), AppLanguage.arabic);
      expect(preferences.languageCode, 'ar');
    },
  );

  testWidgets(
    'root switches direction and restores the choice in a new scope',
    (tester) async {
      final preferences = MemoryLocalePreferences();
      await tester.pumpWidget(createApp(preferences));
      final english = find.text('Design system');
      expect(Directionality.of(tester.element(english)), TextDirection.ltr);

      await tester.tap(find.text('العربية'));
      await tester.pump();
      await tester.pump();
      final arabic = find.text('نظام التصميم');
      expect(Directionality.of(tester.element(arabic)), TextDirection.rtl);
      expect(preferences.languageCode, 'ar');

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(createApp(preferences));
      expect(Directionality.of(tester.element(arabic)), TextDirection.rtl);

      await tester.tap(find.text('English'));
      await tester.pump();
      await tester.pump();
      expect(Directionality.of(tester.element(english)), TextDirection.ltr);
      expect(preferences.languageCode, 'en');
    },
  );

  test('failure messages are localized and cancellation is silent', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    final ar = await AppLocalizations.delegate.load(const Locale('ar'));
    const timeout = AppFailure(
      FailureKind.timeout,
      apiCode: 'INTERNAL_TEST_CODE',
    );
    expect(failureMessage(en, timeout), 'The request timed out. Try again.');
    expect(failureMessage(ar, timeout), 'انتهت مهلة الطلب. حاول مرة أخرى.');
    expect(failureMessage(ar, const AppFailure(FailureKind.cancelled)), isNull);
  });
}
