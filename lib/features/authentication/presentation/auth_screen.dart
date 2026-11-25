import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/design_system/app_icon.dart';
import '../../../core/design_system/design_tokens.dart';
import '../../../core/design_system/design_typography.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../application/authentication_providers.dart';
import 'auth_feedback.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({required this.guestDestination, this.onDismiss, super.key});

  final String guestDestination;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (onDismiss != null) {
      ref.listen(authenticationSessionProvider, (_, next) {
        if (next.asData?.value != null &&
            ModalRoute.of(context)?.isCurrent == true) {
          onDismiss!();
        }
      });
    }
    final l10n = AppLocalizations.of(context);
    final action = ref.watch(authenticationActionProvider);
    final scheme = Theme.of(context).colorScheme;
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final heading = l10n.authHeading(l10n.authHeadingEmphasis);
    final emphasisStart = heading.indexOf(l10n.authHeadingEmphasis);
    final emphasisEnd = emphasisStart + l10n.authHeadingEmphasis.length;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: AdaptiveContent(
              maxContentWidth: ResponsiveLayout.authMaxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DesignSpacing.large,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PropertyCollage(maxHeight: constraints.maxHeight * .59),
                    const SizedBox(height: DesignSpacing.medium),
                    Semantics(
                      header: true,
                      child: Text(
                        l10n.authWelcome,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.8,
                          letterSpacing: l10n.localeName == 'en' ? 1.6 : 0,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: DesignSpacing.medium),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: heading.substring(0, emphasisStart)),
                          TextSpan(
                            text: l10n.authHeadingEmphasis,
                            style: TextStyle(color: scheme.secondary),
                          ),
                          TextSpan(text: heading.substring(emphasisEnd)),
                        ],
                      ),
                      style: DesignTypography.hero.copyWith(
                        color: scheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DesignSpacing.medium),
                    Text(
                      l10n.authDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: DesignSpacing.large),
                    OutlinedButton(
                      onPressed: action.isLoading
                          ? null
                          : ref
                                .read(authenticationActionProvider.notifier)
                                .signIn,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 59),
                        backgroundColor: Colors.white,
                        disabledBackgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1F1F1F),
                        side: const BorderSide(color: Color(0xFF747775)),
                        shape: const StadiumBorder(),
                        padding: EdgeInsets.symmetric(
                          horizontal: isIos ? 16 : 12,
                          vertical: DesignSpacing.small,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          fontFamily: 'Google Sans',
                          fontFamilyFallback: [DesignTypography.fontFamily],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: isIos ? 12 : 10,
                        children: [
                          if (action.isLoading)
                            const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            const AppIcon(AppIcons.google, size: 20),
                          Flexible(
                            child: Text(
                              action.isLoading
                                  ? l10n.signingIn
                                  : l10n.googleSignIn,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (action.hasError)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: DesignSpacing.small,
                        ),
                        child: Semantics(
                          liveRegion: true,
                          child: Text(
                            authenticationErrorMessage(l10n, action.error!),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: scheme.error),
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: action.isLoading
                          ? null
                          : () {
                              ref.invalidate(authenticationActionProvider);
                              if (onDismiss case final dismiss?) {
                                dismiss();
                              } else {
                                context.go(guestDestination);
                              }
                            },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, DesignSize.tapTarget),
                      ),
                      child: Text(
                        onDismiss == null ? l10n.continueAsGuest : l10n.cancel,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PropertyCollage extends StatelessWidget {
  const _PropertyCollage({required this.maxHeight});

  final double maxHeight;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Center(
      child: SizedBox(
        width: math.min(
          math.max(0.0, constraints.maxWidth - 16),
          maxHeight * .8,
        ),
        child: AspectRatio(
          aspectRatio: .8,
          child: ExcludeSemantics(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/auth/property-collage.jpg',
                  fit: BoxFit.cover,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [.565, .965],
                      colors: [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
                    ),
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
