import 'package:material_ui/material_ui.dart';

import '../../core/design_system/app_icon.dart';
import '../../core/design_system/design_typography.dart';

class AppNavigationTab extends StatelessWidget {
  const AppNavigationTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final AppIcons icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected ? scheme.primary : scheme.onSurfaceVariant;
    return Semantics(
      label: label,
      selected: selected,
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              AppIcon(icon, size: 24, color: foreground),
              Text(
                label,
                style: DesignTypography.navigationLabel.copyWith(
                  color: foreground,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
