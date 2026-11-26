import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/design_tokens.dart';

class AuthPropertyCollage extends StatelessWidget {
  const AuthPropertyCollage({required this.maxHeight, super.key});

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
