import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:real_estate_app/core/errors/app_failure.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/features/authentication/application/authentication_providers.dart';
import 'package:real_estate_app/features/favorites/application/favorites_providers.dart';

import '../../support/memory_locale_preferences.dart';
import '../authentication/fake_authentication.dart';
import '../properties/home_fakes.dart';
import 'fake_favorites.dart';

void main() {
  late FakeAuthentication auth;
  late FakeFavorites repository;
  late ProviderContainer container;
  late bool listening;
  final membership = favoriteMembershipControllerProvider;

  setUp(() {
    auth = FakeAuthentication();
    listening = false;
    addTearDown(auth.close);
    repository = FakeFavorites();
    container = ProviderContainer.test(
      overrides: [
        authenticationInitializerProvider.overrideWithValue(() async => auth),
        favoritesRepositoryProvider.overrideWithValue(repository),
        localePreferencesProvider.overrideWithValue(MemoryLocalePreferences()),
      ],
    );
  });

  Future<void> settleSession() async {
    if (!listening) {
      listening = true;
      container.listen(authenticationSessionProvider, (_, _) {});
      container.listen(membership, (_, _) {});
    }
    await container.read(authenticationSessionProvider.future);
    await container.pump();
  }

  Future<FavoriteMembership?> load() => container.read(membership.future);

  FavoriteMembership current() => container.read(membership).requireValue!;

  test('guest session makes no protected reads or mutations', () async {
    await settleSession();
    expect(await load(), isNull);
    expect(await container.read(favoritePropertiesProvider(1).future), isNull);
    await container.read(membership.notifier).toggle('one');
    expect(repository.idReads, isEmpty);
    expect(repository.pageReads, isEmpty);
    expect(repository.writes, isEmpty);
  });

  test(
    'initial load exposes failure and supports retry without a false empty set',
    () async {
      auth.user = firstUser;
      final pending = Completer<Set<String>>();
      repository.loadIds = (_) => pending.future;
      await settleSession();
      expect(container.read(membership).isLoading, isTrue);
      final future = expectLater(load(), throwsA(isA<AppFailure>()));
      pending.completeError(const AppFailure(FailureKind.connection));
      await future;
      expect(container.read(membership).hasError, isTrue);
      repository.loadIds = (_) => {'alpha', 'orphan'};
      container.invalidate(membership);
      final ids = (await load())!.ids;
      expect(ids, {'alpha', 'orphan'});
      expect(ids.clear, throwsUnsupportedError);
      expect(repository.idReads.map((call) => call.$1), ['first', 'first']);
    },
  );

  test('independent optimistic writes prevent duplicates and rollback only their ID', () async {
    auth.user = firstUser;
    repository.idsByAccount['first'] = {'keep', 'remove'};
    final add = Completer<void>();
    final remove = Completer<void>();
    repository.beforeWrite = (_, id, _) =>
        id == 'add' ? add.future : remove.future;
    await settleSession();
    await load();
    final controller = container.read(membership.notifier);
    final addFuture = controller.toggle('add');
    final removeFuture = controller.toggle('remove');
    final removeFailure = expectLater(removeFuture, throwsA(isA<AppFailure>()));
    expect(current().ids, {'keep', 'add'});
    expect(current().pending, {'add', 'remove'});
    await controller.toggle('add');
    expect(repository.writes.length, 2);
    add.complete();
    await addFuture;
    remove.completeError(const AppFailure(FailureKind.forbidden));
    await removeFailure;
    expect(current().ids, {'keep', 'add', 'remove'});
    expect(current().pending, isEmpty);
    expect(current().listRevision, 1);
    expect(repository.idReads.length, 1);
    repository.beforeWrite = null;
    await controller.toggle('remove');
    expect(current().ids, {'keep', 'add'});
    expect(repository.idsByAccount['first'], current().ids);
  });

  test(
    'timeout reconciles only the affected ID while another write is pending',
    () async {
      auth.user = firstUser;
      final reread = Completer<Set<String>>();
      final otherWrite = Completer<void>();
      repository.idsByAccount['first'] = {'timeout'};
      await settleSession();
      await load();
      repository.loadIds = (_) => reread.future;
      repository.beforeWrite = (_, id, _) async {
        if (id == 'other') return otherWrite.future;
        repository.idsByAccount['first']!.remove(id);
        throw const AppFailure(FailureKind.timeout);
      };
      final controller = container.read(membership.notifier);
      final other = controller.toggle('other');
      final timedOut = expectLater(
        controller.toggle('timeout'),
        throwsA(isA<AppFailure>()),
      );
      await Future<void>.delayed(Duration.zero);
      expect(current().ids, {'timeout', 'other'});
      expect(current().uncertain, {'timeout'});
      reread.complete({});
      await timedOut;
      expect(current().ids, {'other'});
      expect(current().pending, {'other'});
      expect(current().uncertain, isEmpty);
      otherWrite.complete();
      await other;
      expect(repository.writes.length, 2);
      expect(repository.idReads.length, 2);
    },
  );

  test('failed reconciliation keeps the ID uncertain and retry performs a read only', () async {
    auth.user = firstUser;
    await settleSession();
    await load();
    repository.loadIds = (_) => throw const AppFailure(FailureKind.connection);
    repository.beforeWrite = (_, _, _) async =>
        throw const AppFailure(FailureKind.timeout);
    final controller = container.read(membership.notifier);
    await expectLater(
      controller.toggle('uncertain'),
      throwsA(isA<AppFailure>()),
    );
    expect(current().uncertain, {'uncertain'});
    expect(current().pending, isEmpty);
    repository.loadIds = (_) => {'uncertain'};
    await controller.toggle('uncertain');
    expect(current().ids, {'uncertain'});
    expect(current().uncertain, isEmpty);
    expect(repository.writes.length, 1);
  });

  test(
    'switching accounts cancels old reads and discards stale mutation results',
    () async {
      auth.user = firstUser;
      repository.idsByAccount['first'] = {'private-first'};
      repository.idsByAccount['second'] = {'private-second'};
      final page = Completer<Never>();
      final pendingWrite = Completer<void>();
      repository.loadPage = (id, _) => id == 'first'
          ? page.future
          : homePage([homeProperty('private-second')]);
      repository.beforeWrite = (_, _, _) => pendingWrite.future;
      await settleSession();
      expect((await load())!.ids, {'private-first'});
      final pageProvider = favoritePropertiesProvider(1);
      final watcher = container.listen(pageProvider, (_, _) {});
      addTearDown(watcher.close);
      final write = container.read(membership.notifier).toggle('late');
      expect(repository.pageReads.single.$1, 'first');

      auth.change(secondUser);
      await settleSession();
      expect((await load())!.ids, {'private-second'});
      expect(repository.idReads.first.$2.isCancelled, isTrue);
      expect(repository.pageReads.first.$3.isCancelled, isTrue);
      expect(
        (await container.read(pageProvider.future))!.items.single.id,
        'private-second',
      );

      pendingWrite.complete();
      page.completeError(const AppFailure(FailureKind.cancelled));
      await write;
      expect(current().ids, {'private-second'});
      expect(current().listRevision, 0);

      auth.change(null);
      await settleSession();
      expect(await load(), isNull);
      expect(await container.read(pageProvider.future), isNull);
      expect(repository.idReads.map((call) => call.$1), ['first', 'second']);
    },
  );

  test('locale refreshes the list while membership remains stable', () async {
    auth.user = firstUser;
    repository.idsByAccount['first'] = {'one'};
    repository.loadPage = (_, _) => homePage([
      homeProperty(
        'one',
        arabic: container.read(appLocaleProvider) == AppLanguage.arabic,
      ),
    ]);
    await settleSession();
    await load();
    final provider = favoritePropertiesProvider(1);
    final watcher = container.listen(provider, (_, _) {});
    addTearDown(watcher.close);
    expect(
      (await container.read(provider.future))!.items.single.title,
      startsWith('Sunlit'),
    );
    await container.read(appLocaleProvider.notifier).select(AppLanguage.arabic);
    expect(
      (await container.read(provider.future))!.items.single.title,
      startsWith('دوبلكس'),
    );
    expect(current().ids, {'one'});
    expect(repository.idReads.length, 1);
    expect(repository.pageReads.length, 2);
  });

  test('signing back into the same UID gets a new membership read', () async {
    auth.user = firstUser;
    final stale = Completer<Set<String>>();
    repository.loadIds = (_) => stale.future;
    await settleSession();
    expect(repository.idReads, hasLength(1));

    auth.change(null);
    await settleSession();
    expect(await load(), isNull);
    repository.loadIds = (_) => {'current'};
    auth.change(firstUser);
    await settleSession();
    expect((await load())!.ids, {'current'});
    expect(repository.idReads.first.$2.isCancelled, isTrue);
    stale.complete({'stale'});
    await container.pump();
    expect(current().ids, {'current'});
  });
}
