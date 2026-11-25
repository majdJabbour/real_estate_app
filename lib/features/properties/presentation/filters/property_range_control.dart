import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/property_filter_options.dart';

const _thumbRadius = 12.0;

bool hasAdjustableBounds(PropertyBounds<double> bounds) {
  final (min: min, max: max) = bounds;
  return min != null &&
      max != null &&
      min.isFinite &&
      max.isFinite &&
      min < max;
}

RangeValues rangeWithinBounds(
  PropertyBounds<double> bounds,
  double? minimum,
  double? maximum,
) {
  final lower = bounds.min!;
  final upper = bounds.max!;
  return RangeValues(
    (minimum ?? lower).clamp(lower, upper),
    (maximum ?? upper).clamp(lower, upper),
  );
}

PropertyBounds<double> unrestrictedEndpoints(
  PropertyBounds<double> bounds,
  RangeValues selected,
) {
  final lower = bounds.min!;
  final upper = bounds.max!;
  double rounded(double value) => value.abs() < 1e12
      ? ((value * 100).roundToDouble() / 100).clamp(lower, upper)
      : value;
  final start = rounded(selected.start);
  final end = rounded(selected.end);
  return (
    min: selected.start <= lower || start <= lower ? null : start,
    max: selected.end >= upper || end >= upper ? null : end,
  );
}

class PropertyRangeControl extends StatelessWidget {
  const PropertyRangeControl({
    required this.label,
    required this.bounds,
    required this.minimum,
    required this.maximum,
    required this.formatValue,
    required this.onChanged,
    this.buckets = const [],
    super.key,
  });

