// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'explore_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExploreController)
final exploreControllerProvider = ExploreControllerProvider._();

final class ExploreControllerProvider
    extends $NotifierProvider<ExploreController, ExploreState> {
  ExploreControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exploreControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exploreControllerHash();

  @$internal
  @override
  ExploreController create() => ExploreController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExploreState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExploreState>(value),
    );
  }
}

String _$exploreControllerHash() => r'5c5c6175f3014b6ce986e87d50ddd7defdd06351';

abstract class _$ExploreController extends $Notifier<ExploreState> {
  ExploreState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExploreState, ExploreState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExploreState, ExploreState>,
              ExploreState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
