import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/authentication_repository.dart';

final class FirebaseAuthenticationRepository
    implements AuthenticationRepository {
  FirebaseAuthenticationRepository(this._firebase, this._google);

  final FirebaseAuth _firebase;
  final GoogleSignIn _google;
  Future<void>? _googleInitialization;
  bool _signingOut = false;
  int _sessionRevision = 0;

  @override
  Stream<AuthenticatedUser?> sessionChanges() {
    String? previousId;
    return _firebase.idTokenChanges().map((user) {
      if (user?.uid != previousId) {
        previousId = user?.uid;
        _sessionRevision++;
      }
      return user == null
          ? null
          : AuthenticatedUser(
              id: user.uid,
              email: user.email,
              name: user.displayName,
              avatar: user.photoURL,
            );
    });
  }

  @override
  Future<void> signIn() async {
    try {
      await (_googleInitialization ??= _google.initialize());
      final account = await _google.authenticate();
      final token = account.authentication.idToken;
      if (token == null || token.isEmpty) {
        throw AuthenticationFailure.configuration;
      }
      await _firebase.signInWithCredential(
        GoogleAuthProvider.credential(idToken: token),
      );
    } catch (error) {
      throw _mapFailure(error);
    }
  }

  @override
  Future<void> signOut() async {
    _signingOut = true;
    _sessionRevision++;
    try {
      await _firebase.signOut();
      try {
        await (_googleInitialization ??= _google.initialize());
        await _google.signOut();
      } catch (_) {
        // Firebase already cleared the application session.
      }
    } catch (error) {
      throw _mapFailure(error);
    } finally {
      _signingOut = false;
    }
  }

  @override
  Future<String?> idToken() async {
    final user = _firebase.currentUser;
    if (_signingOut || user == null) return null;
    final revision = _sessionRevision;
    bool isCurrent() =>
        !_signingOut &&
        revision == _sessionRevision &&
        _firebase.currentUser?.uid == user.uid;

    try {
      final token = await user.getIdToken();
      return isCurrent() ? token : null;
    } on FirebaseAuthException catch (error) {
      if (!isCurrent()) return null;
      if (const {
        'user-disabled',
        'user-token-expired',
        'invalid-user-token',
        'user-not-found',
      }.contains(error.code)) {
        await signOut();
        return null;
      }
      throw _mapFailure(error);
    }
  }
}

AuthenticationFailure _mapFailure(Object error) => switch (error) {
  GoogleSignInException(code: GoogleSignInExceptionCode.canceled) =>
    AuthenticationFailure.cancelled,
  GoogleSignInException(
    code: GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError,
  ) =>
    AuthenticationFailure.configuration,
  FirebaseAuthException(code: 'network-request-failed') ||
  PlatformException(
    code: 'network_error' ||
        'network-request-failed' ||
        'NSURLErrorDomain: -1001' ||
        'NSURLErrorDomain: -1003' ||
        'NSURLErrorDomain: -1004' ||
        'NSURLErrorDomain: -1005' ||
        'NSURLErrorDomain: -1006' ||
        'NSURLErrorDomain: -1009',
  ) => AuthenticationFailure.connection,
  FirebaseAuthException(code: 'operation-not-allowed' || 'invalid-api-key') =>
    AuthenticationFailure.configuration,
  FirebaseAuthException() => AuthenticationFailure.rejected,
  _ => AuthenticationFailure.from(error),
};
