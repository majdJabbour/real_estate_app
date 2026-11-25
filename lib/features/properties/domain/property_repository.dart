import '../../../core/models/pagination.dart';
import '../../../core/models/request_cancellation.dart';
import 'property.dart';
import 'property_filter_options.dart';
import 'property_query.dart';

final class PaginatedResult<T> {
  PaginatedResult({required Iterable<T> items, required this.pagination})
    : items = List.unmodifiable(items);

  final List<T> items;
  final Pagination pagination;
}

abstract interface class PropertyRepository {
  Future<PaginatedResult<PropertySummary>> getProperties(
    PropertyQuery query, {
    RequestCancellation? cancellation,
  });

  Future<PropertyDetails> getPropertyDetails(
    String propertyId, {
    RequestCancellation? cancellation,
  });

  Future<PropertyFilterOptions> getFilterOptions({
    RequestCancellation? cancellation,
  });
}
