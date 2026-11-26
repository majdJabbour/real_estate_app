import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/localization/app_locale.dart';
import '../../../l10n/app_localizations.dart';
import '../../authentication/application/authentication_providers.dart';
import '../../authentication/presentation/account_sign_in.dart';
import '../application/favorites_providers.dart';
import 'widgets/favorites_message.dart';
import 'widgets/favorites_pages.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  static const path = '/favorites';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final session = ref.watch(activeFavoritesSessionProvider);
    final language = ref.watch(appLocaleProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myFavorites),
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
        ),
      ),
      body: SafeArea(
        top: false,
        child: session.accountId == null
            ? FavoritesMessage(
                text: l10n.favoriteUnavailable,
                action: ref.watch(authenticationInitializerProvider) == null
                    ? null
                    : FilledButton(
                        onPressed: () => showAccountSignIn(context, ref),
                        child: Text(l10n.googleSignIn),
                      ),
              )
            : FavoritesPages(key: ValueKey((session, language))),
      ),
    );
  }
}
