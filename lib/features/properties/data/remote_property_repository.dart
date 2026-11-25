import '../../../core/errors/app_failure.dart';
import '../../../core/models/request_cancellation.dart';
import '../domain/property.dart';
import '../domain/property_filter_options.dart';
import '../domain/property_query.dart';
import '../domain/property_repository.dart';
import 'property_remote_data_source.dart';

final class RemotePropertyRepository implements PropertyRepository {
  const RemotePropertyRepository(this._remote);

  final PropertyRemoteDataSource _remote;

  @override
  Future<PaginatedResult<PropertySummary>> getProperties(
    PropertyQuery query, {
    RequestCancellation? cancellation,
  }) async {
    final response = await _remote.getProperties(
      query,
      cancellation: cancellation,
    );
    final pagination = response.pagination;
    if (pagination == null) {
      throw const AppFailure(FailureKind.malformedResponse);
    }
    return PaginatedResult(
      items: response.data.map((dto) => dto.toDomain()),
      pagination: pagination,
    );
  }

  @override
  Future<PropertyDetails> getPropertyDetails(
    String propertyId, {
    RequestCancellation? cancellation,
  }) async {
    final response = await _remote.getPropertyDetails(
      propertyId,
      cancellation: cancellation,
    );
    return response.data.toDomain();
  }

  @override
  Future<PropertyFilterOptions> getFilterOptions({
    RequestCancellation? cancellation,
  }) async {
    final response = await _remote.getFilterOptions(cancellation: cancellation);
    return response.data.toDomain();
  }
}
