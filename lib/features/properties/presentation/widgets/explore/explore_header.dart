import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/app_icon.dart';
import '../../../../../core/design_system/design_controls.dart';
import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../l10n/app_localizations.dart';

class ExploreHeader extends StatelessWidget {
  const ExploreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      spacing: 8,
      children: [
        AppIconButton(
          label: l10n.backToHome,
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => context.go('/home'),
        ),
        Expanded(
          child: Text(
            l10n.exploreTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.notificationsUnavailable,
          onPressed: null,
          icon: const AppIcon(AppIcons.notification, size: 22),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(DesignSize.tapTarget),
            disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
