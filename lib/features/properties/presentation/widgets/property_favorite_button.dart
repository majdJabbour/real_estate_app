import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/app_theme.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../l10n/app_localizations.dart';

class PropertyFavoriteButton extends StatelessWidget {
  const PropertyFavoriteButton({
    required this.selected,
    required this.onPressed,
    this.onPhoto = false,
    super.key,
  });

  final bool selected;
  final VoidCallback? onPressed;
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppThemeColors.of(context);
    final foreground = selected
        ? colors.favoriteSelected
        : onPhoto
        ? Colors.white
        : colors.favoriteOutline;
    final label = onPressed == null
        ? l10n.favoriteUnavailable
        : selected
        ? l10n.removeFavorite
        : l10n.addFavorite;
    return Listener(
      behavior: HitTestBehavior.opaque,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        isSelected: selected,
        icon: AppIcon(AppIcons.heartOutline, size: onPhoto ? 22 : 20),
        selectedIcon: const Icon(Icons.favorite_rounded),
        style: IconButton.styleFrom(
          iconSize: onPhoto ? 22 : 20,
          foregroundColor: foreground,
          disabledForegroundColor: foreground,
          minimumSize: const Size.square(DesignSize.tapTarget),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
