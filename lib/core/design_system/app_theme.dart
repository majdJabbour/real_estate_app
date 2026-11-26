import 'package:material_ui/material_ui.dart';

import 'design_tokens.dart';
import 'design_typography.dart';

enum AppThemeVariant { blue, purple, orange }

@immutable
final class _Palette {
  const _Palette({required this.brand, required this.detailsTintOpacity});

  final Color brand;
  final double detailsTintOpacity;
}

@immutable
final class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.variant,
    required this.detailsTint,
    required this.success,
    required this.successSurface,
    required this.favoriteSelected,
    required this.favoriteOutline,
    required this.placeholderSurface,
    required this.placeholderInk,
  });

  final AppThemeVariant variant;
  final Color detailsTint;
  final Color success;
  final Color successSurface;
  final Color favoriteSelected;
  final Color favoriteOutline;
  final Color placeholderSurface;
  final Color placeholderInk;

  static AppThemeColors of(BuildContext context) =>
      Theme.of(context).extension<AppThemeColors>()!;

  @override
  AppThemeColors copyWith({
    Color? detailsTint,
    Color? success,
    Color? successSurface,
    Color? favoriteSelected,
    Color? favoriteOutline,
    Color? placeholderSurface,
    Color? placeholderInk,
  }) => AppThemeColors(
    variant: variant,
    detailsTint: detailsTint ?? this.detailsTint,
    success: success ?? this.success,
    successSurface: successSurface ?? this.successSurface,
    favoriteSelected: favoriteSelected ?? this.favoriteSelected,
    favoriteOutline: favoriteOutline ?? this.favoriteOutline,
    placeholderSurface: placeholderSurface ?? this.placeholderSurface,
    placeholderInk: placeholderInk ?? this.placeholderInk,
  );

  @override
  AppThemeColors lerp(covariant AppThemeColors? other, double t) {
    if (other == null) return this;

    return AppThemeColors(
      variant: t < .5 ? variant : other.variant,
      detailsTint: Color.lerp(detailsTint, other.detailsTint, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      favoriteSelected: Color.lerp(
        favoriteSelected,
        other.favoriteSelected,
        t,
      )!,
      favoriteOutline: Color.lerp(favoriteOutline, other.favoriteOutline, t)!,
      placeholderSurface: Color.lerp(
        placeholderSurface,
        other.placeholderSurface,
        t,
      )!,
      placeholderInk: Color.lerp(placeholderInk, other.placeholderInk, t)!,
    );
  }
}

abstract final class AppTheme {
  static const defaultVariant = AppThemeVariant.blue;

  static ThemeData light([AppThemeVariant variant = defaultVariant]) {
    final palette = switch (variant) {
      AppThemeVariant.blue => const _Palette(
        brand: Color(0xFF0061FF),
        detailsTintOpacity: DesignColors.subtleTintOpacity,
      ),
      AppThemeVariant.purple => const _Palette(
        brand: Color(0xFF8B5DFF),
        detailsTintOpacity: DesignColors.strongTintOpacity,
      ),
      AppThemeVariant.orange => const _Palette(
        brand: Color(0xFFFF8000),
        detailsTintOpacity: DesignColors.strongTintOpacity,
      ),
    };
    final strongTint = palette.brand.withValues(
      alpha: DesignColors.strongTintOpacity,
    );
    final subtleTint = palette.brand.withValues(
      alpha: DesignColors.subtleTintOpacity,
    );
    final scheme = ColorScheme.light(
      primary: palette.brand,
      onPrimary: Colors.white,
      primaryContainer: Color.alphaBlend(strongTint, DesignColors.surface),
      onPrimaryContainer: DesignColors.text,
      secondary: palette.brand,
      onSecondary: DesignColors.surface,
      surface: DesignColors.surface,
      onSurface: DesignColors.text,
      onSurfaceVariant: DesignColors.secondaryText,
      outline: DesignColors.tertiaryText,
      outlineVariant: strongTint,
      error: DesignColors.error,
      onError: DesignColors.surface,
      errorContainer: DesignColors.errorSurface,
      onErrorContainer: DesignColors.error,
      scrim: Colors.black,
    );
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: DesignTypography.fontFamily,
      disabledColor: DesignColors.secondaryText,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [
        AppThemeColors(
          variant: variant,
          detailsTint: palette.brand.withValues(
            alpha: palette.detailsTintOpacity,
          ),
          success: DesignColors.success,
          successSurface: DesignColors.successSurface,
          favoriteSelected: DesignColors.favoriteSelected,
          favoriteOutline: DesignColors.favoriteOutline,
          placeholderSurface: DesignColors.placeholderSurface,
          placeholderInk: DesignColors.placeholderInk,
        ),
      ],
    );
    final textTheme = theme.textTheme
        .merge(DesignTypography.textTheme)
        .apply(
          fontFamily: DesignTypography.fontFamily,
          displayColor: scheme.onSurface,
          bodyColor: scheme.onSurface,
        );
    final unselectedFill = Color.alphaBlend(subtleTint, scheme.surface);

