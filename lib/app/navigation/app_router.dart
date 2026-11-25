import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/application/authentication_providers.dart';
import '../../features/authentication/presentation/auth_routes.dart';
import '../../features/authentication/presentation/auth_screen.dart';
import '../../features/authentication/presentation/splash_screen.dart';
import '../../features/favorites/presentation/favorites_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/properties/presentation/details/property_details_screen.dart';
import '../../features/properties/presentation/explore/explore_screen.dart';
import '../../features/properties/presentation/home/home_screen.dart';
import '../../l10n/app_localizations.dart';
import 'app_tab_shell.dart';
import 'explore_intent.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final rootNavigator = GlobalKey<NavigatorState>();
  final authenticationEnabled =
      ref.read(authenticationInitializerProvider) != null;
  final refresh = ValueNotifier(0);
  if (authenticationEnabled) {
    ref.listen(authenticationSessionProvider, (_, _) => refresh.value++);
  }
  final router = GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: authenticationEnabled ? splashPath : '/home',
    refreshListenable: refresh,
    redirect: (context, state) {
      if (!authenticationEnabled) return null;
      final uri = state.uri;
      final session = ref.read(authenticationSessionProvider);
      final returnTo = publicDestination(uri.queryParameters['returnTo']);

      if (session.isLoading || session.hasError) {
        if (uri.path == splashPath) return null;
        final destination = uri.path == signInPath
            ? returnTo
            : publicDestination(uri.toString());
        return Uri(
          path: splashPath,
          queryParameters: destination == null
              ? null
              : {'returnTo': destination},
        ).toString();
      }

      if (uri.path == splashPath || uri.path == '/') {
        return returnTo ??
            (session.asData?.value == null ? signInPath : '/home');
      }
      if (uri.path == signInPath && session.asData?.value != null) {
        return returnTo ?? '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/home'),
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: signInPath,
        builder: (context, state) => AuthScreen(
          guestDestination:
              publicDestination(state.uri.queryParameters['returnTo']) ??
              '/home',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppTabShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                name: 'explore',
                builder: (context, state) =>
                    ExploreScreen(intent: ExploreIntent.fromUri(state.uri)),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigator,
        path: FavoritesScreen.path,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigator,
        path: '/properties/:propertyId',
        name: 'propertyDetails',
        builder: (context, state) => PropertyDetailsScreen(
          propertyId: state.pathParameters['propertyId']!,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: SafeArea(
        child: Center(
          child: TextButton(
            onPressed: () => context.go('/home'),
            child: Text(AppLocalizations.of(context).backToHome),
          ),
        ),
      ),
    ),
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
}
