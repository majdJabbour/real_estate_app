import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/models/request_cancellation.dart';
import '../../../core/network/api_client.dart';
import '../data/remote_profile_repository.dart';
import '../domain/authentication_repository.dart';

part 'authentication_providers.g.dart';

@Riverpod(keepAlive: true)
Future<AuthenticationRepository> Function()? authenticationInitializer(
  Ref ref,
) => null;

@Riverpod(keepAlive: true, retry: _noRetry)
Future<AuthenticationRepository?> authenticationRepository(Ref ref) async {
  final initialize = ref.watch(authenticationInitializerProvider);
  return initialize == null ? null : await initialize();
}

@Riverpod(keepAlive: true, retry: _noRetry)
Stream<AuthenticatedUser?> authenticationSession(Ref ref) async* {
  final repository = await ref.watch(authenticationRepositoryProvider.future);
  if (repository == null) {
    yield null;
  } else {
    yield* repository.sessionChanges().distinct();
  }
}

ApiTokenSource authenticatedApiTokenSource(Ref ref) => () async {
  try {
    final repository = await ref.read(authenticationRepositoryProvider.future);
    return await repository?.idToken();
  } on AuthenticationFailure catch (error) {
    throw AppFailure(switch (error) {
      AuthenticationFailure.connection => FailureKind.connection,
      AuthenticationFailure.rejected => FailureKind.unauthorized,
      AuthenticationFailure.configuration => FailureKind.serviceUnavailable,
      AuthenticationFailure.cancelled => FailureKind.cancelled,
      AuthenticationFailure.unexpected => FailureKind.unexpected,
    });
  }
};

@Riverpod(keepAlive: true)
class AuthenticationAction extends _$AuthenticationAction {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn() => _run((repository) => repository.signIn());

  Future<void> signOut() => _run((repository) => repository.signOut());

  Future<void> _run(
    Future<void> Function(AuthenticationRepository repository) operation,
  ) async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      final repository = await ref.read(
        authenticationRepositoryProvider.future,
      );
      if (!ref.mounted) return;
      if (repository == null) throw AuthenticationFailure.configuration;
      await operation(repository);
      if (ref.mounted) state = const AsyncData(null);
    } catch (error, stack) {
      if (!ref.mounted) return;
      final failure = AuthenticationFailure.from(error);
      state = failure == AuthenticationFailure.cancelled
          ? const AsyncData(null)
          : AsyncError(failure, stack);
    }
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) =>
    RemoteProfileRepository(ref.watch(dioProvider));

@Riverpod(retry: _noRetry)
Future<AuthenticatedUser?> verifiedProfile(Ref ref) async {
  final user = ref.watch(authenticationSessionProvider).asData?.value;
  if (user == null) return null;
  ref.watch(appLocaleProvider);
  final cancellation = RequestCancellation();
  ref.onDispose(cancellation.cancel);
  final profile = await ref.watch(profileRepositoryProvider).load(cancellation);
  if (cancellation.isCancelled) throw const AppFailure(FailureKind.cancelled);
  if (profile.id != user.id) throw const AppFailure(FailureKind.unauthorized);
  return profile;
}

Duration? _noRetry(int retryCount, Object error) => null;
