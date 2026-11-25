import 'package:dio/dio.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/models/request_cancellation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_response.dart';
import '../../properties/data/property_dto.dart';
import 'favorite_mutation_dto.dart';

final class FavoritesRemoteDataSource {
  const FavoritesRemoteDataSource(this._client);

  final Dio _client;

  Future<ApiResponse<Set<String>>> getIds(
    String accountId,
    RequestCancellation cancellation,
  ) => _request('favorites/ids', accountId, cancellation, (data) {
    final ids = (data as List<Object?>).cast<String>();
    if (!ids.every(_isValidId)) {
      throw const FormatException('Invalid favorite property ID.');
    }
    final uniqueIds = Set<String>.unmodifiable(ids);
    if (uniqueIds.length != ids.length) {
      throw const FormatException('Duplicate favorite property IDs.');
    }
    return uniqueIds;
  }, localeSensitive: false);

  Future<ApiResponse<List<PropertySummaryDto>>> getPage(
    String accountId,
    int page,
    RequestCancellation cancellation,
  ) => _request(
    'favorites',
    accountId,
    cancellation,
    (data) => (data as List<Object?>)
        .map(
          (item) => PropertySummaryDto.fromJson(item as Map<String, Object?>),
        )
        .toList(),
    query: {'page': page, 'limit': 20},
  );

  Future<ApiResponse<FavoriteMutationDto>> setFavorite(
    String accountId,
    String propertyId,
    bool isFavorite,
    RequestCancellation cancellation,
  ) async {
    if (!_isValidId(propertyId)) {
      throw const AppFailure(FailureKind.validation);
    }
    return _request(
      'favorites/${Uri.encodeComponent(propertyId)}',
      accountId,
      cancellation,
      (data) => FavoriteMutationDto.fromJson(data as Map<String, Object?>),
      method: isFavorite ? 'PUT' : 'DELETE',
      localeSensitive: false,
    );
  }

  Future<ApiResponse<T>> _request<T>(
    String endpoint,
    String accountId,
    RequestCancellation cancellation,
    T Function(Object?) decode, {
    String method = 'GET',
    Map<String, Object?>? query,
    bool localeSensitive = true,
  }) async {
    final token = CancelToken();
    final unsubscribe = cancellation.onCancel(token.cancel);
    try {
      return await requestApi(
        _client,
        endpoint,
        decodeData: decode,
        access: ApiAccess.protected,
        accountId: accountId,
        localeSensitive: localeSensitive,
        method: method,
        queryParameters: query,
        cancelToken: token,
      );
    } finally {
      unsubscribe();
    }
  }
}

final _invalidIdCharacter = RegExp(r'[^A-Za-z0-9._~-]');

bool _isValidId(String id) =>
    id.isNotEmpty &&
    id.length <= 128 &&
    id != '.' &&
    id != '..' &&
    !id.contains(_invalidIdCharacter) &&
    !(id.length >= 4 && id.startsWith('__') && id.endsWith('__'));
