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
                Center(child: _ProfileAvatar(url: avatar)),
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
                  _ProfileStatus(l10n.verifyingProfile),
                if (error != null) ...[
                  _ProfileStatus(
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
                const _ProfileDivider(),
                const SizedBox(height: _menuDividerInset),
                for (final (icon, label) in [
                  (AppIcons.profileBooking, l10n.profileBooking),
                  (AppIcons.profilePayments, l10n.profilePayments),
                ])
                  _UnavailableProfileRow(
                    icon: icon,
                    label: label,
                    message: unavailable,
                  ),
                const SizedBox(height: _menuDividerInset),
                const _ProfileDivider(),
                const SizedBox(height: _menuDividerInset),
                for (final (icon, label) in [
                  (AppIcons.profileAccount, l10n.profileAccount),
                  (AppIcons.profileNotifications, l10n.profileNotifications),
                  (AppIcons.profileSecurity, l10n.profileSecurity),
                ])
                  _UnavailableProfileRow(
                    icon: icon,
                    label: label,
                    message: unavailable,
                  ),
                _ProfileRow(
                  icon: const AppIcon(AppIcons.profileLanguage, size: 28),
                  label: l10n.profileLanguage,
                  onTap: () => _selectLanguage(context, ref, language),
                ),
                _UnavailableProfileRow(
                  icon: AppIcons.profileHelp,
                  label: l10n.profileHelp,
                  message: unavailable,
                ),
                _UnavailableProfileRow(
                  icon: AppIcons.profileInvite,
                  label: l10n.profileInvite,
                  message: unavailable,
                ),
                if (user != null) ...[
                  _ProfileRow(
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
                    _ProfileStatus(authenticationErrorMessage(l10n, error)),
                ],
                const SizedBox(height: _menuDividerInset),
                const _ProfileDivider(),
                const SizedBox(height: _menuDividerInset),
                _ProfileRow(
                  icon: const AppIcon(AppIcons.heartOutline, size: 28),
                  label: l10n.myFavorites,
                  onTap: () => context.push(FavoritesScreen.path),
                ),
                _ProfileRow(
                  icon: const Icon(Icons.palette_outlined, size: 28),
                  label: l10n.appearance,
                  subtitle: _themeName(l10n, variant),
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
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<AppLanguage>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.profileLanguage),
        children: [
          for (final language in AppLanguage.values)
            _PreferenceOption(
              label: _languageName(l10n, language),
              selected: current == language,
              onTap: () => Navigator.pop(context, language),
            ),
        ],
      ),
    );
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
    final l10n = AppLocalizations.of(context);
    final choice = await showDialog<AppThemeVariant>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.appearance),
        children: [
          for (final variant in AppThemeVariant.values)
            _PreferenceOption(
              label: _themeName(l10n, variant),
              selected: current == variant,
              swatch: AppTheme.light(variant).colorScheme.primary,
              onTap: () => Navigator.pop(context, variant),
            ),
        ],
      ),
    );
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final uri = url == null ? null : Uri.tryParse(url!);
    final placeholder = ColoredBox(
      color: colors.placeholderSurface,
      child: Center(
        child: Icon(
          Icons.person_outline_rounded,
          size: 56,
          color: colors.placeholderInk,
        ),
      ),
    );
    return SizedBox.square(
      dimension: 140,
      child: ClipOval(
        child: uri == null || uri.scheme != 'https' || uri.host.isEmpty
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                frameBuilder: (context, child, frame, synchronous) =>
                    frame == null && !synchronous ? placeholder : child,
                errorBuilder: (context, error, stack) => placeholder,
              ),
      ),
    );
  }
}

class _UnavailableProfileRow extends StatelessWidget {
  const _UnavailableProfileRow({
    required this.icon,
    required this.label,
    required this.message,
  });

  final AppIcons icon;
  final String label;
  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    hint: message,
    child: _ProfileRow(
      icon: AppIcon(icon, size: 28),
      label: label,
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
    ),
  );
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.labelColor,
    this.showChevron = true,
  });

  final Widget icon;
  final String label;
  final String? subtitle;
  final Color? labelColor;
  final bool showChevron;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      minTileHeight: 52,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: DesignSpacing.chipGap,
      minLeadingWidth: 28,
      iconColor: foreground,
      leading: icon,
      trailing: showChevron
          ? const AppIcon(AppIcons.profileChevron, size: 20)
          : null,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: labelColor ?? foreground,
        ),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      onTap: onTap,
    );
  }
}

class _ProfileDivider extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) => Divider(
    height: 1,
    thickness: 1,
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}

class _ProfileStatus extends StatelessWidget {
  const _ProfileStatus(this.message);

  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: DesignSpacing.small),
          child: Semantics(
            liveRegion: true,
            child: Text(message!, textAlign: TextAlign.center),
          ),
        );
}

class _PreferenceOption extends StatelessWidget {
  const _PreferenceOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.swatch,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? swatch;

  @override
  Widget build(BuildContext context) => Semantics(
    inMutuallyExclusiveGroup: true,
    child: ListTile(
      selected: selected,
      minTileHeight: DesignSize.tapTarget,
      title: Text(label),
      leading: swatch == null
          ? null
          : SizedBox.square(
              dimension: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: swatch,
                  shape: BoxShape.circle,
                ),
              ),
            ),
      trailing: selected ? const Icon(Icons.check_rounded) : null,
      onTap: onTap,
    ),
  );
}

String? _present(String? value) =>
    value == null || value.trim().isEmpty ? null : value.trim();

String _languageName(AppLocalizations l10n, AppLanguage language) =>
    switch (language) {
      AppLanguage.english => l10n.englishName,
      AppLanguage.arabic => l10n.arabicName,
    };

String _themeName(AppLocalizations l10n, AppThemeVariant variant) =>
    switch (variant) {
      AppThemeVariant.blue => l10n.originalBlue,
      AppThemeVariant.purple => l10n.newPurple,
      AppThemeVariant.orange => l10n.newOrange,
    };

void _showError(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
