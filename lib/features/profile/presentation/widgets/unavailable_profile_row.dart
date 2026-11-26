import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_icon.dart';
import 'profile_menu_row.dart';

class UnavailableProfileRow extends StatelessWidget {
  const UnavailableProfileRow({
    required this.icon,
    required this.label,
    required this.message,
    super.key,
  });

  final AppIcons icon;
  final String label;
  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    hint: message,
    child: ProfileMenuRow(
      icon: AppIcon(icon, size: 28),
      label: label,
      onTap: () {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
    ),
  );
}
