import 'dart:async';

import 'package:real_estate_app/features/authentication/domain/authentication_repository.dart';

const firstUser = AuthenticatedUser(id: 'first', name: 'First account');
const secondUser = AuthenticatedUser(id: 'second', name: 'Second account');

final class FakeAuthentication implements AuthenticationRepository {
  FakeAuthentication({this.user});

  final _changes = StreamController<AuthenticatedUser?>.broadcast(sync: true);
  AuthenticatedUser? user;
  Future<void> Function()? beforeSignIn;
  int signInCalls = 0;
  int signOutCalls = 0;
  int tokenCalls = 0;

  void change(AuthenticatedUser? next) {
    user = next;
    _changes.add(next);
  }

  @override
  Stream<AuthenticatedUser?> sessionChanges() async* {
    yield user;
    yield* _changes.stream;
  }

  @override
  Future<void> signIn() async {
    signInCalls++;
    await beforeSignIn?.call();
    change(firstUser);
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    change(null);
  }

  @override
  Future<String?> idToken() async {
    tokenCalls++;
    return user?.id;
  }

  Future<void> close() => _changes.close();
}
