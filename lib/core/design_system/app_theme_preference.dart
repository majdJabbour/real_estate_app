import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/locale_preferences.dart';
import 'app_theme.dart';

part 'app_theme_preference.g.dart';

@Riverpod(keepAlive: true)
ThemePreferences? themePreferences(Ref ref) => null;

@Riverpod(keepAlive: true)
class AppThemePreference extends _$AppThemePreference {
  Future<void> _pending = Future<void>.value();

  @override
  AppThemeVariant build() =>
      switch (ref.watch(themePreferencesProvider)?.readThemeId()) {
        'purple' => AppThemeVariant.purple,
        'orange' => AppThemeVariant.orange,
        _ => AppTheme.defaultVariant,
      };

  Future<void> select(AppThemeVariant variant) {
    state = variant;
    final preferences = ref.read(themePreferencesProvider);
    final save = _pending.then((_) async {
      await preferences?.writeThemeId(switch (variant) {
        AppThemeVariant.blue => 'blue',
        AppThemeVariant.purple => 'purple',
        AppThemeVariant.orange => 'orange',
      });
    });
    _pending = save.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return save;
  }
}
