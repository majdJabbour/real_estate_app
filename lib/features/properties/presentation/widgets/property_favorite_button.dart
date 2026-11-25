import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/design_system/design_controls.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../authentication/application/authentication_providers.dart';
import '../../../authentication/presentation/account_sign_in.dart';
import '../../../favorites/application/favorites_providers.dart';

class PropertyFavoriteButton extends ConsumerWidget {
  const PropertyFavoriteButton({
    required this.propertyId,
    this.onPhoto = false,
    this.iconSize,
    super.key,
  }) : _filled = false;

  const PropertyFavoriteButton.filled({required this.propertyId, super.key})
    : onPhoto = false,
      iconSize = null,
      _filled = true;

  final bool _filled;

  final String propertyId;
  final bool onPhoto;
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppThemeColors.of(context);
    final account = ref.watch(
      activeFavoritesSessionProvider.select((session) => session.accountId),
    );
    final canSignIn =
        account == null && ref.watch(authenticationInitializerProvider) != null;
    final (selected, pending, retry) = account == null
        ? (null, false, false)
        : ref.watch(
            favoriteMembershipControllerProvider.select((membership) {
              final current = membership.isLoading
                  ? null
                  : membership.asData?.value;
              final uncertain =
                  current?.uncertain.contains(propertyId) ?? false;
              return (
                uncertain ? null : current?.ids.contains(propertyId),
                current?.pending.contains(propertyId) ?? membership.isLoading,
                uncertain || membership.hasError,
              );
            }),
          );

    final size = iconSize ?? (onPhoto ? 22.0 : 20.0);
    final foreground = selected == true
        ? colors.favoriteSelected
        : onPhoto
        ? Colors.white
        : colors.favoriteOutline;
    final label = switch ((account, pending, retry, selected)) {
      (null, _, _, _) =>
        canSignIn ? l10n.signInToSave : l10n.favoriteUnavailable,
      (_, true, _, null) => l10n.favoriteLoading,
      (_, true, _, _) => l10n.favoriteUpdating,
      (_, _, true, _) => l10n.favoriteRetry,
      (_, _, _, true) => l10n.removeFavorite,
      _ => l10n.addFavorite,
    };
    final VoidCallback? onPressed = pending || (account == null && !canSignIn)
        ? null
        : () => account == null
              ? _requestSignIn(context, ref)
              : _toggle(context, ref);
    if (_filled) {
      return AppPrimaryButton(
        label: label,
        onPressed: onPressed,
        loadingLabel: pending ? label : null,
      );
    }

    final progress = SizedBox.square(
      dimension: selected == null ? DesignSize.loadingIcon : 8,
      child: CircularProgressIndicator(color: foreground, strokeWidth: 2),
    );
    final heart = selected == true
        ? Icon(Icons.favorite_rounded, size: size)
        : AppIcon(AppIcons.heartOutline, size: size);

    final indicator = !pending
        ? heart
        : selected == null
        ? progress
        : Stack(
            clipBehavior: Clip.none,
            children: [
              heart,
              PositionedDirectional(end: -3, bottom: -3, child: progress),
            ],
          );
    return Listener(
      behavior: HitTestBehavior.opaque,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        isSelected: selected,
        icon: onPhoto && selected == true
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: indicator,
                ),
              )
            : indicator,
        style: IconButton.styleFrom(
          iconSize: size,
          foregroundColor: foreground,
          disabledForegroundColor: foreground,
          minimumSize: const Size.square(DesignSize.tapTarget),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Future<void> _requestSignIn(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signInToSave),
        content: Text(l10n.favoriteUnavailable),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.googleSignIn),
          ),
        ],
      ),
    );
    if (approved == true && context.mounted) {
      await showAccountSignIn(context, ref);
    }
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    try {
      if (ref.read(favoriteMembershipControllerProvider).hasError) {
        ref.invalidate(favoriteMembershipControllerProvider);
        return;
      }
      await ref
          .read(favoriteMembershipControllerProvider.notifier)
          .toggle(propertyId);
    } catch (error) {
      if (!context.mounted) return;
      final l10n = AppLocalizations.of(context);
      final message = error is AppFailure
          ? failureMessage(l10n, error)
          : l10n.unexpectedError;
      if (message == null) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
