import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/app/app.dart';
import 'package:real_estate_app/app/navigation/app_router.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';
import 'package:real_estate_app/core/localization/app_locale.dart';
import 'package:real_estate_app/core/models/request_cancellation.dart';
import 'package:real_estate_app/features/authentication/application/authentication_providers.dart';
import 'package:real_estate_app/features/authentication/domain/authentication_repository.dart';
import 'package:real_estate_app/features/authentication/presentation/auth_screen.dart';
import 'package:real_estate_app/features/authentication/presentation/splash_screen.dart';
import 'package:real_estate_app/features/favorites/application/favorites_providers.dart';
import 'package:real_estate_app/features/properties/application/property_providers.dart';
import 'package:real_estate_app/features/properties/presentation/home/home_screen.dart';
import 'package:real_estate_app/l10n/app_localizations.dart';

import '../../support/memory_locale_preferences.dart';
import '../favorites/fake_favorites.dart';
import '../properties/home_fakes.dart';
import 'fake_authentication.dart';

final class _VerifiedProfile implements ProfileRepository {
  @override
  Future<AuthenticatedUser> load(RequestCancellation cancellation) async =>
      const AuthenticatedUser(
        id: 'first',
        email: 'fixture@example.test',
        name: 'Verified fixture',
      );
}

Future<ProviderContainer> _pumpApp(
  WidgetTester tester,
  Future<AuthenticationRepository> Function() initialize, {
  String language = 'en',
  AppThemeVariant variant = AppThemeVariant.blue,
  Size size = const Size(430, 932),
  double textScale = 1,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() async {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    await tester.binding.setSurfaceSize(null);
  });
  final container = ProviderContainer.test(
    overrides: [
      localePreferencesProvider.overrideWithValue(
        MemoryLocalePreferences(language),
      ),
      authenticationInitializerProvider.overrideWithValue(initialize),
      profileRepositoryProvider.overrideWithValue(_VerifiedProfile()),
      favoritesRepositoryProvider.overrideWithValue(FakeFavorites()),
      propertyRepositoryProvider.overrideWithValue(
        FakeHomeRepository(
          loadListings: (query, cancellation) => homePage([]),
          loadOptions: () => homeTestOptions(),
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RealEstateApp(variant: variant),
    ),
  );
  return container;
}

void main() {
  testWidgets('Splash routes to Auth, then guest Home, with a stable router', (
    tester,
  ) async {
    final user = FakeAuthentication();
    addTearDown(user.close);
    final pending = Completer<AuthenticationRepository>();
    final container = await _pumpApp(tester, () => pending.future);
    expect(find.byType(SplashScreen), findsOneWidget);
    pending.complete(user);
    await tester.pumpAndSettle();
    final router = container.read(appRouterProvider);
    expect(find.byType(AuthScreen), findsOneWidget);
    final guest = find.text('Continue as Guest');
    await tester.ensureVisible(guest);
    await tester.tap(guest);
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Guest'), findsOneWidget);
    await container.read(appLocaleProvider.notifier).select(AppLanguage.arabic);
    await tester.pumpAndSettle();
    expect(container.read(appRouterProvider), same(router));
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Splash reports a bootstrap failure and recovers on retry', (
    tester,
  ) async {
    final user = FakeAuthentication(user: firstUser);
    addTearDown(user.close);
    var calls = 0;
    await _pumpApp(tester, () async {
      if (calls++ == 0) throw StateError('test startup failure');
      return user;
    });
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(calls, 2);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('First account'), findsOneWidget);
  });

  testWidgets('shows sign-in progress, localized error and successful retry', (
    tester,
  ) async {
    final user = FakeAuthentication();
    final attempt = Completer<void>();
    user.beforeSignIn = () => attempt.future;
    addTearDown(user.close);
    final container = await _pumpApp(tester, () async => user);
    await tester.pumpAndSettle();
    final button = find.text('Sign in with Google');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
    expect(find.text('Signing in…'), findsOneWidget);
    attempt.completeError(AuthenticationFailure.connection);
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(AuthScreen)));
    expect(find.text(l10n.networkError), findsOneWidget);
    user.beforeSignIn = null;
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.text('First account'), findsOneWidget);
    await container.read(authenticationActionProvider.notifier).signOut();
    await tester.pumpAndSettle();
    expect(find.text('Guest'), findsOneWidget);
  });

  testWidgets('a public property deep link survives session restoration', (
    tester,
  ) async {
    final user = FakeAuthentication();
    addTearDown(user.close);
    final pending = Completer<AuthenticationRepository>();
    final container = await _pumpApp(tester, () => pending.future);
    final router = container.read(appRouterProvider);
    router.go('/properties/rental-001');
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
    pending.complete(user);
    await tester.pumpAndSettle();
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      '/properties/rental-001',
    );
    final heart = find.byTooltip('Sign in to save properties');
    await tester.ensureVisible(heart);
    await tester.tap(heart);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in with Google'));
    await tester.pumpAndSettle();
    expect(find.byType(AuthScreen), findsOneWidget);
    final button = find.text('Sign in with Google');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(
      router.routerDelegate.currentConfiguration.uri.path,
      '/properties/rental-001',
    );
    expect(heart, findsNothing);
  });

  testWidgets('Profile shows verified identity and can sign out to guest', (
    tester,
  ) async {
    final user = FakeAuthentication(user: firstUser);
    addTearDown(user.close);
    final container = await _pumpApp(tester, () async => user);
    await tester.pumpAndSettle();
    final router = container.read(appRouterProvider);
    router.go('/profile');
    await tester.pumpAndSettle();
    expect(find.text('Verified fixture'), findsOneWidget);
    expect(find.text('fixture@example.test'), findsOneWidget);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Verified fixture'), findsNothing);
    expect(router.routerDelegate.currentConfiguration.uri.path, '/profile');
  });

  for (final width in [375.0, 390.0]) {
    testWidgets('English Auth fits a ${width.toInt()} dp phone', (
      tester,
    ) async {
      final user = FakeAuthentication();
      addTearDown(user.close);
      await _pumpApp(tester, () async => user, size: Size(width, 820));
      await tester.pumpAndSettle();
      final guest = find.text('Continue as Guest');
      await tester.ensureVisible(guest);
      expect(guest.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final (index, variant) in AppThemeVariant.values.indexed) {
    testWidgets('Arabic Auth fits enlarged text in ${variant.name}', (
      tester,
    ) async {
      final user = FakeAuthentication();
      addTearDown(user.close);
      await _pumpApp(
        tester,
        () async => user,
        variant: variant,
        language: 'ar',
        size: [
          const Size(320, 640),
          const Size(780, 360),
          const Size(820, 1024),
        ][index],
        textScale: 2,
      );
      await tester.pumpAndSettle();
      final auth = tester.element(find.byType(AuthScreen));
      final guest = find.text(AppLocalizations.of(auth).continueAsGuest);
      expect(Directionality.of(auth), TextDirection.rtl);
      await tester.ensureVisible(guest);
      expect(guest.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
