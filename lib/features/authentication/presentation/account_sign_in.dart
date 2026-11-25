import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../application/authentication_providers.dart';
import 'auth_screen.dart';

Future<void> showAccountSignIn(BuildContext context, WidgetRef ref) async {
  final action = ref.read(authenticationActionProvider);
  if (ref.read(authenticationSessionProvider).asData?.value != null ||
      action.isLoading) {
    return;
  }
  if (action.hasError) ref.invalidate(authenticationActionProvider);
  final navigator = Navigator.of(context, rootNavigator: true);
  await navigator.push<void>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) =>
          AuthScreen(guestDestination: '/home', onDismiss: navigator.pop),
    ),
  );
}
