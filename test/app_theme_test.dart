import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:real_estate_app/core/design_system/app_theme.dart';

double _contrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return a >= b ? (a + 0.05) / (b + 0.05) : (b + 0.05) / (a + 0.05);
}

void main() {
  const brands = {
    AppThemeVariant.blue: (Color(0xFF0061FF), 0.04),
    AppThemeVariant.purple: (Color(0xFF8B5DFF), 0.10),
    AppThemeVariant.orange: (Color(0xFFFF8000), 0.10),
  };

  test('default factory builds the light Blue theme in Rubik', () {
    final theme = AppTheme.light();
    expect(theme.colorScheme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, const Color(0xFF0061FF));
    expect(theme.textTheme.bodyLarge!.fontFamily, 'Rubik');
    expect(theme.textTheme.bodyLarge!.fontWeight, FontWeight.w400);
    expect(theme.textTheme.labelLarge!.fontWeight, FontWeight.w600);
  });

  for (final MapEntry(key: variant, value: (brand, detailsOpacity))
      in brands.entries) {
    test(
      '${variant.name} exposes the original brand and Details-specific tint',
      () {
        final theme = AppTheme.light(variant);
        final scheme = theme.colorScheme;
        expect(scheme.primary, brand);
        expect(scheme.secondary, brand);
        final detailsTint = theme.extension<AppThemeColors>()!.detailsTint;
        expect(detailsTint.withValues(alpha: 1), brand);
        expect(detailsTint.a, closeTo(detailsOpacity, 0.001));
        expect(
          scheme.primaryContainer,
          Color.alphaBlend(
            brand.withValues(alpha: 0.10),
            const Color(0xFFFFFFFF),
          ),
        );

        final chip = theme.chipTheme;
        expect(chip.color!.resolve({WidgetState.selected}), brand);
        expect(
          chip.color!.resolve({}),
          Color.alphaBlend(
            brand.withValues(alpha: 0.04),
            const Color(0xFFFFFFFF),
          ),
        );
      },
    );

    test(
      '${variant.name} preserves white primary foreground and control contrast roles',
      () {
        final theme = AppTheme.light(variant);
        final scheme = theme.colorScheme;
        final button = theme.filledButtonTheme.style!;
        final chip = theme.chipTheme;
        final input = theme.inputDecorationTheme;
        final colors = theme.extension<AppThemeColors>()!;
        const disabled = {WidgetState.disabled};
        const focused = {WidgetState.focused};

        expect(
          _contrast(theme.textTheme.bodyLarge!.color!, scheme.surface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrast(theme.textTheme.bodyMedium!.color!, scheme.surface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrast(input.hintStyle!.color!, input.fillColor!),
          greaterThanOrEqualTo(4.5),
        );
        final linkInk = theme.textButtonTheme.style!.foregroundColor!.resolve(
          {},
        )!;
        expect(linkInk, brand);
        expect(
          _contrast(
            button.foregroundColor!.resolve(disabled)!,
            button.backgroundColor!.resolve(disabled)!,
          ),
          greaterThanOrEqualTo(4.5),
        );

        expect(scheme.onPrimary, Colors.white);
        expect(chip.showCheckmark, isFalse);
        final restingContrast = _contrast(Colors.white, brand);
        if (variant == AppThemeVariant.blue) {
          expect(restingContrast, greaterThanOrEqualTo(4.5));
        } else {
          expect(restingContrast, lessThan(4.5));
        }

        for (final state in [
          <WidgetState>{},
          focused,
          {WidgetState.hovered},
          {WidgetState.pressed},
        ]) {
          final buttonFill = button.backgroundColor!.resolve(state)!;
          final overlay = button.overlayColor!.resolve(state);
          final actualFill = overlay == null
              ? buttonFill
              : Color.alphaBlend(overlay, buttonFill);
          expect(buttonFill, brand);
          expect(button.foregroundColor!.resolve(state), Colors.white);
          expect(
            _contrast(Colors.white, actualFill),
            greaterThanOrEqualTo(restingContrast),
          );
          expect(
            _contrast(scheme.onSurface, chip.color!.resolve(state)!),
            greaterThanOrEqualTo(4.5),
          );
        }

        final rest = input.enabledBorder! as OutlineInputBorder;
        expect(
          rest.borderSide,
          BorderSide(color: brand.withValues(alpha: 0.04)),
        );
        expect(rest.borderRadius, BorderRadius.circular(6));
        expect(input.fillColor, const Color(0xFFFBFBFD));
        expect(input.focusedBorder!.borderSide.width, 2);
        final focusColor = input.focusedBorder!.borderSide.color;
        expect(
          focusColor,
          variant == AppThemeVariant.orange ? scheme.onSurface : brand,
        );
        expect(
          _contrast(focusColor, input.fillColor!),
          greaterThanOrEqualTo(3),
        );
        expect(
          _contrast(button.side!.resolve(focused)!.color, scheme.primary),
          greaterThanOrEqualTo(3),
        );
        expect(
          _contrast(scheme.onPrimaryContainer, scheme.primaryContainer),
          greaterThanOrEqualTo(3),
        );
        expect(
          _contrast(colors.favoriteSelected, scheme.primaryContainer),
          greaterThanOrEqualTo(3),
        );
        expect(
          _contrast(colors.favoriteOutline, scheme.primaryContainer),
          greaterThanOrEqualTo(3),
        );
      },
    );
  }

  test('feedback and placeholder colors stay shared and legible', () {
    for (final variant in AppThemeVariant.values) {
      final theme = AppTheme.light(variant);
      final scheme = theme.colorScheme;
      final colors = theme.extension<AppThemeColors>()!;
      expect(scheme.error, const Color(0xFFB32636));
      expect(scheme.errorContainer, const Color(0xFFFCEBED));
      expect(colors.success, const Color(0xFF17643A));
      expect(colors.successSurface, const Color(0xFFE7F4EA));
      expect(colors.favoriteSelected, const Color(0xFFA52650));
      expect(colors.favoriteOutline, const Color(0xFF666876));
      expect(colors.placeholderSurface, const Color(0xFFF1F2F5));
      expect(colors.placeholderInk, const Color(0xFF666876));
      expect(
        _contrast(scheme.onErrorContainer, scheme.errorContainer),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(colors.success, colors.successSurface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(colors.placeholderInk, colors.placeholderSurface),
        greaterThanOrEqualTo(4.5),
      );
    }
  });

  test(
    'theme extension copies and interpolates changed roles independently',
    () {
      final blue = AppTheme.light().extension<AppThemeColors>()!;
      final purple = AppTheme.light(AppThemeVariant.purple)
          .extension<AppThemeColors>()!;
      const changedSuccess = Color(0xFF006D50);
      final edited = purple.copyWith(success: changedSuccess);
      expect(edited.detailsTint, purple.detailsTint);
      expect(edited.success, changedSuccess);
      expect(edited.successSurface, purple.successSurface);
      expect(blue.lerp(null, 0.5), same(blue));

      final midpoint = blue.lerp(edited, 0.5);
      expect(
        midpoint.detailsTint,
        Color.lerp(blue.detailsTint, purple.detailsTint, 0.5),
      );
      expect(midpoint.detailsTint.a, closeTo(0.07, 0.001));
      expect(midpoint.success, Color.lerp(blue.success, changedSuccess, 0.5));
      expect(midpoint.favoriteOutline, blue.favoriteOutline);
      expect(midpoint.placeholderSurface, blue.placeholderSurface);
    },
  );
}
