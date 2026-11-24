import 'package:real_estate_app/core/storage/locale_preferences.dart';

final class MemoryLocalePreferences implements LocalePreferences {
  MemoryLocalePreferences([this.languageCode]);

  String? languageCode;
  Future<void> Function(String)? beforeWrite;

  @override
  String? readLanguageCode() => languageCode;

  @override
  Future<void> writeLanguageCode(String value) async {
    await beforeWrite?.call(value);
    languageCode = value;
  }
}
