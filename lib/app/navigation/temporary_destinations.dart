import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/errors/app_failure.dart';
import '../../core/layout/responsive_layout.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/failure_message.dart';
import '../../features/authentication/application/authentication_providers.dart';
import '../../features/authentication/presentation/auth_feedback.dart';
import '../../features/authentication/presentation/auth_routes.dart';
import '../../l10n/app_localizations.dart';

class ProfileDestination extends ConsumerWidget {
  const ProfileDestination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(appLocaleProvider);
    final user = ref.watch(authenticationSessionProvider).asData?.value;
    final enabled = ref.watch(authenticationInitializerProvider) != null;
    final action = ref.watch(authenticationActionProvider);
    final profile = user == null ? null : ref.watch(verifiedProfileProvider);
    final error = profile?.error;
    final verified = profile?.asData?.value;

    return SafeArea(
      bottom: false,
      child: Center(
        child: SingleChildScrollView(
          child: AdaptiveContent(
            maxContentWidth: ResponsiveLayout.detailsMaxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Text(
                  l10n.profileTab,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (!enabled)
                  Text(l10n.profilePending, textAlign: TextAlign.center)
                else if (user == null) ...[
                  Text(l10n.guest),
                  TextButton(
                    onPressed: action.isLoading
                        ? null
                        : () {
                            if (action.hasError) {
                              ref.invalidate(authenticationActionProvider);
                            }
                            context.go(signInLocation(Uri(path: '/profile')));
                          },
                    child: Text(l10n.googleSignIn),
                  ),
                ] else ...[
                  if (profile?.isLoading == true)
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l10n.verifyingProfile,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (verified != null) ...[
                    Text(l10n.verifiedProfile, textAlign: TextAlign.center),
                    if (verified.name case final name?)
                      Text(name, textAlign: TextAlign.center),
                    if (verified.email case final email?)
                      Text(email, textDirection: TextDirection.ltr),
                  ] else if (error != null) ...[
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        error is AppFailure &&
                                error.kind == FailureKind.unauthorized
                            ? l10n.profileUnauthorized
                            : (error is AppFailure
                                      ? failureMessage(l10n, error)
                                      : null) ??
                                  l10n.unexpectedError,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(verifiedProfileProvider),
                      child: Text(l10n.retry),
                    ),
                  ],
                  TextButton(
                    onPressed: action.isLoading
                        ? null
                        : ref
                              .read(authenticationActionProvider.notifier)
                              .signOut,
                    child: Text(
                      action.isLoading ? l10n.signingOut : l10n.signOut,
                    ),
                  ),
                ],
                if (enabled && action.hasError)
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      authenticationErrorMessage(l10n, action.error!),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (final (language, label) in [
                      (AppLanguage.english, l10n.englishName),
                      (AppLanguage.arabic, l10n.arabicName),
                    ])
                      TextButton(
                        onPressed: language == selected
                            ? null
                            : () async {
                                try {
                                  await ref
                                      .read(appLocaleProvider.notifier)
                                      .select(language);
                                } catch (_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.languageSaveError),
                                      ),
                                    );
                                  }
                                }
                              },
                        child: Text(label),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
