// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiTokenSource)
final apiTokenSourceProvider = ApiTokenSourceProvider._();

final class ApiTokenSourceProvider
    extends $FunctionalProvider<ApiTokenSource, ApiTokenSource, ApiTokenSource>
    with $Provider<ApiTokenSource> {
  ApiTokenSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiTokenSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiTokenSourceHash();

  @$internal
  @override
  $ProviderElement<ApiTokenSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiTokenSource create(Ref ref) {
    return apiTokenSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiTokenSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiTokenSource>(value),
    );
  }
}

String _$apiTokenSourceHash() => r'c424e956f549a17b926a7d0827a6ffed034c625b';

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'06f98b6fe4d517df5906acaa64dde412f39fe0fa';
