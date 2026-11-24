import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalePreferences {
  String? readLanguageCode();
  Future<void> writeLanguageCode(String value);
}

final class SharedLocalePreferences implements LocalePreferences {
  SharedLocalePreferences._(this._preferences, this._languageCode);

  static const _languageKey = 'app.languageCode';
  final SharedPreferencesAsync _preferences;
  String? _languageCode;

  static Future<SharedLocalePreferences> load() async {
    final preferences = SharedPreferencesAsync();
    final values = await preferences.getAll(allowList: {_languageKey});
    final language = values[_languageKey];
    return SharedLocalePreferences._(
      preferences,
      language is String ? language : null,
    );
  }

  @override
  String? readLanguageCode() => _languageCode;

  @override
  Future<void> writeLanguageCode(String value) async {
    await _preferences.setString(_languageKey, value);
    _languageCode = value;
  }
}
