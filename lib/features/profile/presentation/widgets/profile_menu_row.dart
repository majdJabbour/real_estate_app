import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/design_tokens.dart';

class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.labelColor,
    this.showChevron = true,
    super.key,
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
