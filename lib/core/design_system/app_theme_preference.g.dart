// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_preference.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(themePreferences)
final themePreferencesProvider = ThemePreferencesProvider._();

final class ThemePreferencesProvider
    extends
        $FunctionalProvider<
          ThemePreferences?,
          ThemePreferences?,
          ThemePreferences?
        >
    with $Provider<ThemePreferences?> {
  ThemePreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themePreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themePreferencesHash();

  @$internal
  @override
  $ProviderElement<ThemePreferences?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ThemePreferences? create(Ref ref) {
    return themePreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemePreferences? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemePreferences?>(value),
    );
  }
}

String _$themePreferencesHash() => r'523276d63e6236b79dbb056ffda5ab7d54705eb1';

@ProviderFor(AppThemePreference)
final appThemePreferenceProvider = AppThemePreferenceProvider._();

final class AppThemePreferenceProvider
    extends $NotifierProvider<AppThemePreference, AppThemeVariant> {
  AppThemePreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemePreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemePreferenceHash();

  @$internal
  @override
  AppThemePreference create() => AppThemePreference();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeVariant value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeVariant>(value),
    );
  }
}

String _$appThemePreferenceHash() =>
    r'b8e3467b41c00fa2f981212b1c146cbda7b9bc24';

abstract class _$AppThemePreference extends $Notifier<AppThemeVariant> {
  AppThemeVariant build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppThemeVariant, AppThemeVariant>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeVariant, AppThemeVariant>,
              AppThemeVariant,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
