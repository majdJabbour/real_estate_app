import 'package:dio/dio.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/models/request_cancellation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../domain/property_query.dart';
import 'property_dto.dart';
import 'property_filter_options_dto.dart';
import 'property_query_parameters.dart';

final class PropertyRemoteDataSource {
  const PropertyRemoteDataSource(this._client);

  final Dio _client;

  Future<ApiResponse<List<PropertySummaryDto>>> getProperties(
    PropertyQuery query, {
    RequestCancellation? cancellation,
  }) => _get(
    'properties',
    (data) => (data as List<Object?>)
        .map(
          (item) => PropertySummaryDto.fromJson(item as Map<String, Object?>),
        )
        .toList(),
    queryParameters: propertyQueryParameters(query),
    cancellation: cancellation,
  );

  Future<ApiResponse<PropertyDetailsDto>> getPropertyDetails(
    String propertyId, {
    RequestCancellation? cancellation,
  }) async {
    if (propertyId == '.' ||
        propertyId == '..' ||
        propertyId.contains(_invalidIdCharacter) ||
        propertyId.isEmpty ||
        propertyId.length > 128) {
      throw const AppFailure(FailureKind.validation);
    }
    if (propertyId == 'filter-options') {
      throw const AppFailure(FailureKind.notFound);
    }
    return _get(
      'properties/${Uri.encodeComponent(propertyId)}',
      (data) => PropertyDetailsDto.fromJson(data as Map<String, Object?>),
      cancellation: cancellation,
    );
  }

  Future<ApiResponse<PropertyFilterOptionsDto>> getFilterOptions({
    RequestCancellation? cancellation,
  }) => _get(
    'properties/filter-options',
    (data) => PropertyFilterOptionsDto.fromJson(data as Map<String, Object?>),
    cancellation: cancellation,
  );

  Future<ApiResponse<T>> _get<T>(
    String endpoint,
    T Function(Object?) decodeData, {
    Map<String, Object?>? queryParameters,
    RequestCancellation? cancellation,
  }) async {
    final token = cancellation == null ? null : CancelToken();
    final unsubscribe = cancellation?.onCancel(() => token!.cancel());
    try {
      return await requestApi(
        _client,
        endpoint,
        decodeData: decodeData,
        access: ApiAccess.public,
        queryParameters: queryParameters,
        cancelToken: token,
      );
    } finally {
      unsubscribe?.call();
    }
  }
}

final _invalidIdCharacter = RegExp(r'[^A-Za-z0-9._~-]');
