import 'package:material_ui/material_ui.dart';

import '../../../../../core/layout/responsive_layout.dart';

class PropertyCardRows extends StatelessWidget {
  const PropertyCardRows({
    required this.insets,
    required this.columns,
    required this.count,
    required this.item,
    this.rowSpacing = ResponsiveLayout.mainAxisSpacing,
    super.key,
  });

  final EdgeInsetsGeometry insets;
  final int columns;
  final int count;
  final Widget Function(int index) item;
  final double rowSpacing;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: insets,
    sliver: SliverList.builder(
      itemCount: (count + columns - 1) ~/ columns,
      itemBuilder: (context, row) => Padding(
        padding: EdgeInsets.only(bottom: rowSpacing),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: ResponsiveLayout.crossAxisSpacing,
          children: [
            for (var column = 0; column < columns; column++)
              Expanded(
                child: row * columns + column < count
                    ? item(row * columns + column)
                    : const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    ),
  );
}
