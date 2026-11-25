import 'package:dio/dio.dart';

import '../../../core/models/request_cancellation.dart';
import '../../../core/network/api_client.dart';
import '../domain/authentication_repository.dart';
import 'profile_dto.dart';

final class RemoteProfileRepository implements ProfileRepository {
  const RemoteProfileRepository(this._client);

  final Dio _client;

  @override
  Future<AuthenticatedUser> load(RequestCancellation cancellation) async {
    final token = CancelToken();
    final unsubscribe = cancellation.onCancel(token.cancel);
    try {
      final response = await requestApi(
        _client,
        'auth/me',
        decodeData: ProfileDto.decode,
        access: ApiAccess.protected,
        cancelToken: token,
      );
      return response.data;
    } finally {
      unsubscribe();
    }
  }
}
