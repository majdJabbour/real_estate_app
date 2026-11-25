import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/models/pagination.dart';
import '../../../core/models/request_cancellation.dart';
import '../domain/property.dart';
import '../domain/property_query.dart';
import 'property_providers.dart';

part 'explore_controller.freezed.dart';
part 'explore_controller.g.dart';

enum ExploreLoad { initial, refresh, next }

@freezed
abstract class ExploreState with _$ExploreState {
  const ExploreState._();

  const factory ExploreState({
    required PropertyQuery query,
    required AppLanguage language,
    @Default([]) List<PropertySummary> items,
    Pagination? pagination,
    @Default(ExploreLoad.initial) ExploreLoad? loading,
    ({ExploreLoad operation, Object error})? failure,
    @Default(false) bool pagingStalled,
  }) = _ExploreState;

  bool get canLoadMore =>
      loading == null &&
      failure == null &&
      !pagingStalled &&
      (pagination?.hasNextPage ?? false) &&
      pagination!.page < 1000000;
}

@riverpod
class ExploreController extends _$ExploreController {
  static const searchDelay = Duration(milliseconds: 400);

  Timer? _debounce;
  String? _pendingSearch;
  RequestCancellation? _request;
  bool _started = false;

  @override
  ExploreState build() {
    ref.onDispose(() {
      _debounce?.cancel();
      _request?.cancel();
    });
    ref.listen(appLocaleProvider, (_, next) {
      if (!_started) {
        state = state.copyWith(language: next);
        return;
      }
      final query = _withPendingSearch(state.query);
      unawaited(_replace(query, next));
    });
    return ExploreState(
      query: PropertyQuery(),
      language: ref.read(appLocaleProvider),
    );
  }

  Future<void> start([PropertyQuery? preset]) {
    if (preset != null) {
      _clearPendingSearch();
      return setQuery(preset);
    }
    return _started ? Future.value() : setQuery(state.query);
  }

  void editSearch(String value) {
    _debounce?.cancel();
    _pendingSearch = value;
    _debounce = Timer(searchDelay, submitSearch);
  }

  Future<void> submitSearch() => setQuery(state.query);

  Future<void> setQuery(PropertyQuery query) {
    final normalized = _withPendingSearch(query).copyWith(page: 1);
    final language = ref.read(appLocaleProvider);
    if (_started && normalized == state.query && language == state.language) {
      return Future.value();
    }
    return _replace(normalized, language);
  }

  Future<void> _replace(PropertyQuery query, AppLanguage language) {
    _started = true;
    state = ExploreState(query: query, language: language);
    return _load(query, ExploreLoad.initial);
  }

  Future<void> refresh() {
    if (_pendingSearch != null) {
      final query = _withPendingSearch(state.query);
      if (query != state.query) return setQuery(query);
    }
    if (_request != null) return Future.value();
    return _load(
      state.query,
      state.pagination == null ? ExploreLoad.initial : ExploreLoad.refresh,
    );
  }

  Future<void> loadMore() {
    if (!state.canLoadMore || _pendingSearch != null) return Future.value();
    return _load(
      state.query.copyWith(page: state.pagination!.page + 1),
      ExploreLoad.next,
    );
  }

  Future<void> retry() {
    final failure = state.failure;
    if (failure == null || _request != null) return Future.value();
    return _load(
      failure.operation == ExploreLoad.next
          ? state.query.copyWith(page: state.pagination!.page + 1)
          : state.query,
      failure.operation,
    );
  }

  Future<void> _load(PropertyQuery query, ExploreLoad operation) async {
    _request?.cancel();
    final token = _request = RequestCancellation();
    final language = state.language;
    state = state.copyWith(loading: operation, failure: null);
    bool isCurrent() =>
        ref.mounted &&
        identical(token, _request) &&
        language == ref.read(appLocaleProvider);

    try {
      final response = await ref
          .read(propertyRepositoryProvider)
          .getProperties(query, cancellation: token);
      if (!isCurrent()) return;
      if (response.pagination.page != query.page) {
        throw const AppFailure(FailureKind.malformedResponse);
      }
      final previous = operation == ExploreLoad.next
          ? state.items
          : <PropertySummary>[];
      final ids = previous.map((item) => item.id).toSet();
      final added = response.items.where((item) => ids.add(item.id)).toList();
      state = state.copyWith(
        items: [...previous, ...added],
        pagination: response.pagination,
        loading: null,
        pagingStalled: added.isEmpty,
      );
    } catch (error) {
      if (!isCurrent()) return;
      final cancelled =
          error is AppFailure && error.kind == FailureKind.cancelled;
      state = state.copyWith(
        loading: null,
        failure: cancelled ? null : (operation: operation, error: error),
        pagingStalled: cancelled && operation == ExploreLoad.next,
      );
    } finally {
      if (identical(token, _request)) _request = null;
    }
  }

  PropertyQuery _withPendingSearch(PropertyQuery query) {
    final pending = _pendingSearch;
    _clearPendingSearch();
    return pending == null
        ? query
        : query.copyWith(
            search: String.fromCharCodes(pending.trim().runes.take(120)),
          );
  }

  void _clearPendingSearch() {
    _debounce?.cancel();
    _pendingSearch = null;
  }
}
