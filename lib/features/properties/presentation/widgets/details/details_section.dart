import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';

class DetailsSection extends StatelessWidget {
  const DetailsSection({
    required this.title,
    required this.child,
    this.gap = DesignSpacing.page,
    super.key,
  });

  final String title;
  final Widget child;
  final double gap;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: gap,
    children: [
      Semantics(
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      child,
    ],
  );
}
