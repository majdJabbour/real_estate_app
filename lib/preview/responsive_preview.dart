import 'package:material_ui/material_ui.dart';

import '../core/design_system/design_tokens.dart';
import '../core/layout/responsive_layout.dart';

class ResponsivePreview extends StatelessWidget {
  const ResponsivePreview({
    required this.layout,
    required this.viewportHeight,
    required this.arabic,
    super.key,
  });

  final ResponsiveLayout layout;
  final double viewportHeight;
  final bool arabic;

  String _text(String en, String ar) => arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final grid = layout.grid(textScaler: MediaQuery.textScalerOf(context));
    if (grid.columns == 0) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final textTheme = Theme.of(context).textTheme;
    const tileCount = 7;
    final rowCount = (tileCount + grid.columns - 1) ~/ grid.columns;
    return SliverPadding(
      padding: layout.centeredInsets.add(
        const EdgeInsets.only(top: DesignSpacing.large),
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: DesignSpacing.small,
              children: [
                Text(
                  _text('Adaptive layout', 'التخطيط المتكيف'),
                  style: textTheme.titleLarge,
                ),
                Text(
                  '${_text('Viewport', 'مساحة العرض')}'
                  ' ${_dp(layout.viewportWidth)} × ${_dp(viewportHeight)}',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  '${_text('Side padding', 'الهوامش الجانبية')}'
                  ' ${_dp(layout.horizontalPadding)}'
                  '  ·  ${_text('Content', 'المحتوى')} ${_dp(layout.contentWidth)}',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  '${_text('Columns', 'الأعمدة')}'
                  ' ${grid.columns}'
                  '  ·  ${_text('Tile width', 'عرض العنصر')} ${_dp(grid.cardWidth)}',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: DesignSpacing.small),
              ],
            ),
          ),
          SliverList.builder(
            itemCount: rowCount,
            itemBuilder: (context, row) => Padding(
              padding: const EdgeInsets.only(
                bottom: ResponsiveLayout.mainAxisSpacing,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: ResponsiveLayout.crossAxisSpacing,
                children: [
                  for (var column = 0; column < grid.columns; column++)
                    Expanded(
                      child: _buildTile(
                        context,
                        row * grid.columns + column,
                        tileCount,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, int index, int count) {
    if (index >= count) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: DesignSpacing.small,
      children: [
        AspectRatio(
          aspectRatio: 159 / 154,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(DesignShape.photoRadius),
            ),
            child: const ExcludeSemantics(child: Icon(Icons.image_outlined)),
          ),
        ),
        Text(
          index.isEven
              ? _text('Sample tile', 'عنصر تجريبي')
              : _text('Sample with a longer label', 'عنصر تجريبي بعنوان أطول'),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _dp(double value) =>
      value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
}
