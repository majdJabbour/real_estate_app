import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/app_icon.dart';

class DetailsBackButton extends StatelessWidget {
  const DetailsBackButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    icon: const AppIcon(AppIcons.detailsBack, size: 28),
    onPressed: () {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    },
  );
}
