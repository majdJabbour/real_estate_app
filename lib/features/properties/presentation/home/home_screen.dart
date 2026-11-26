import 'dart:math' as math;

import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/navigation/explore_intent.dart';
import '../../../../core/design_system/design_controls.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../domain/property.dart';
import '../widgets/home/featured_property_card.dart';
import '../widgets/home/home_account_header.dart';
import '../widgets/home/home_categories.dart';
import '../widgets/home/home_featured_row.dart';
import '../widgets/home/home_grid_skeleton.dart';
import '../widgets/home/home_loading_region.dart';
import '../widgets/home/home_section_header.dart';
import '../widgets/home/home_section_message.dart';
import '../widgets/shared/property_card_rows.dart';
import '../widgets/shared/property_grid_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final featured = ref.watch(homeFeaturedProvider);
    final recommended = ref.watch(homeRecommendationsProvider);
    final categories = ref.watch(propertyFilterOptionsProvider);
    final category = ref.watch(homeCategoryProvider);
    final activeCategory = ref.read(homeCategoryProvider.notifier);

    Future<void> refresh() async {
      await Future.wait([
        for (final request in <Future<Object?> Function()>[
          () => ref.refresh(homeFeaturedProvider.future),
          () => ref.refresh(homeRecommendationsProvider.future),
          () => ref.refresh(propertyFilterOptionsProvider.future),
        ])
          request().then<void>((_) {}, onError: (Object _, StackTrace _) {}),
      ]);
    }

    void open(PropertySummary property) => context.pushNamed(
      'propertyDetails',
      pathParameters: {'propertyId': property.id},
    );

    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = ResponsiveLayout.fromConstraints(constraints);
          if (layout.contentWidth == 0) return const SizedBox.shrink();
          final scaler = MediaQuery.textScalerOf(context);
          final grid = layout.grid(textScaler: scaler);
          final insets = layout.centeredInsets;
          final featuredWidth = math.min(
            FeaturedPropertyCard.referenceWidth,
            layout.contentWidth,
          );

          return Semantics(
            customSemanticsActions: {
              CustomSemanticsAction(label: l10n.refreshHome): refresh,
            },
            child: RefreshIndicator(
              semanticsLabel: l10n.refreshHome,
              onRefresh: refresh,
              child: CustomScrollView(
                key: const PageStorageKey('home-scroll'),
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _content(
                    insets,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 4),
                        const HomeAccountHeader(),
                        const SizedBox(height: DesignSpacing.large),
                        AppSearchField(
                          hintText: l10n.searchProperties,
                          onTap: () =>
                              const ExploreIntent(ExploreEntry.search)
                                  .open(context),
                          filter: (
                            label: l10n.openPropertyFilters,
                            onPressed: () =>
                                const ExploreIntent(ExploreEntry.filters)
                                    .open(context),
                          ),
                        ),
                        const SizedBox(height: 12),
                        HomeSectionHeader(
                          title: l10n.featuredProperties,
                          actionLabel: l10n.seeAllFeatured,
                          onAction: () =>
                              const ExploreIntent(ExploreEntry.featured)
                                  .open(context),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  featured.when(
                    data: (items) => items.isEmpty
                        ? _content(
                            insets,
                            HomeSectionMessage(l10n.emptyFeatured),
                          )
                        : SliverToBoxAdapter(
                            child: HomeFeaturedRow(
                              insets: insets,
                              height: FeaturedPropertyCard.heightFor(
                                context,
                                featuredWidth,
                                items,
                              ),
                              width: featuredWidth,
                              count: items.length,
                              item: (index) => FeaturedPropertyCard(
                                key: ValueKey('featured-${items[index].id}'),
                                property: items[index],
                                onOpen: () => open(items[index]),
                              ),
                            ),
                          ),
                    error: (error, _) => _content(
                      insets,
                      homeSectionError(
                        context,
                        error,
                        () => ref.invalidate(homeFeaturedProvider),
                      ),
                    ),
                    loading: () => SliverToBoxAdapter(
                      child: HomeLoadingRegion(
                        key: const ValueKey('featured-loading'),
                        child: HomeFeaturedRow(
                          insets: insets,
                          width: featuredWidth,
                          height: FeaturedPropertyCard.referenceHeight,
                          count: 2,
                          item: (_) => const Bone(uniRadius: 20),
                        ),
                      ),
                    ),
                  ),
                  _content(
                    insets,
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 4),
                      child: HomeSectionHeader(
                        title: l10n.recommendedProperties,
                        actionLabel: l10n.seeAllRecommendations,
                        onAction: () => ExploreIntent(
                          ExploreEntry.recommendations,
                          category: category,
                        ).open(context),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HomeCategories(
                      insets: insets,
                      category: category,
                      options: categories,
                      onSelected: activeCategory.select,
                      onRetry: () =>
                          ref.invalidate(propertyFilterOptionsProvider),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  recommended.when(
                    data: (items) => items.isEmpty
                        ? _content(
                            insets,
                            HomeSectionMessage(l10n.emptyRecommendations),
                          )
                        : PropertyCardRows(
                            insets: insets,
                            columns: grid.columns,
                            count: items.length,
                            item: (index) => PropertyGridCard(
                              key: ValueKey('recommended-${items[index].id}'),
                              property: items[index],
                              onOpen: () => open(items[index]),
                            ),
                          ),
                    error: (error, _) => _content(
                      insets,
                      homeSectionError(
                        context,
                        error,
                        () => ref.invalidate(homeRecommendationsProvider),
                      ),
                    ),
                    loading: () => PropertyCardRows(
                      insets: insets,
                      columns: grid.columns,
                      count: grid.columns * 2,
                      item: (index) => HomeLoadingRegion(
                        announce: index == 0,
                        key: index == 0
                            ? const ValueKey('recommendations-loading')
                            : null,
                        child: const HomeGridSkeleton(),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _content(EdgeInsetsGeometry insets, Widget child) =>
      SliverPadding(
        padding: insets,
        sliver: SliverToBoxAdapter(child: child),
      );
}
