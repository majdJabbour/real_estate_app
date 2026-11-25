// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(propertyRemoteDataSource)
final propertyRemoteDataSourceProvider = PropertyRemoteDataSourceProvider._();

final class PropertyRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          PropertyRemoteDataSource,
          PropertyRemoteDataSource,
          PropertyRemoteDataSource
        >
    with $Provider<PropertyRemoteDataSource> {
  PropertyRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<PropertyRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PropertyRemoteDataSource create(Ref ref) {
    return propertyRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PropertyRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PropertyRemoteDataSource>(value),
    );
  }
}

String _$propertyRemoteDataSourceHash() =>
    r'794312ef282429b42531b25599cc39eb5966a409';

@ProviderFor(propertyRepository)
final propertyRepositoryProvider = PropertyRepositoryProvider._();

final class PropertyRepositoryProvider
    extends
        $FunctionalProvider<
          PropertyRepository,
          PropertyRepository,
          PropertyRepository
        >
    with $Provider<PropertyRepository> {
  PropertyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'propertyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$propertyRepositoryHash();

  @$internal
  @override
  $ProviderElement<PropertyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PropertyRepository create(Ref ref) {
    return propertyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PropertyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PropertyRepository>(value),
    );
  }
}

String _$propertyRepositoryHash() =>
    r'a09edae58a83ec3ad2b51249b95d29362c2d0878';
