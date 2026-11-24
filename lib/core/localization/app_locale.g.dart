// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localePreferences)
final localePreferencesProvider = LocalePreferencesProvider._();

final class LocalePreferencesProvider
    extends
        $FunctionalProvider<
          LocalePreferences,
          LocalePreferences,
          LocalePreferences
        >
    with $Provider<LocalePreferences> {
  LocalePreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localePreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localePreferencesHash();

  @$internal
  @override
  $ProviderElement<LocalePreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalePreferences create(Ref ref) {
    return localePreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalePreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalePreferences>(value),
    );
  }
}

String _$localePreferencesHash() => r'028ac85406f8f814e711bdc72c25056c2f1e31fc';

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

final class AppLocaleProvider
    extends $NotifierProvider<AppLocale, AppLanguage> {
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLanguage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLanguage>(value),
    );
  }
}

String _$appLocaleHash() => r'97a464c54bd108f4cbd52d7461c89906b42b13dc';

abstract class _$AppLocale extends $Notifier<AppLanguage> {
  AppLanguage build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLanguage, AppLanguage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLanguage, AppLanguage>,
              AppLanguage,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
