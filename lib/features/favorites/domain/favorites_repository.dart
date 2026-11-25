import '../../../core/models/request_cancellation.dart';
import '../../properties/domain/property.dart';
import '../../properties/domain/property_repository.dart';

abstract interface class FavoritesRepository {
  Future<Set<String>> getIds(
    String accountId,
    RequestCancellation cancellation,
  );

  Future<PaginatedResult<PropertySummary>> getPage(
    String accountId,
    int page,
    RequestCancellation cancellation,
  );

  Future<void> setFavorite(
    String accountId,
    String propertyId,
    bool isFavorite,
    RequestCancellation cancellation,
  );
}
