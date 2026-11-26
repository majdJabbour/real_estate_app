import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';

abstract final class AppBranding {
  static String splashMark(AppThemeVariant variant) => switch (variant) {
    AppThemeVariant.blue => 'assets/brand/logo_blue.svg',
    AppThemeVariant.purple => 'assets/brand/logo_purple.svg',
    AppThemeVariant.orange => 'assets/brand/logo_orange.svg',
  };
}

class SplashBrandMark extends StatelessWidget {
  const SplashBrandMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppBranding.splashMark(AppThemeColors.of(context).variant),
      width: 134,
      height: 113,
      excludeFromSemantics: true,
    );
  }
}
