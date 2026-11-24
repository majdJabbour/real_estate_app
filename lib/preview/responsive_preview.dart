import 'package:material_ui/material_ui.dart';

import '../core/design_system/design_tokens.dart';
import '../core/layout/responsive_layout.dart';
import '../l10n/app_localizations.dart';

class ResponsivePreview extends StatelessWidget {
  const ResponsivePreview({
    required this.layout,
    required this.viewportHeight,
    super.key,
  });

  final ResponsiveLayout layout;
  final double viewportHeight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                Text(l10n.adaptiveLayout, style: textTheme.titleLarge),
                Text(
                  l10n.previewViewport(
                    _dp(layout.viewportWidth),
                    _dp(viewportHeight),
                  ),
                  style: textTheme.bodyMedium,
                ),
                Text(
                  l10n.previewPadding(
                    _dp(layout.horizontalPadding),
                    _dp(layout.contentWidth),
                  ),
                  style: textTheme.bodyMedium,
                ),
                Text(
                  l10n.previewGrid(grid.columns, _dp(grid.cardWidth)),
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
    final l10n = AppLocalizations.of(context);
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
          index.isEven ? l10n.sampleTile : l10n.sampleLongTile,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _dp(double value) =>
      value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
}
