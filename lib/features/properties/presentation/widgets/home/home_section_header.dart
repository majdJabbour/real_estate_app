import 'package:material_ui/material_ui.dart';

import '../../../../../l10n/app_localizations.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleLarge),
          ),
        ),
        Flexible(
          flex: 0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 128),
            child: Semantics(
              label: actionLabel,
              button: true,
              onTap: onAction,
              excludeSemantics: true,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(48, 48),
                ),
                child: Text(
                  AppLocalizations.of(context).seeAll,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
