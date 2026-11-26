import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/localization/failure_message.dart';
import '../../../../../l10n/app_localizations.dart';

class HomeSectionMessage extends StatelessWidget {
  const HomeSectionMessage(this.message, {this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: DesignSpacing.medium),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(liveRegion: true, child: Text(message)),
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
      ],
    ),
  );
}

Widget homeSectionError(
  BuildContext context,
  Object error,
  VoidCallback onRetry, {
  String? message,
}) {
  final l10n = AppLocalizations.of(context);
  final localized = error is AppFailure
      ? failureMessage(l10n, error)
      : l10n.unexpectedError;
  if (localized == null) return const SizedBox.shrink();
  return HomeSectionMessage(message ?? localized, onRetry: onRetry);
}
