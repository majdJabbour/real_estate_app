import '../../../core/errors/app_failure.dart';
import '../../../core/models/request_cancellation.dart';
import '../../properties/domain/property.dart';
import '../../properties/domain/property_repository.dart';
import '../domain/favorites_repository.dart';
import 'favorites_remote_data_source.dart';

final class RemoteFavoritesRepository implements FavoritesRepository {
  const RemoteFavoritesRepository(this._remote);

  final FavoritesRemoteDataSource _remote;

  @override
  Future<Set<String>> getIds(
    String accountId,
    RequestCancellation cancellation,
  ) async => (await _remote.getIds(accountId, cancellation)).data;

  @override
  Future<PaginatedResult<PropertySummary>> getPage(
    String accountId,
    int page,
    RequestCancellation cancellation,
  ) async {
    final response = await _remote.getPage(accountId, page, cancellation);
    final pagination = response.pagination;
    if (pagination == null || pagination.page != page) {
      throw const AppFailure(FailureKind.malformedResponse);
    }
    return PaginatedResult(
      items: response.data.map((dto) => dto.toDomain()),
      pagination: pagination,
    );
  }

  @override
  Future<void> setFavorite(
    String accountId,
    String propertyId,
    bool isFavorite,
    RequestCancellation cancellation,
  ) async {
    final result = await _remote.setFavorite(
      accountId,
      propertyId,
      isFavorite,
      cancellation,
    );
    if (result.data.propertyId != propertyId ||
        result.data.isFavorite != isFavorite) {
      throw const AppFailure(FailureKind.malformedResponse);
    }
  }
}
