import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/design_tokens.dart';

class ProfileStatus extends StatelessWidget {
  const ProfileStatus(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) => message == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(top: DesignSpacing.small),
          child: Semantics(
            liveRegion: true,
            child: Text(message!, textAlign: TextAlign.center),
          ),
        );
}
