// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeCategory)
final homeCategoryProvider = HomeCategoryProvider._();

final class HomeCategoryProvider
    extends $NotifierProvider<HomeCategory, PropertyType?> {
  HomeCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCategoryHash();

  @$internal
  @override
  HomeCategory create() => HomeCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PropertyType? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PropertyType?>(value),
    );
  }
}

String _$homeCategoryHash() => r'fc67ae33189dbf346128b1502917364a46b88795';

abstract class _$HomeCategory extends $Notifier<PropertyType?> {
  PropertyType? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PropertyType?, PropertyType?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PropertyType?, PropertyType?>,
              PropertyType?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(homeFeatured)
final homeFeaturedProvider = HomeFeaturedProvider._();

final class HomeFeaturedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PropertySummary>>,
          List<PropertySummary>,
          FutureOr<List<PropertySummary>>
        >
    with
        $FutureModifier<List<PropertySummary>>,
        $FutureProvider<List<PropertySummary>> {
  HomeFeaturedProvider._()
    : super(
        from: null,
        argument: null,
        retry: _manualRetry,
        name: r'homeFeaturedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeFeaturedHash();

  @$internal
  @override
  $FutureProviderElement<List<PropertySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PropertySummary>> create(Ref ref) {
    return homeFeatured(ref);
  }
}

String _$homeFeaturedHash() => r'80ccc2c4514b3aa9d00992a3d218dfc7d53c22b4';

@ProviderFor(homeRecommendations)
final homeRecommendationsProvider = HomeRecommendationsProvider._();

final class HomeRecommendationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PropertySummary>>,
          List<PropertySummary>,
          FutureOr<List<PropertySummary>>
        >
    with
        $FutureModifier<List<PropertySummary>>,
        $FutureProvider<List<PropertySummary>> {
  HomeRecommendationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: _manualRetry,
        name: r'homeRecommendationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeRecommendationsHash();

  @$internal
  @override
  $FutureProviderElement<List<PropertySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PropertySummary>> create(Ref ref) {
    return homeRecommendations(ref);
  }
}

String _$homeRecommendationsHash() =>
    r'b4c00dddc94f3c4d8247a2fe75147b332e072266';

@ProviderFor(propertyFilterOptions)
final propertyFilterOptionsProvider = PropertyFilterOptionsProvider._();

final class PropertyFilterOptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PropertyFilterOptions>,
          PropertyFilterOptions,
          FutureOr<PropertyFilterOptions>
        >
    with
        $FutureModifier<PropertyFilterOptions>,
        $FutureProvider<PropertyFilterOptions> {
  PropertyFilterOptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: _manualRetry,
        name: r'propertyFilterOptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyFilterOptionsHash();

  @$internal
  @override
  $FutureProviderElement<PropertyFilterOptions> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PropertyFilterOptions> create(Ref ref) {
    return propertyFilterOptions(ref);
  }
}

String _$propertyFilterOptionsHash() =>
    r'3ff1d99ad61baec2f466547e7c6f67565077b9f8';
