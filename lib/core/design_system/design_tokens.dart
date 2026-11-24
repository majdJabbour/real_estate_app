import 'package:material_ui/material_ui.dart';

abstract final class DesignColors {
  static const surface = Color(0xFFFFFFFF);
  static const searchSurface = Color(0xFFFBFBFD);
  static const text = Color(0xFF191D31);
  static const secondaryText = Color(0xFF666876);
  static const tertiaryText = Color(0xFF8C8E98);
  static const logoutReference = Color(0xFFF75555);
  static const scrim = Color.fromRGBO(0, 0, 0, 0.30);
  static const ratingInk = Color(0xFF246BFD);
  static const ratingSurface = Color.fromRGBO(255, 255, 255, 0.90);
  static const ratingStar = LinearGradient(
    colors: [Color(0xFFFB9400), Color(0xFFFFAB38)],
  );

  static const subtleTintOpacity = 0.04;
  static const strongTintOpacity = 0.10;

  // Semantic colors introduced for interactive and feedback states.
  static const error = Color(0xFFB32636);
  static const errorSurface = Color(0xFFFCEBED);
  static const success = Color(0xFF17643A);
  static const successSurface = Color(0xFFE7F4EA);
  static const disabledSurface = Color(0xFFE8E9ED);
  static const favoriteSelected = Color(0xFFA52650);
  static const favoriteOutline = secondaryText;
  static const placeholderSurface = Color(0xFFF1F2F5);
  static const placeholderInk = secondaryText;
}

abstract final class DesignSpacing {
  static const xSmall = 4.0;
  static const small = 8.0;
  static const chipGap = 12.0;
  static const searchInset = 14.0;
  static const medium = 16.0;
  static const page = 20.0;
  static const large = 24.0;
  static const chipWrapGap = 10.0;
}

abstract final class DesignShape {
  static const searchRadius = 6.0;
  static const photoRadius = 10.0;
  static const sheetRadius = 24.0;
  static const listCardRadius = 28.0;
  static const chipRadius = 30.0;
  static const footerRadius = 36.0;
  static const pillRadius = 100.0;
  static const border = 1.0;
  static const focusBorder = 2.0;
}

abstract final class DesignSize {
  static const tapTarget = 48.0;
  static const primaryButton = 54.0;
  static const search = 52.0;
  static const iconButton = 44.0;
  static const actionIcon = 22.0;
  static const searchIcon = 20.0;
  static const searchIconSlot = 49.0;
  static const loadingIcon = 16.0;
}

abstract final class DesignShadows {
  static const primaryButton = BoxShadow(
    color: Color.fromRGBO(112, 79, 56, 0.25),
    offset: Offset(4, 8),
    blurRadius: 24,
  );
  static const card = BoxShadow(
    color: Color.fromRGBO(4, 6, 15, 0.05),
    offset: Offset(0, 4),
    blurRadius: 60,
  );
  static const rating = BoxShadow(
    color: Color.fromRGBO(4, 6, 15, 0.12),
    offset: Offset(0, 20),
    blurRadius: 100,
  );
  static const googleButton = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.20),
    offset: Offset(0, 4),
    blurRadius: 120,
  );
}
