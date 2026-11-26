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

const _googleButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(30)),
);

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
    final heading = l10n.authHeading(l10n.authHeadingEmphasis);
    final emphasisStart = heading.indexOf(l10n.authHeadingEmphasis);
    final emphasisEnd = emphasisStart + l10n.authHeadingEmphasis.length;
    return Scaffold(
      backgroundColor: DesignColors.authBackground,
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
                    DecoratedBox(
                      decoration: const ShapeDecoration(
                        shape: _googleButtonShape,
                        shadows: [
                          BoxShadow(
                            color: Color(0x33000000),
                            offset: Offset(0, 4),
                            blurRadius: 120,
                          ),
                        ],
                      ),
                      child: OutlinedButton(
                        onPressed: action.isLoading
                            ? null
                            : ref
                                  .read(authenticationActionProvider.notifier)
                                  .signIn,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 59),
                          backgroundColor: DesignColors.surface,
                          disabledBackgroundColor: DesignColors.surface,
                          foregroundColor: DesignColors.text,
                          disabledForegroundColor: DesignColors.text,
                          side: BorderSide.none,
                          shape: _googleButtonShape,
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSpacing.medium,
                            vertical: 18,
                          ),
                          textStyle: const TextStyle(
                            fontFamily: DesignTypography.fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            height: 1.3,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            if (action.isLoading)
                              const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              const AppIcon(AppIcons.google, size: 22),
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
  Widget build(BuildContext context) {
    const aspectRatio = 798 / 1104;
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: SizedBox(
          width: math.min(
            math.max(0.0, constraints.maxWidth - 16),
            maxHeight * aspectRatio,
          ),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: ExcludeSemantics(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/auth/login_image.png',
                    fit: BoxFit.contain,
                  ),
                  FractionallySizedBox(
                    // Figma centers the 376 dp fade on the 399 dp image.
                    widthFactor: 376 / 399,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Project the paint stops through Figma's transform
                          // into the rectangle's top-to-bottom coordinates.
                          stops: [
                            .5653724670410156 / 1.0550363063812256,
                            .9277468323707581 / 1.0550363063812256,
                          ],
                          colors: [
                            Color.from(
                              alpha: .1,
                              red: 251 / 255,
                              green: 251 / 255,
                              blue: 251 / 255,
                            ),
                            DesignColors.authBackground,
                          ],
                        ),
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
}
