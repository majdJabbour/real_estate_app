import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../design_system/design_tokens.dart';

enum LayoutWidth { compact, phone, tablet, expanded }

@immutable
final class ResponsiveLayout {
  const ResponsiveLayout._({
    required this.viewportWidth,
    required this.horizontalPadding,
    required this.contentWidth,
  });

  factory ResponsiveLayout.fromConstraints(
    BoxConstraints constraints, {
    double maxContentWidth = collectionMaxWidth,
    double? fallbackWidth,
  }) {
    assert(maxContentWidth.isFinite && maxContentWidth > 0);
    assert(
      fallbackWidth == null || (fallbackWidth.isFinite && fallbackWidth >= 0),
    );

    final width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : constraints.constrainWidth(
            fallbackWidth ?? maxContentWidth + 2 * expandedPadding,
          );
    final padding = math.min(width / 2, _pagePadding(width));
    return ResponsiveLayout._(
      viewportWidth: width,
      horizontalPadding: padding,
      contentWidth: math.min(width - 2 * padding, maxContentWidth),
    );
  }

  static const phoneMinWidth = 360.0;
  static const tabletMinWidth = 600.0;
  static const expandedMinWidth = 840.0;
  static const expandedPadding = 32.0;

  static const collectionMaxWidth = 1120.0;
  static const detailsMaxWidth = 680.0;
  static const filtersMaxWidth = 560.0;
  static const authMaxWidth = 480.0;

  static const minimumCardWidth = 160.0;
  static const crossAxisSpacing = DesignSpacing.medium;
  static const mainAxisSpacing = DesignSpacing.page;

  final double viewportWidth;
  final double horizontalPadding;
  final double contentWidth;

  LayoutWidth get widthClass => switch (viewportWidth) {
    < phoneMinWidth => LayoutWidth.compact,
    < tabletMinWidth => LayoutWidth.phone,
    < expandedMinWidth => LayoutWidth.tablet,
    _ => LayoutWidth.expanded,
  };

  /// Includes the extra space needed to center a capped content area.
  EdgeInsetsDirectional get centeredInsets => EdgeInsetsDirectional.symmetric(
    horizontal: (viewportWidth - contentWidth) / 2,
  );

  /// The caller can request more room for localized labels or larger actions.
  ({int columns, double cardWidth}) grid({
    TextScaler textScaler = TextScaler.noScaling,
    double minCardWidth = minimumCardWidth,
  }) {
    assert(minCardWidth.isFinite && minCardWidth >= minimumCardWidth);
    if (contentWidth == 0) return (columns: 0, cardWidth: 0);

    // Reserve extra room for labels based on how the scaler treats 16 dp text.
    // Image dimensions, spacing and touch targets retain their own tokens.
    final labelRoom = 5 * math.max(0.0, textScaler.scale(16) - 16);
    final effectiveMinimum = minCardWidth + labelRoom;
    final estimate =
        ((contentWidth + crossAxisSpacing) /
                (effectiveMinimum + crossAxisSpacing))
            .floor();
    final columns = widthClass == LayoutWidth.expanded
        ? math.max(1, estimate)
        : estimate.clamp(1, 3);
    return (
      columns: columns,
      cardWidth: (contentWidth - (columns - 1) * crossAxisSpacing) / columns,
    );
  }

  static double _pagePadding(double width) => switch (width) {
    < 390 => DesignSpacing.medium,
    < tabletMinWidth => DesignSpacing.page,
    < expandedMinWidth => DesignSpacing.large,
    _ => expandedPadding,
  };
}

/// Centers a box child in the same content area used by sliver layouts.
class AdaptiveContent extends StatelessWidget {
  const AdaptiveContent({
    required this.child,
    this.maxContentWidth = ResponsiveLayout.collectionMaxWidth,
    super.key,
  });

  final Widget child;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final layout = ResponsiveLayout.fromConstraints(
        constraints,
        maxContentWidth: maxContentWidth,
        fallbackWidth: constraints.hasBoundedWidth
            ? null
            : MediaQuery.maybeSizeOf(context)?.width,
      );
      return SizedBox(
        width: layout.viewportWidth,
        child: Padding(padding: layout.centeredInsets, child: child),
      );
    },
  );
}
