import 'package:material_ui/material_ui.dart';

abstract final class DesignTypography {
  static const fontFamily = 'Rubik';

  static const reference = TextStyle(
    fontSize: 36,
    height: 40 / 36,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static const hero = TextStyle(
    fontSize: 32,
    height: 1.3,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static const headline = TextStyle(
    fontSize: 24,
    height: 1.2,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );
  static const section = TextStyle(
    fontSize: 20,
    height: 1.2,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontSize: 16,
    height: 1.7,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  static const secondary = TextStyle(
    fontSize: 14,
    height: 1.4,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  static const searchHint = TextStyle(
    fontSize: 14,
    height: 1.3,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  static const searchQuery = TextStyle(
    fontSize: 14,
    height: 1.3,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static const chip = TextStyle(fontSize: 14, height: 1.8, letterSpacing: 0);
  static const button = TextStyle(
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
  );
  static const navigationLabel = TextStyle(
    fontSize: 12,
    height: 1.3,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );
  static const filterCounter = TextStyle(
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );

  static const textTheme = TextTheme(
    displaySmall: reference,
    headlineLarge: hero,
    headlineMedium: headline,
    titleLarge: section,
    bodyLarge: body,
    bodyMedium: secondary,
    bodySmall: searchHint,
    labelLarge: button,
    labelMedium: chip,
    labelSmall: navigationLabel,
  );
}
