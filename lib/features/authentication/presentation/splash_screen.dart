import 'package:flutter_svg/flutter_svg.dart';
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
                  SvgPicture.asset(
                    'assets/brand/real-scout.svg',
                    width: 122,
                    height: 122,
                    colorMapper: _BrandGradient(scheme.primary),
                    excludeFromSemantics: true,
                  ),
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

final class _BrandGradient extends ColorMapper {
  const _BrandGradient(this.primary);

  final Color primary;

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) => switch (color) {
    const Color(0xFF0061FF) => primary,
    const Color(0xFF0041C4) => Color.lerp(primary, Colors.black, 0.25)!,
    _ => color,
  };

  @override
  bool operator ==(Object other) =>
      other is _BrandGradient && other.primary == primary;

  @override
  int get hashCode => primary.hashCode;
}
