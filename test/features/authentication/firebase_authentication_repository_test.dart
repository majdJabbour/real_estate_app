import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:real_estate_app/features/authentication/data/firebase_authentication_repository.dart';
import 'package:real_estate_app/features/authentication/domain/authentication_repository.dart';

class _Auth extends Mock implements FirebaseAuth {}

class _User extends Mock implements User {}

class _Google extends Mock implements GoogleSignIn {}

class _GoogleAccount extends Mock implements GoogleSignInAccount {}

class _Credential extends Mock implements UserCredential {}

void main() {
  late _Auth firebase;
  late _Google google;
  late FirebaseAuthenticationRepository repository;
  late _User user;

  setUpAll(
    () => registerFallbackValue(
      GoogleAuthProvider.credential(idToken: 'synthetic-fallback'),
    ),
  );

  setUp(() {
    firebase = _Auth();
    google = _Google();
    user = _User();
    repository = FirebaseAuthenticationRepository(firebase, google);
    when(() => user.uid).thenReturn('current');
    when(() => firebase.currentUser).thenReturn(user);
    when(() => firebase.signOut()).thenAnswer((_) async {
      when(() => firebase.currentUser).thenReturn(null);
    });
    when(() => google.initialize()).thenAnswer((_) async {});
    when(() => google.signOut()).thenAnswer((_) async {});
  });

  test(
    'exchanges the Google ID token with Firebase and initializes Google once',
    () async {
      final account = _GoogleAccount();
      when(() => account.authentication).thenReturn(
        const GoogleSignInAuthentication(
          idToken: 'synthetic-google-credential',
        ),
      );
      when(() => google.authenticate()).thenAnswer((_) async => account);
      when(() => firebase.signInWithCredential(any()))
          .thenAnswer((_) async => _Credential());

      await repository.signIn();
      await repository.signOut();

      final credential =
          verify(() => firebase.signInWithCredential(captureAny()))
                  .captured
                  .single
              as OAuthCredential;
      expect(credential.providerId, 'google.com');
      expect(credential.idToken, 'synthetic-google-credential');
      verify(() => google.initialize()).called(1);
      verify(() => google.signOut()).called(1);
    },
  );

  test(
    'SDK account cancellation never reaches Firebase credential exchange',
    () async {
      when(() => google.authenticate()).thenThrow(
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );
      await expectLater(
        repository.signIn(),
        throwsA(AuthenticationFailure.cancelled),
      );
      verifyNever(() => firebase.signInWithCredential(any()));
    },
  );

  test(
    'maps the iOS SDK connectivity error without exposing its message',
    () async {
      when(() => google.authenticate())
          .thenThrow(PlatformException(code: 'NSURLErrorDomain: -1009'));
      await expectLater(
        repository.signIn(),
        throwsA(AuthenticationFailure.connection),
      );
      verifyNever(() => firebase.signInWithCredential(any()));
    },
  );

  test('no Firebase user or token is reported as missing', () async {
    when(() => user.getIdToken()).thenAnswer((_) async => null);
    expect(await repository.idToken(), isNull);
    when(() => firebase.currentUser).thenReturn(null);
    expect(await repository.idToken(), isNull);
    verify(() => user.getIdToken()).called(1);
  });

  test(
    'reads the Firebase ID token and drops one acquired after sign-out',
    () async {
      when(() => user.getIdToken())
          .thenAnswer((_) async => 'synthetic-firebase-token');
      expect(await repository.idToken(), 'synthetic-firebase-token');
      final pending = Completer<String?>();
      when(() => user.getIdToken()).thenAnswer((_) => pending.future);
      final token = repository.idToken();
      await repository.signOut();
      pending.complete('synthetic-stale-token');
      expect(await token, isNull);
      expect(await repository.idToken(), isNull);
    },
  );

  test('Firebase sign-out survives a Google cleanup failure', () async {
    when(() => google.signOut()).thenThrow(StateError('test cleanup error'));
    await repository.signOut();
    expect(firebase.currentUser, isNull);
    expect(await repository.idToken(), isNull);
  });

  test(
    'a disabled Firebase account is cleared when token acquisition fails',
    () async {
      when(() => user.getIdToken())
          .thenThrow(FirebaseAuthException(code: 'user-disabled'));
      expect(await repository.idToken(), isNull);
      verify(() => firebase.signOut()).called(1);
    },
  );
}
