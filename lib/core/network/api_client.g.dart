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

@ProviderFor(accountApiTokenSource)
final accountApiTokenSourceProvider = AccountApiTokenSourceProvider._();

final class AccountApiTokenSourceProvider
    extends
        $FunctionalProvider<
          Future<String?> Function(String),
          Future<String?> Function(String),
          Future<String?> Function(String)
        >
    with $Provider<Future<String?> Function(String)> {
  AccountApiTokenSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountApiTokenSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountApiTokenSourceHash();

  @$internal
  @override
  $ProviderElement<Future<String?> Function(String)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<String?> Function(String) create(Ref ref) {
    return accountApiTokenSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Future<String?> Function(String) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Future<String?> Function(String)>(
        value,
      ),
    );
  }
}

String _$accountApiTokenSourceHash() =>
    r'938c8e260f05c894019c9fabcf0dadf1abd530ea';

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

String _$dioHash() => r'867b799722a122c81ef4144619a0470549f9e478';
