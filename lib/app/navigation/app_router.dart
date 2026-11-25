import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/properties/presentation/home/home_screen.dart';
import '../../l10n/app_localizations.dart';
import 'app_tab_shell.dart';
import 'explore_intent.dart';
import 'temporary_destinations.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final rootNavigator = GlobalKey<NavigatorState>();
  final router = GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/home'),
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
                builder: (context, state) => ExploreDestination(
                  intent: ExploreIntent.fromUri(state.uri),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileDestination(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigator,
        path: '/properties/:propertyId',
        name: 'propertyDetails',
        builder: (context, state) => PropertyDetailsDestination(
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
  ref.onDispose(router.dispose);
  return router;
}