    const onBrandStateLayer = Colors.black;
    final brandFocusRing = variant == AppThemeVariant.orange
        ? DesignColors.text
        : scheme.onPrimary;

    return theme.copyWith(
      textTheme: textTheme.copyWith(
        bodyMedium: textTheme.bodyMedium!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        bodySmall: textTheme.bodySmall!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: strongTint,
        thickness: DesignShape.border,
      ),
      textButtonTheme: TextButtonThemeData(
        style:
            TextButton.styleFrom(
              foregroundColor: scheme.secondary,
              textStyle: textTheme.labelLarge,
            ).copyWith(
              side: WidgetStateBorderSide.resolveWith(
                (states) => states.contains(WidgetState.focused)
                    ? BorderSide(
                        color: scheme.secondary,
                        width: DesignShape.focusBorder,
                      )
                    : BorderSide.none,
              ),
            ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? theme.disabledColor
                : scheme.onPrimary,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? DesignColors.disabledSurface
                : scheme.primary,
          ),
          minimumSize: const WidgetStatePropertyAll(
            Size(DesignSize.tapTarget, DesignSize.primaryButton),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.all(DesignSpacing.medium),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(DesignShape.pillRadius),
              ),
            ),
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) => states.contains(WidgetState.focused)
                ? BorderSide(
                    color: brandFocusRing,
                    width: DesignShape.focusBorder,
                  )
                : BorderSide.none,
          ),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => _stateLayer(states, onBrandStateLayer),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(DesignSize.actionIcon),
          minimumSize: const WidgetStatePropertyAll(
            Size.square(DesignSize.iconButton),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          side: WidgetStateBorderSide.resolveWith(
            (states) => states.contains(WidgetState.focused)
                ? BorderSide(
                    color: scheme.secondary,
                    width: DesignShape.focusBorder,
                  )
                : BorderSide.none,
          ),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => _stateLayer(states, scheme.onSurface),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: DesignColors.searchSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSpacing.searchInset,
          vertical: DesignSpacing.medium,
        ),
        constraints: const BoxConstraints(minHeight: DesignSize.search),
        hintStyle: textTheme.bodySmall!.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: _searchBorder(subtleTint),
        enabledBorder: _searchBorder(subtleTint),
        disabledBorder: _searchBorder(subtleTint),
        focusedBorder: _searchBorder(
          variant == AppThemeVariant.orange
              ? DesignColors.text
              : scheme.primary,
          DesignShape.focusBorder,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.secondary,
        selectionColor: strongTint,
        selectionHandleColor: scheme.secondary,
      ),
      chipTheme: ChipThemeData(
        color: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return DesignColors.disabledSurface;
          }
          final selected = states.contains(WidgetState.selected);
          final background = selected ? scheme.primary : unselectedFill;
          final overlay = _stateLayer(
            states,
            selected ? onBrandStateLayer : scheme.onSurface,
          );
          return overlay == null
              ? background
              : Color.alphaBlend(overlay, background);
        }),
        labelStyle: textTheme.labelMedium,
        side: WidgetStateBorderSide.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return BorderSide(
              color: states.contains(WidgetState.selected)
                  ? brandFocusRing
                  : scheme.secondary,
              width: DesignShape.focusBorder,
            );
          }
          return states.contains(WidgetState.selected)
              ? BorderSide.none
              : BorderSide(color: strongTint);
        }),
        showCheckmark: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DesignShape.chipRadius),
          ),
        ),
        labelPadding: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSpacing.page,
          vertical: DesignSpacing.small,
        ),
      ),
    );
  }

  static OutlineInputBorder _searchBorder(
    Color color, [
    double width = DesignShape.border,
  ]) => OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(DesignShape.searchRadius),
    ),
    borderSide: BorderSide(color: color, width: width),
  );

  static Color? _stateLayer(Set<WidgetState> states, Color color) {
    if (states.contains(WidgetState.pressed)) {
      return color.withValues(alpha: 0.12);
    }
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return color.withValues(alpha: 0.08);
    }
    return null;
  }
}
