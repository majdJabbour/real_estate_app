import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../properties/presentation/widgets/shared/property_list_card.dart';
import '../../application/favorites_providers.dart';
import 'favorites_message.dart';

class FavoritesPages extends ConsumerStatefulWidget {
  const FavoritesPages({super.key});

  @override
  ConsumerState<FavoritesPages> createState() => _FavoritesPagesState();
}

class _FavoritesPagesState extends ConsumerState<FavoritesPages> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = favoritePropertiesProvider(_page);
    final result = ref.watch(provider);
    final page = result.asData?.value;
    final error = result.error;
    final hasPreviousPage = page?.pagination.hasPreviousPage ?? _page > 1;
    final pendingRemovals = ref.watch(
      favoriteMembershipControllerProvider.select((value) {
        final current = value.asData?.value;
        return current == null
            ? const <String>[]
            : current.pending.where((id) => !current.ids.contains(id)).toList();
      }),
    );
    final properties = page?.items.where(
      (property) => !pendingRemovals.contains(property.id),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(provider);
        try {
          await ref.read(provider.future);
        } catch (_) {
          // The provider exposes the error to the retry state.
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = ResponsiveLayout.fromConstraints(
            constraints,
            maxContentWidth: ResponsiveLayout.detailsMaxWidth,
          );
          return ListView(
            key: ValueKey(_page),
            physics: const AlwaysScrollableScrollPhysics(),
            padding: layout.centeredInsets.add(
              const EdgeInsetsDirectional.only(
                top: DesignSpacing.medium,
                bottom: DesignSpacing.large,
              ),
            ),
            children: [
              if (result.isLoading && page == null)
                Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: l10n.loading,
                  ),
                )
              else if (error != null)
                FavoritesMessage(
                  text: error is AppFailure
                      ? failureMessage(l10n, error)
                      : l10n.unexpectedError,
                  action: FilledButton(
                    onPressed: () => ref.invalidate(provider),
                    child: Text(l10n.retry),
                  ),
                )
              else if (page != null && properties != null) ...[
                if (properties.isEmpty)
                  FavoritesMessage(
                    text: page.items.isNotEmpty
                        ? l10n.favoriteUpdating
                        : page.pagination.total == 0
                        ? l10n.emptyFavorites
                        : l10n.emptyFavoritesPage,
                  ),
                for (final property in properties)
                  Padding(
                    key: ValueKey(property.id),
                    padding: const EdgeInsets.only(
                      bottom: DesignSpacing.medium,
                    ),
                    child: PropertyListCard(
                      property: property,
                      onOpen: () => context.pushNamed(
                        'propertyDetails',
                        pathParameters: {'propertyId': property.id},
                      ),
                    ),
                  ),
              ],
              if (!result.isLoading &&
                  (hasPreviousPage || page?.pagination.hasNextPage == true))
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    if (hasPreviousPage)
                      TextButton(
                        onPressed: () => setState(() => _page--),
                        child: Text(l10n.previousFavoritesPage),
                      ),
                    if (page?.pagination.hasNextPage == true)
                      TextButton(
                        onPressed: () => setState(() => _page++),
                        child: Text(l10n.nextFavoritesPage),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
