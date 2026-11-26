import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/design_system/app_branding.dart';
import '../../../core/design_system/design_tokens.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../application/authentication_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key, this.onMinimumElapsed});

  final VoidCallback? onMinimumElapsed;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _minimumTimer;

  @override
  void initState() {
    super.initState();
    if (widget.onMinimumElapsed == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _minimumTimer = Timer(
        const Duration(seconds: 2),
        () => widget.onMinimumElapsed?.call(),
      );
    });
  }

  @override
  void dispose() {
    _minimumTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  const SplashBrandMark(),
                  Text(
                    l10n.splashBrand,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
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
