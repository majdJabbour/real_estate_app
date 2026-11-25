import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/models/request_cancellation.dart';
import '../../../core/network/api_client.dart';
import '../../authentication/application/authentication_providers.dart';
import '../../properties/domain/property.dart';
import '../../properties/domain/property_repository.dart';
import '../data/favorites_remote_data_source.dart';
import '../data/remote_favorites_repository.dart';
import '../domain/favorites_repository.dart';

part 'favorites_providers.g.dart';

@riverpod
FavoritesRepository favoritesRepository(Ref ref) => RemoteFavoritesRepository(
  FavoritesRemoteDataSource(ref.watch(dioProvider)),
);

typedef FavoritesSession = ({String? accountId, int revision});

@Riverpod(keepAlive: true)
class ActiveFavoritesSession extends _$ActiveFavoritesSession {
  @override
  FavoritesSession build() {
    ref.listen(authenticationSessionProvider, (_, next) {
      final id = next.asData?.value?.id;
      if (id != state.accountId) {
        state = (accountId: id, revision: state.revision + 1);
      }
    });
    return (
      accountId: ref.read(authenticationSessionProvider).asData?.value?.id,
      revision: 0,
    );
  }
}

final class FavoriteMembership {
  FavoriteMembership({
    required Iterable<String> ids,
    Iterable<String> pending = const [],
    Iterable<String> uncertain = const [],
    this.listRevision = 0,
  }) : ids = Set.unmodifiable(ids),
       pending = Set.unmodifiable(pending),
       uncertain = Set.unmodifiable(uncertain);

  final Set<String> ids;
  final Set<String> pending;
  final Set<String> uncertain;
  final int listRevision;
}

@Riverpod(keepAlive: true, retry: _noRetry)
class FavoriteMembershipController extends _$FavoriteMembershipController {
  RequestCancellation? _session;

  @override
  FutureOr<FavoriteMembership?> build() async {
    final active = ref.watch(activeFavoritesSessionProvider);
    final account = active.accountId;
    final session = _session = RequestCancellation();
    ref.onDispose(session.cancel);
    if (account == null) return null;
    final ids = await ref
        .watch(favoritesRepositoryProvider)
        .getIds(account, session);
    if (!_isCurrent(active, session)) {
      throw const AppFailure(FailureKind.cancelled);
    }
    return FavoriteMembership(ids: ids);
  }

  Future<void> toggle(String id) async {
    final active = ref.read(activeFavoritesSessionProvider);
    final account = active.accountId;
    final session = _session;
    final current = state.asData?.value;
    if (account == null ||
        session == null ||
        !_isCurrent(active, session) ||
        state.isLoading ||
        current == null ||
        current.pending.contains(id)) {
      return;
    }

    final repository = ref.read(favoritesRepositoryProvider);
    final wasFavorite = current.ids.contains(id);
    final needsRead = current.uncertain.contains(id);
    _update(
      id,
      selected: needsRead ? wasFavorite : !wasFavorite,
      pending: true,
    );
    if (needsRead) {
      try {
        await _reconcile(repository, active, session, id);
      } finally {
        if (_isCurrent(active, session)) _update(id, pending: false);
      }
      return;
    }

    try {
      await repository.setFavorite(account, id, !wasFavorite, session);
      if (_isCurrent(active, session)) _update(id, refreshList: true);
    } catch (error) {
      if (!_isCurrent(active, session)) return;
      _update(id, selected: wasFavorite);
      if (_hasUncertainOutcome(error)) {
        _update(id, uncertain: true);
        try {
          await _reconcile(repository, active, session, id);
        } catch (_) {
          if (_isCurrent(active, session)) _update(id, refreshList: true);
        }
      }
      if (_isCurrent(active, session)) rethrow;
    } finally {
      if (_isCurrent(active, session)) _update(id, pending: false);
    }
  }

  Future<void> _reconcile(
    FavoritesRepository repository,
    FavoritesSession active,
    RequestCancellation session,
    String id,
  ) async {
    final ids = await repository.getIds(active.accountId!, session);
    if (_isCurrent(active, session)) {
      _update(
        id,
        selected: ids.contains(id),
        uncertain: false,
        refreshList: true,
      );
    }
  }

  bool _isCurrent(FavoritesSession active, RequestCancellation session) =>
      !session.isCancelled &&
      ref.mounted &&
      identical(session, _session) &&
      ref.read(activeFavoritesSessionProvider) == active;

  void _update(
    String id, {
    bool? selected,
    bool? pending,
    bool? uncertain,
    bool refreshList = false,
  }) {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(
      FavoriteMembership(
        ids: _withMembership(current.ids, id, selected),
        pending: _withMembership(current.pending, id, pending),
        uncertain: _withMembership(current.uncertain, id, uncertain),
        listRevision: current.listRevision + (refreshList ? 1 : 0),
      ),
    );
  }
}

@Riverpod(retry: _noRetry)
Future<PaginatedResult<PropertySummary>?> favoriteProperties(
  Ref ref,
  int page,
) async {
  final active = ref.watch(activeFavoritesSessionProvider);
  final account = active.accountId;
  if (account == null) return null;
  ref.watch(appLocaleProvider);
  ref.watch(
    favoriteMembershipControllerProvider.select(
      (value) => value.asData?.value?.listRevision ?? 0,
    ),
  );
  final cancellation = RequestCancellation();
  ref.onDispose(cancellation.cancel);
  final result = await ref
      .watch(favoritesRepositoryProvider)
      .getPage(account, page, cancellation);
  if (cancellation.isCancelled ||
      !ref.mounted ||
      ref.read(activeFavoritesSessionProvider) != active) {
    throw const AppFailure(FailureKind.cancelled);
  }
  return result;
}

Set<String> _withMembership(Set<String> values, String id, bool? contains) =>
    switch (contains) {
      true => {...values, id},
      false => {...values}..remove(id),
      null => values,
    };

bool _hasUncertainOutcome(Object error) =>
    error is! AppFailure ||
    switch (error.kind) {
      FailureKind.connection ||
      FailureKind.timeout ||
      FailureKind.server ||
      FailureKind.serviceUnavailable ||
      FailureKind.malformedResponse ||
      FailureKind.unexpected => true,
      _ => false,
    };

Duration? _noRetry(int retryCount, Object error) => null;
