import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/design_system/design_tokens.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../application/authentication_providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final failed = ref.watch(authenticationSessionProvider).hasError;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: AdaptiveContent(
              maxContentWidth: ResponsiveLayout.authMaxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: DesignSpacing.small,
                children: [
                  Text(
                    l10n.splashBrand,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: scheme.secondary,
                    ),
                  ),
                  Text(l10n.splashTagline, textAlign: TextAlign.center),
                  const SizedBox(height: DesignSpacing.small),
                  if (failed) ...[
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        l10n.startupError,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(authenticationRepositoryProvider);
                        ref.invalidate(authenticationSessionProvider);
                      },
                      child: Text(l10n.retry),
                    ),
                  ] else
                    SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.primary,
                        semanticsLabel: l10n.restoringSession,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
