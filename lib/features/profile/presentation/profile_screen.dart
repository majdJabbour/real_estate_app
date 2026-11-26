import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/design_system/app_icon.dart';
import '../../../core/design_system/app_theme.dart';
import '../../../core/design_system/app_theme_preference.dart';
import '../../../core/design_system/design_tokens.dart';
import '../../../core/design_system/design_typography.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/localization/failure_message.dart';
import '../../../l10n/app_localizations.dart';
import '../../authentication/application/authentication_providers.dart';
import '../../authentication/presentation/account_sign_in.dart';
import '../../authentication/presentation/auth_feedback.dart';
import '../../favorites/presentation/favorites_screen.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_menu_divider.dart';
import 'widgets/profile_menu_row.dart';
import 'widgets/profile_preference_dialogs.dart';
import 'widgets/profile_status.dart';
import 'widgets/unavailable_profile_row.dart';

// The 52 dp touch rows center the 28 dp artwork. Keep 24 dp from
// a divider's center to the visible artwork on either side.
const _menuDividerInset = 11.5;

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final user = ref.watch(authenticationSessionProvider).asData?.value;
    final enabled = ref.watch(authenticationInitializerProvider) != null;
    final action = ref.watch(authenticationActionProvider);
    final profile = user == null ? null : ref.watch(verifiedProfileProvider);
    final profileUser = profile?.asData?.value;
    final verified = profileUser?.id == user?.id ? profileUser : null;
    final error = profile?.error;
    final email = _present(verified?.email) ?? _present(user?.email);
    final name = _present(verified?.name) ?? _present(user?.name);
    final avatar = _present(verified?.avatar) ?? _present(user?.avatar);
    final language = ref.watch(appLocaleProvider);
    final unavailable = l10n.profileFeatureUnavailable;
    final variant = ref.watch(appThemePreferenceProvider);

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: AdaptiveContent(
          maxContentWidth: ResponsiveLayout.detailsMaxWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: DesignSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 44),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.profileTab,
                        style: DesignTypography.section.copyWith(
                          height: 1.3,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: DesignSpacing.medium),
                Center(child: ProfileAvatar(url: avatar)),
                const SizedBox(height: DesignSpacing.searchInset),
                Text(
                  user == null
                      ? l10n.guest
                      : name ?? l10n.accountNameUnavailable,
                  style: DesignTypography.headline.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (email != null)
                  Text(
                    email,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                if (profile?.isLoading == true)
                  ProfileStatus(l10n.verifyingProfile),
                if (error != null) ...[
                  ProfileStatus(
                    error is AppFailure
                        ? error.kind == FailureKind.unauthorized
                              ? l10n.profileUnauthorized
                              : failureMessage(l10n, error)
                        : l10n.unexpectedError,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => ref.invalidate(verifiedProfileProvider),
                      child: Text(l10n.retry),
                    ),
                  ),
                ],
                if (user == null && enabled)
                  Center(
                    child: TextButton(
                      onPressed: action.isLoading
                          ? null
                          : () => showAccountSignIn(context, ref),
                      child: Text(l10n.googleSignIn),
                    ),
                  ),
                const SizedBox(height: DesignSpacing.large),
                const ProfileMenuDivider(),
                const SizedBox(height: _menuDividerInset),
                for (final (icon, label) in [
                  (AppIcons.profileBooking, l10n.profileBooking),
                  (AppIcons.profilePayments, l10n.profilePayments),
                ])
                  UnavailableProfileRow(
                    icon: icon,
                    label: label,
                    message: unavailable,
                  ),
                const SizedBox(height: _menuDividerInset),
                const ProfileMenuDivider(),
                const SizedBox(height: _menuDividerInset),
                for (final (icon, label) in [
                  (AppIcons.profileAccount, l10n.profileAccount),
                  (AppIcons.profileNotifications, l10n.profileNotifications),
                  (AppIcons.profileSecurity, l10n.profileSecurity),
                ])
                  UnavailableProfileRow(
                    icon: icon,
                    label: label,
                    message: unavailable,
                  ),
                ProfileMenuRow(
                  icon: const AppIcon(AppIcons.profileLanguage, size: 28),
                  label: l10n.profileLanguage,
                  onTap: () => _selectLanguage(context, ref, language),
                ),
                UnavailableProfileRow(
                  icon: AppIcons.profileHelp,
                  label: l10n.profileHelp,
                  message: unavailable,
                ),
                UnavailableProfileRow(
                  icon: AppIcons.profileInvite,
                  label: l10n.profileInvite,
                  message: unavailable,
                ),
                if (user != null) ...[
                  ProfileMenuRow(
                    icon: const AppIcon(
                      AppIcons.profileLogout,
                      size: 28,
                      color: DesignColors.logoutReference,
                    ),
                    label: action.isLoading
                        ? l10n.signingOut
                        : l10n.profileLogout,
                    labelColor: DesignColors.logoutReference,
                    showChevron: false,
                    onTap: action.isLoading
                        ? null
                        : () => _confirmSignOut(context, ref),
                  ),
                  if (action.error case final error?)
                    ProfileStatus(authenticationErrorMessage(l10n, error)),
                ],
                const SizedBox(height: _menuDividerInset),
                const ProfileMenuDivider(),
                const SizedBox(height: _menuDividerInset),
                ProfileMenuRow(
                  icon: const AppIcon(AppIcons.heartOutline, size: 28),
                  label: l10n.myFavorites,
                  onTap: () => context.push(FavoritesScreen.path),
                ),
                ProfileMenuRow(
                  icon: const Icon(Icons.palette_outlined, size: 28),
                  label: l10n.appearance,
                  subtitle: profileThemeName(l10n, variant),
                  onTap: () => _selectTheme(context, ref, variant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    WidgetRef ref,
    AppLanguage current,
  ) async {
    final choice = await showProfileLanguageDialog(context, current);
    if (choice == null || !context.mounted) return;
    try {
      await ref.read(appLocaleProvider.notifier).select(choice);
    } catch (_) {
      if (!context.mounted) return;
      _showError(context, AppLocalizations.of(context).languageSaveError);
    }
  }

  Future<void> _selectTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemeVariant current,
  ) async {
    final choice = await showProfileThemeDialog(context, current);
    if (choice == null || !context.mounted) return;
    try {
      await ref.read(appThemePreferenceProvider.notifier).select(choice);
    } catch (_) {
      if (!context.mounted) return;
      _showError(context, AppLocalizations.of(context).themeSaveError);
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final account = ref.read(authenticationSessionProvider).asData?.value?.id;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmSignOut),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted || account == null) return;
    if (ref.read(authenticationSessionProvider).asData?.value?.id == account) {
      await ref.read(authenticationActionProvider.notifier).signOut();
    }
  }
}

String? _present(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();

void _showError(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
