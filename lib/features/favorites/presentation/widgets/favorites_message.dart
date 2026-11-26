import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/design_tokens.dart';

class FavoritesMessage extends StatelessWidget {
  const FavoritesMessage({required this.text, this.action, super.key});

  final String? text;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(DesignSpacing.large),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: DesignSpacing.medium,
      children: [
        if (text case final message?)
          Semantics(
            liveRegion: true,
            child: Text(message, textAlign: TextAlign.center),
          ),
        ?action,
      ],
    ),
  );
}
