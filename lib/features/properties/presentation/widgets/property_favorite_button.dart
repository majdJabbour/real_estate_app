import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../authentication/application/authentication_providers.dart';
import '../../../authentication/presentation/auth_routes.dart';

class PropertyFavoriteButton extends ConsumerWidget {
  const PropertyFavoriteButton({
    required this.selected,
    required this.onPressed,
    this.onPhoto = false,
    this.iconSize,
    super.key,
  });

  final bool selected;
  final VoidCallback? onPressed;
  final bool onPhoto;
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppThemeColors.of(context);
    final foreground = selected
        ? colors.favoriteSelected
        : onPhoto
        ? Colors.white
        : colors.favoriteOutline;
    final size = iconSize ?? (onPhoto ? 22.0 : 20.0);
    final requiresSignIn =
        onPressed == null &&
        ref.watch(authenticationInitializerProvider) != null &&
        ref.watch(authenticationSessionProvider).asData?.value == null;
    final label = requiresSignIn
        ? l10n.signInToSave
        : onPressed == null
        ? l10n.favoriteUnavailable
        : selected
        ? l10n.removeFavorite
        : l10n.addFavorite;
    return Listener(
      behavior: HitTestBehavior.opaque,
      child: IconButton(
        tooltip: label,
        onPressed: requiresSignIn
            ? () => context.go(signInLocation(GoRouterState.of(context).uri))
            : onPressed,
        isSelected: selected,
        icon: AppIcon(AppIcons.heartOutline, size: size),
        selectedIcon: const Icon(Icons.favorite_rounded),
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
}
