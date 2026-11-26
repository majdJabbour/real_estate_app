import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../shared/property_image.dart';

class DetailsNamedPerson extends StatelessWidget {
  const DetailsNamedPerson({
    required this.name,
    required this.size,
    this.avatarUrl,
    this.trailing,
    super.key,
  });

  final String name;
  final double size;
  final String? avatarUrl;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    spacing: DesignSpacing.small,
    children: [
      ExcludeSemantics(
        child: ClipOval(
          child: SizedBox.square(
            dimension: size,
            child: PropertyImage(
              url: avatarUrl,
              placeholderIcon: Icons.person_outline,
            ),
          ),
        ),
      ),
      if (size == 60) const SizedBox(width: 4),
      Expanded(
        child: Text(
          name,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: size == 60 ? 18 : 16,
            height: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      ?trailing,
    ],
  );
}
