import 'dart:async';

import 'package:real_estate_app/core/models/request_cancellation.dart';
import 'package:real_estate_app/features/favorites/domain/favorites_repository.dart';
import 'package:real_estate_app/features/properties/domain/property.dart';
import 'package:real_estate_app/features/properties/domain/property_repository.dart';

import '../properties/home_fakes.dart';

final class FakeFavorites implements FavoritesRepository {
  final idsByAccount = <String, Set<String>>{};
  final idReads = <(String, RequestCancellation)>[];
  final pageReads = <(String, int, RequestCancellation)>[];
  final writes = <(String, String, bool, RequestCancellation)>[];

  FutureOr<Set<String>> Function(String)? loadIds;
  FutureOr<PaginatedResult<PropertySummary>> Function(String, int)? loadPage;
  Future<void> Function(String, String, bool)? beforeWrite;

  @override
  Future<Set<String>> getIds(
    String accountId,
    RequestCancellation cancellation,
  ) async {
    idReads.add((accountId, cancellation));
    return await loadIds?.call(accountId) ??
        Set.of(idsByAccount[accountId] ?? const {});
  }

  @override
  Future<PaginatedResult<PropertySummary>> getPage(
    String accountId,
    int page,
    RequestCancellation cancellation,
  ) async {
    pageReads.add((accountId, page, cancellation));
    return await loadPage?.call(accountId, page) ??
        homePage((idsByAccount[accountId] ?? {}).map(homeProperty));
  }

  @override
  Future<void> setFavorite(
    String accountId,
    String propertyId,
    bool isFavorite,
    RequestCancellation cancellation,
  ) async {
    writes.add((accountId, propertyId, isFavorite, cancellation));
    await beforeWrite?.call(accountId, propertyId, isFavorite);
    final ids = idsByAccount.putIfAbsent(accountId, () => {});
    if (isFavorite) {
      ids.add(propertyId);
    } else {
      ids.remove(propertyId);
    }
  }
}
