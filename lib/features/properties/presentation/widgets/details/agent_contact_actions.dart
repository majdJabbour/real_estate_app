import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/app_icon.dart';
import '../../../../../l10n/app_localizations.dart';

class AgentContactActions extends StatelessWidget {
  const AgentContactActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (icon, label) in [
          (AppIcons.detailsChat, l10n.detailsMessageAgent),
          (AppIcons.detailsCall, l10n.detailsCallAgent),
        ])
          IconButton(
            tooltip: label,
            icon: AppIcon(icon, size: 28, color: color),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.detailsContactUnavailable)),
              );
            },
          ),
      ],
    );
  }
}
