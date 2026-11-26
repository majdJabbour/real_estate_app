import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/design_system/app_icon.dart';
import '../../core/layout/responsive_layout.dart';
import '../../l10n/app_localizations.dart';
import 'app_navigation_tab.dart';

class AppTabShell extends StatelessWidget {
  const AppTabShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tabs = [
      (l10n.homeTab, AppIcons.homeOutline, AppIcons.homeSelected),
      (l10n.exploreTab, AppIcons.exploreOutline, AppIcons.exploreSelected),
      (l10n.profileTab, AppIcons.profileOutline, AppIcons.profileSelected),
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
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 86,
                  maxWidth: ResponsiveLayout.collectionMaxWidth,
                ),
                child: Row(
                  children: [
                    for (final (index, (label, outline, filled))
                        in tabs.indexed)
                      Expanded(
                        child: AppNavigationTab(
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
      ),
    );
  }
}
