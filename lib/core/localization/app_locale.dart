import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/locale_preferences.dart';

part 'app_locale.g.dart';

enum AppLanguage {
  english('en'),
  arabic('ar');

  const AppLanguage(this.code);
  final String code;

  static AppLanguage fromCode(String? code) =>
      code == arabic.code ? arabic : english;
}

@Riverpod(keepAlive: true)
LocalePreferences localePreferences(Ref ref) =>
    throw StateError('Locale preferences must be initialized at startup.');

@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  Future<void> _pending = Future<void>.value();

  @override
  AppLanguage build() => AppLanguage.fromCode(
    ref.watch(localePreferencesProvider).readLanguageCode(),
  );

  Future<void> select(AppLanguage language) {
    final preferences = ref.read(localePreferencesProvider);
    final change = _pending.then((_) async {
      if (!ref.mounted || state == language) return;
      await preferences.writeLanguageCode(language.code);
      if (ref.mounted) state = language;
    });
    // A failed write is reported to its caller without blocking later choices.
    _pending = change.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return change;
  }
}