  final String label;
  final PropertyBounds<double> bounds;
  final double? minimum;
  final double? maximum;
  final String Function(double) formatValue;
  final ValueChanged<PropertyBounds<double>> onChanged;
  final List<PriceHistogramBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final available = hasAdjustableBounds(bounds);
    final values = available
        ? rangeWithinBounds(bounds, minimum, maximum)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 14),
        if (values != null) ...[
          Stack(
            children: [
              if (buckets.isNotEmpty)
                Positioned(
                  left: _thumbRadius,
                  right: _thumbRadius,
                  top: 0,
                  bottom: 24,
                  child: CustomPaint(
                    painter: PriceHistogramPainter(
                      buckets: buckets,
                      minimum: bounds.min!,
                      maximum: bounds.max!,
                      color: scheme.primaryContainer,
                      direction: Directionality.of(context),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(top: buckets.isEmpty ? 0 : 34),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                    rangeThumbShape: _FilterThumb(scheme.surface),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: _thumbRadius,
                    ),
                    showValueIndicator: ShowValueIndicator.never,
                    activeTrackColor: scheme.primary,
                    inactiveTrackColor: scheme.primaryContainer,
                    thumbColor: scheme.primary,
                    minThumbSeparation: 0,
                  ),
                  child: Semantics(
                    label: label,
                    child: RangeSlider(
                      min: bounds.min!,
                      max: bounds.max!,
                      values: values,
                      semanticFormatterCallback: formatValue,
                      onChanged: (next) =>
                          onChanged(unrestrictedEndpoints(bounds, next)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          _RangeLabels(
            lower: formatValue(values.start),
            upper: formatValue(values.end),
            fractions: (
              (values.start - bounds.min!) / (bounds.max! - bounds.min!),
              (values.end - bounds.min!) / (bounds.max! - bounds.min!),
            ),
          ),
        ] else ...[
          if (bounds.min != null &&
              bounds.min == bounds.max &&
              buckets.isNotEmpty)
            SizedBox(
              height: 34,
              child: CustomPaint(
                painter: PriceHistogramPainter(
                  buckets: buckets,
                  minimum: bounds.min!,
                  maximum: bounds.min!,
                  color: scheme.primaryContainer,
                  direction: Directionality.of(context),
                ),
              ),
            ),
          Text(
            bounds.min != null && bounds.min == bounds.max
                ? formatValue(bounds.min!)
                : l10n.noRangeAvailable,
          ),
        ],
      ],
    );
  }
}

class _RangeLabels extends StatelessWidget {
  const _RangeLabels({
    required this.lower,
    required this.upper,
    required this.fractions,
  });

  final String lower;
  final String upper;
  final (double, double) fractions;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final theme = Theme.of(context);
      final style = theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.secondary,
      );
      final width = constraints.maxWidth;
      final (first, last) = fractions;

      Size measure(String text) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        final size = painter.size;
        painter.dispose();
        return size;
      }

      final lowerSize = measure(lower);
      final upperSize = measure(upper);
      final lowerWidth = (lowerSize.width + 2).ceilToDouble();
      final upperWidth = (upperSize.width + 2).ceilToDouble();

      double start(double fraction, double labelWidth) =>
          (_thumbRadius +
                  fraction * math.max(0, width - 2 * _thumbRadius) -
                  labelWidth / 2)
              .clamp(0, math.max(0, width - labelWidth));

      final left = start(first, lowerWidth);
      final right = start(last, upperWidth);
      if (left + lowerWidth + 8 > right ||
          lowerWidth + upperWidth + 8 > width) {
        return Row(
          spacing: 8,
          children: [
            Expanded(child: _RangeValue(lower, minimum: true, style: style)),
            Expanded(child: _RangeValue(upper, minimum: false, style: style)),
          ],
        );
      }
      return SizedBox(
        height: math.max(lowerSize.height, upperSize.height).ceilToDouble() + 2,
        child: Stack(
          children: [
            PositionedDirectional(
              start: left,
              width: lowerWidth,
              child: _RangeValue(
                lower,
                minimum: true,
                style: style,
                aligned: true,
              ),
            ),
            PositionedDirectional(
              start: right,
              width: upperWidth,
              child: _RangeValue(
                upper,
                minimum: false,
                style: style,
                aligned: true,
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _RangeValue extends StatelessWidget {
  const _RangeValue(
    this.value, {
    required this.minimum,
    required this.style,
    this.aligned = false,
  });

  final String value;
  final bool minimum;
  final TextStyle style;
  final bool aligned;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: minimum ? l10n.minimumValue(value) : l10n.maximumValue(value),
      excludeSemantics: true,
      child: Text(
        value,
        textAlign: aligned
            ? TextAlign.center
            : minimum
            ? TextAlign.start
            : TextAlign.end,
        style: style,
      ),
    );
  }
}

class PriceHistogramPainter extends CustomPainter {
  const PriceHistogramPainter({
    required this.buckets,
    required this.minimum,
    required this.maximum,
    required this.color,
    required this.direction,
  });

  final List<PriceHistogramBucket> buckets;
  final double minimum;
  final double maximum;
  final Color color;
  final TextDirection direction;

  @override
  void paint(Canvas canvas, Size size) {
    final count = buckets.fold(
      0,
      (largest, bucket) => math.max(largest, bucket.count),
    );
    if (count <= 0 || maximum < minimum || size.isEmpty) return;
    final paint = Paint()..color = color;
    if (maximum == minimum) {
      canvas.drawRect(Offset.zero & size, paint);
      return;
    }
    double x(double value) {
      final fraction = ((value - minimum) / (maximum - minimum)).clamp(
        0.0,
        1.0,
      );
      return size.width *
          (direction == TextDirection.ltr ? fraction : 1 - fraction);
    }

    for (final bucket in buckets) {
      if (bucket.count <= 0) continue;
      final from = x(bucket.from);
      final to = x(bucket.to);
      final gap = math.min(2.0, (from - to).abs() / 4);
      final height = size.height * bucket.count / count;
      canvas.drawRect(
        Rect.fromLTRB(
          math.min(from, to) + gap,
          size.height - height,
          math.max(from, to) - gap,
          size.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(PriceHistogramPainter oldDelegate) =>
      oldDelegate.buckets != buckets ||
      oldDelegate.minimum != minimum ||
      oldDelegate.maximum != maximum ||
      oldDelegate.color != color ||
      oldDelegate.direction != direction;
}

class _FilterThumb extends RangeSliderThumbShape {
  const _FilterThumb(this.surface);

  final Color surface;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.square(_thumbRadius * 2);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    context.canvas
      ..drawCircle(
        center,
        _thumbRadius,
        Paint()..color = sliderTheme.thumbColor!,
      )
      ..drawCircle(center, _thumbRadius - 3, Paint()..color = surface);
  }
}
