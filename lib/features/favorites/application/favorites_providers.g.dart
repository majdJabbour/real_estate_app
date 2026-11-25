// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider = FavoritesRepositoryProvider._();

final class FavoritesRepositoryProvider
    extends
        $FunctionalProvider<
          FavoritesRepository,
          FavoritesRepository,
          FavoritesRepository
        >
    with $Provider<FavoritesRepository> {
  FavoritesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoritesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoritesRepository create(Ref ref) {
    return favoritesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesRepository>(value),
    );
  }
}

String _$favoritesRepositoryHash() =>
    r'35db1d7a6bd57c4cf04590c0869a9d932669994a';

@ProviderFor(ActiveFavoritesSession)
final activeFavoritesSessionProvider = ActiveFavoritesSessionProvider._();

final class ActiveFavoritesSessionProvider
    extends $NotifierProvider<ActiveFavoritesSession, FavoritesSession> {
  ActiveFavoritesSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeFavoritesSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeFavoritesSessionHash();

  @$internal
  @override
  ActiveFavoritesSession create() => ActiveFavoritesSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesSession>(value),
    );
  }
}

String _$activeFavoritesSessionHash() =>
    r'00df9fcaf971a0f0280cd9a041d303da9cf4351b';

abstract class _$ActiveFavoritesSession extends $Notifier<FavoritesSession> {
  FavoritesSession build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FavoritesSession, FavoritesSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FavoritesSession, FavoritesSession>,
              FavoritesSession,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(FavoriteMembershipController)
final favoriteMembershipControllerProvider =
    FavoriteMembershipControllerProvider._();

final class FavoriteMembershipControllerProvider
    extends
        $AsyncNotifierProvider<
          FavoriteMembershipController,
          FavoriteMembership?
        > {
  FavoriteMembershipControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'favoriteMembershipControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteMembershipControllerHash();

  @$internal
  @override
  FavoriteMembershipController create() => FavoriteMembershipController();
}

String _$favoriteMembershipControllerHash() =>
    r'3261d8b328117aae05861c99e0059afc9e8430de';

abstract class _$FavoriteMembershipController
    extends $AsyncNotifier<FavoriteMembership?> {
  FutureOr<FavoriteMembership?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<FavoriteMembership?>, FavoriteMembership?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FavoriteMembership?>, FavoriteMembership?>,
              AsyncValue<FavoriteMembership?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(favoriteProperties)
final favoritePropertiesProvider = FavoritePropertiesFamily._();

final class FavoritePropertiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaginatedResult<PropertySummary>?>,
          PaginatedResult<PropertySummary>?,
          FutureOr<PaginatedResult<PropertySummary>?>
        >
    with
        $FutureModifier<PaginatedResult<PropertySummary>?>,
        $FutureProvider<PaginatedResult<PropertySummary>?> {
  FavoritePropertiesProvider._({
    required FavoritePropertiesFamily super.from,
    required int super.argument,
  }) : super(
         retry: _noRetry,
         name: r'favoritePropertiesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$favoritePropertiesHash();

  @override
  String toString() {
    return r'favoritePropertiesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PaginatedResult<PropertySummary>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaginatedResult<PropertySummary>?> create(Ref ref) {
    final argument = this.argument as int;
    return favoriteProperties(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FavoritePropertiesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$favoritePropertiesHash() =>
    r'fdeadf3d5ab8eb44eb26e6623c2f96849bf18a6d';

final class FavoritePropertiesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PaginatedResult<PropertySummary>?>,
          int
        > {
  FavoritePropertiesFamily._()
    : super(
        retry: _noRetry,
        name: r'favoritePropertiesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FavoritePropertiesProvider call(int page) =>
      FavoritePropertiesProvider._(argument: page, from: this);

  @override
  String toString() => r'favoritePropertiesProvider';
}
