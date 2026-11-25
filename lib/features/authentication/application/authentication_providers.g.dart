// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authenticationInitializer)
final authenticationInitializerProvider = AuthenticationInitializerProvider._();

final class AuthenticationInitializerProvider
    extends
        $FunctionalProvider<
          Future<AuthenticationRepository> Function()?,
          Future<AuthenticationRepository> Function()?,
          Future<AuthenticationRepository> Function()?
        >
    with $Provider<Future<AuthenticationRepository> Function()?> {
  AuthenticationInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationInitializerHash();

  @$internal
  @override
  $ProviderElement<Future<AuthenticationRepository> Function()?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<AuthenticationRepository> Function()? create(Ref ref) {
    return authenticationInitializer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<AuthenticationRepository> Function()? value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<AuthenticationRepository> Function()?>(
            value,
          ),
    );
  }
}

String _$authenticationInitializerHash() =>
    r'e0b1374c4a23f8dc4fbbd012726db8181269722e';

@ProviderFor(authenticationRepository)
final authenticationRepositoryProvider = AuthenticationRepositoryProvider._();

final class AuthenticationRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthenticationRepository?>,
          AuthenticationRepository?,
          FutureOr<AuthenticationRepository?>
        >
    with
        $FutureModifier<AuthenticationRepository?>,
        $FutureProvider<AuthenticationRepository?> {
  AuthenticationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'authenticationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AuthenticationRepository?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthenticationRepository?> create(Ref ref) {
    return authenticationRepository(ref);
  }
}

String _$authenticationRepositoryHash() =>
    r'd97470159c0967dc7f964691ae9836376f95f8f9';

@ProviderFor(authenticationSession)
final authenticationSessionProvider = AuthenticationSessionProvider._();

final class AuthenticationSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthenticatedUser?>,
          AuthenticatedUser?,
          Stream<AuthenticatedUser?>
        >
    with
        $FutureModifier<AuthenticatedUser?>,
        $StreamProvider<AuthenticatedUser?> {
  AuthenticationSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'authenticationSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationSessionHash();

  @$internal
  @override
  $StreamProviderElement<AuthenticatedUser?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AuthenticatedUser?> create(Ref ref) {
    return authenticationSession(ref);
  }
}

String _$authenticationSessionHash() =>
    r'274c30f8fda00fd99460ff76e5a8104343fee67f';

@ProviderFor(AuthenticationAction)
final authenticationActionProvider = AuthenticationActionProvider._();

final class AuthenticationActionProvider
    extends $NotifierProvider<AuthenticationAction, AsyncValue<void>> {
  AuthenticationActionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationActionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationActionHash();

  @$internal
  @override
  AuthenticationAction create() => AuthenticationAction();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$authenticationActionHash() =>
    r'2d1908344817ddb7e43851aaa005e40d73750469';

abstract class _$AuthenticationAction extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'147a0741b0d0f6f5bfc5c80c5ce04ddc74e7459b';

@ProviderFor(verifiedProfile)
final verifiedProfileProvider = VerifiedProfileProvider._();

final class VerifiedProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthenticatedUser?>,
          AuthenticatedUser?,
          FutureOr<AuthenticatedUser?>
        >
    with
        $FutureModifier<AuthenticatedUser?>,
        $FutureProvider<AuthenticatedUser?> {
  VerifiedProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'verifiedProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifiedProfileHash();

  @$internal
  @override
  $FutureProviderElement<AuthenticatedUser?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthenticatedUser?> create(Ref ref) {
    return verifiedProfile(ref);
  }
}

String _$verifiedProfileHash() => r'e7440fd0e57304f4ea434a4a736951b494e985a3';
