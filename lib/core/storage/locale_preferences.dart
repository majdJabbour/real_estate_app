import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalePreferences {
  String? readLanguageCode();
  Future<void> writeLanguageCode(String value);
}

abstract interface class ThemePreferences {
  String? readThemeId();
  Future<void> writeThemeId(String value);
}

final class SharedLocalePreferences
    implements LocalePreferences, ThemePreferences {
  SharedLocalePreferences._(
    this._preferences,
    this._languageCode,
    this._themeId,
  );

  static const _languageKey = 'app.languageCode';
  static const _themeKey = 'app.theme';
  final SharedPreferencesAsync _preferences;
  String? _languageCode;
  String? _themeId;

  static Future<SharedLocalePreferences> load() async {
    final preferences = SharedPreferencesAsync();
    final values = await preferences.getAll(
      allowList: {_languageKey, _themeKey},
    );
    final language = values[_languageKey];
    final theme = values[_themeKey];
    return SharedLocalePreferences._(
      preferences,
      language is String ? language : null,
      theme is String ? theme : null,
    );
  }

  @override
  String? readLanguageCode() => _languageCode;

  @override
  Future<void> writeLanguageCode(String value) async {
    await _preferences.setString(_languageKey, value);
    _languageCode = value;
  }

  @override
  String? readThemeId() => _themeId;

  @override
  Future<void> writeThemeId(String value) async {
    await _preferences.setString(_themeKey, value);
    _themeId = value;
  }
}
