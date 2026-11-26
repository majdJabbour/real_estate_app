import 'package:material_ui/material_ui.dart';

class PropertyPhotoButton extends StatelessWidget {
  const PropertyPhotoButton({
    required this.label,
    required this.onTap,
    required this.child,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    explicitChildNodes: true,
    button: true,
    label: label,
    onTap: onTap,
    child: Stack(
      fit: StackFit.expand,
      children: [
        child,
        Material(
          type: MaterialType.transparency,
          child: InkWell(onTap: onTap, excludeFromSemantics: true),
        ),
      ],
    ),
  );
}
