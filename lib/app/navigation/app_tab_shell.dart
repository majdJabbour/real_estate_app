import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/design_system/design_typography.dart';
import '../../core/layout/responsive_layout.dart';
import '../../l10n/app_localizations.dart';

class AppTabShell extends StatelessWidget {
  const AppTabShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tabs = [
      (l10n.homeTab, Icons.home_outlined, Icons.home_rounded),
      (l10n.exploreTab, Icons.search_outlined, Icons.search_rounded),
      (l10n.profileTab, Icons.person_outline_rounded, Icons.person_rounded),
    ];
    return Scaffold(
      body: shell,
      bottomNavigationBar: Material(
        color: theme.colorScheme.surface,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: SafeArea(
            top: false,
            child: AdaptiveContent(
              child: Row(
                children: [
                  for (final (index, (label, outline, filled)) in tabs.indexed)
                    Expanded(
                      child: _Tab(
                        label: label,
                        icon: shell.currentIndex == index ? filled : outline,
                        selected: shell.currentIndex == index,
                        onTap: () => shell.goBranch(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = selected ? scheme.secondary : scheme.onSurfaceVariant;
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
              Icon(icon, size: 24, color: foreground),
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
