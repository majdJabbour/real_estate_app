import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/app_theme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({required this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeColors.of(context);
    final uri = url == null ? null : Uri.tryParse(url!);
    final placeholder = ColoredBox(
      color: colors.placeholderSurface,
      child: Center(
        child: Icon(
          Icons.person_outline_rounded,
          size: 56,
          color: colors.placeholderInk,
        ),
      ),
    );
    return SizedBox.square(
      dimension: 140,
      child: ClipOval(
        child: uri == null || uri.scheme != 'https' || uri.host.isEmpty
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                frameBuilder: (context, child, frame, synchronous) =>
                    frame == null && !synchronous ? placeholder : child,
                errorBuilder: (context, error, stack) => placeholder,
              ),
      ),
    );
  }
}
