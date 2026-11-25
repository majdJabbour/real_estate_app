import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/models/request_cancellation.dart';

part 'authentication_repository.freezed.dart';

@freezed
abstract class AuthenticatedUser with _$AuthenticatedUser {
  const factory AuthenticatedUser({
    required String id,
    String? email,
    String? name,
    String? avatar,
  }) = _AuthenticatedUser;
}

abstract interface class AuthenticationRepository {
  Stream<AuthenticatedUser?> sessionChanges();
  Future<void> signIn();
  Future<void> signOut();
  Future<String?> idToken();
}

abstract interface class ProfileRepository {
  Future<AuthenticatedUser> load(RequestCancellation cancellation);
}

abstract interface class AccountTokenRepository {
  Future<String?> idTokenForAccount(String accountId);
}

enum AuthenticationFailure {
  cancelled,
  connection,
  configuration,
  rejected,
  unexpected;

  static AuthenticationFailure from(Object error) =>
      error is AuthenticationFailure ? error : unexpected;
}
