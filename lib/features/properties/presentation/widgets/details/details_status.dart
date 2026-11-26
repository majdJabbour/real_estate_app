import 'package:material_ui/material_ui.dart';

import '../../../../../core/design_system/design_tokens.dart';
import '../../../../../core/layout/responsive_layout.dart';
import '../../../../../l10n/app_localizations.dart';
import 'details_back_button.dart';

class DetailsStatus extends StatelessWidget {
  const DetailsStatus({this.message, this.onRetry, super.key});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final failure = message;
    return Scaffold(
      appBar: AppBar(
        leading: const DetailsBackButton(),
        title: Text(l10n.propertyDetailsTitle),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AdaptiveContent(
              maxContentWidth: ResponsiveLayout.detailsMaxWidth,
              child: Column(
                spacing: DesignSpacing.medium,
                children: [
                  if (failure == null)
                    CircularProgressIndicator(semanticsLabel: l10n.loading)
                  else
                    Semantics(
                      liveRegion: true,
                      child: Text(failure, textAlign: TextAlign.center),
                    ),
                  if (onRetry != null)
                    FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
