import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/properties/domain/property_type.dart';

enum ExploreEntry { browse, search, featured, recommendations, filters }

final class ExploreIntent {
  const ExploreIntent(this.entry, {this.category, this.request});

  factory ExploreIntent.fromUri(Uri uri) {
    final entry =
        ExploreEntry.values.asNameMap()[uri.queryParameters['entry']] ??
        ExploreEntry.browse;
    final type = uri.queryParameters['type'];
    return ExploreIntent(
      entry,
      request: uri.queryParameters['request'],
      category: entry == ExploreEntry.recommendations && type != null
          ? PropertyType.fromId(type)
          : null,
    );
  }

  final ExploreEntry entry;
  final PropertyType? category;
  final String? request;

  static int _sequence = 0;

  void open(BuildContext context) => context.goNamed(
    'explore',
    queryParameters: {
      'entry': entry.name,
      'type': ?category?.id,
      'request': '${++_sequence}',
    },
  );
}
