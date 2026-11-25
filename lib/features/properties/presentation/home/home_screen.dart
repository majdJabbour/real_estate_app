import 'dart:math' as math;

import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/navigation/explore_intent.dart';
import '../../../../core/design_system/app_icon.dart';
import '../../../../core/design_system/design_controls.dart';
import '../../../../core/design_system/design_tokens.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/home_providers.dart';
import '../../domain/property.dart';
import '../../domain/property_filter_options.dart';
import '../../domain/property_type.dart';
import '../widgets/property_cards.dart';

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
                        const _GuestHeader(),
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
                        _SectionHeader(
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
                        ? _content(insets, _SectionMessage(l10n.emptyFeatured))
                        : _featuredRow(
                            insets,
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
                              isFavorite: false,
                              onFavoritePressed: null,
                            ),
                          ),
                    error: (error, _) => _content(
                      insets,
                      _errorMessage(
                        context,
                        error,
                        () => ref.invalidate(homeFeaturedProvider),
                      ),
                    ),
                    loading: () => SliverToBoxAdapter(
                      child: _LoadingRegion(
                        key: const ValueKey('featured-loading'),
                        child: _FeaturedRow(
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
                      child: _SectionHeader(
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
                    child: _HomeCategories(
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
                            _SectionMessage(l10n.emptyRecommendations),
                          )
                        : _grid(
                            insets,
                            columns: grid.columns,
                            count: items.length,
                            item: (index) => PropertyGridCard(
                              key: ValueKey('recommended-${items[index].id}'),
                              property: items[index],
                              onOpen: () => open(items[index]),
                              isFavorite: false,
                              onFavoritePressed: null,
                            ),
                          ),
                    error: (error, _) => _content(
                      insets,
                      _errorMessage(
                        context,
                        error,
                        () => ref.invalidate(homeRecommendationsProvider),
                      ),
                    ),
                    loading: () => _grid(
                      insets,
                      columns: grid.columns,
                      count: grid.columns * 2,
                      item: (index) => _LoadingRegion(
                        announce: index == 0,
                        key: index == 0
                            ? const ValueKey('recommendations-loading')
                            : null,
                        child: const _GridSkeleton(),
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

  static Widget _featuredRow(
    EdgeInsetsGeometry insets, {
    required double height,
    required double width,
    required int count,
    required _TileBuilder item,
  }) => SliverToBoxAdapter(
    child: _FeaturedRow(
      insets: insets,
      height: height,
      width: width,
      count: count,
      item: item,
    ),
  );

  static Widget _grid(
    EdgeInsetsGeometry insets, {
    required int columns,
    required int count,
    required _TileBuilder item,
  }) => SliverPadding(
    padding: insets,
    sliver: SliverList.builder(
      itemCount: (count + columns - 1) ~/ columns,
      itemBuilder: (context, row) => Padding(
        padding: const EdgeInsets.only(
          bottom: ResponsiveLayout.mainAxisSpacing,
        ),
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

typedef _TileBuilder = Widget Function(int index);

class _GuestHeader extends StatelessWidget {
  const _GuestHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Row(
      spacing: 12,
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: 22,
            backgroundColor: scheme.primaryContainer,
            foregroundColor: scheme.secondary,
            child: const Icon(Icons.person_outline_rounded, size: 22),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeGreeting,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.8,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.guest,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: null,
          tooltip: l10n.notificationsUnavailable,
          icon: const AppIcon(AppIcons.notification, size: 22),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(DesignSize.tapTarget),
            disabledForegroundColor: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleLarge),
          ),
        ),
        Flexible(
          flex: 0,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 128),
            child: Semantics(
              label: actionLabel,
              button: true,
              onTap: onAction,
              excludeSemantics: true,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(48, 48),
                ),
                child: Text(
                  AppLocalizations.of(context).seeAll,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow({
    required this.insets,
    required this.height,
    required this.width,
    required this.count,
    required this.item,
  });

  final EdgeInsetsGeometry insets;
  final double height;
  final double width;
  final int count;
  final _TileBuilder item;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    child: ListView.separated(
      key: const PageStorageKey('home-featured-scroll'),
      scrollDirection: Axis.horizontal,
      padding: insets,
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(width: DesignSpacing.page),
      itemBuilder: (context, index) =>
          SizedBox(width: width, child: item(index)),
    ),
  );
}

class _HomeCategories extends StatelessWidget {
  const _HomeCategories({
    required this.insets,
    required this.category,
    required this.options,
    required this.onSelected,
    required this.onRetry,
  });

  final EdgeInsetsGeometry insets;
  final PropertyType? category;
  final AsyncValue<PropertyFilterOptions> options;
  final ValueChanged<PropertyType?> onSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final types = options.when(
      data: (data) => data.types.where((type) => type.type != null),
      error: (_, _) => const <PropertyTypeOption>[],
      loading: () => const <PropertyTypeOption>[],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          key: const PageStorageKey('home-category-scroll'),
          padding: insets,
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: DesignSpacing.chipGap,
            children: [
              AppChoiceChip(
                label: l10n.all,
                selected: category == null,
                onSelected: (_) => onSelected(null),
              ),
              for (final option in types)
                AppChoiceChip(
                  label: option.label,
                  selected: category == option.type,
                  onSelected: (_) => onSelected(option.type),
                ),
            ],
          ),
        ),
        if (options.isLoading && !options.isRefreshing)
          Semantics(
            liveRegion: true,
            label: l10n.loading,
            child: const SizedBox.shrink(),
          ),
        if (!options.isLoading && options.hasError)
          Padding(
            padding: insets,
            child: _errorMessage(
              context,
              options.error!,
              onRetry,
              message: l10n.categoriesUnavailable,
            ),
          ),
      ],
    );
  }
}

class _SectionMessage extends StatelessWidget {
  const _SectionMessage(this.message, {this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: DesignSpacing.medium),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(liveRegion: true, child: Text(message)),
        if (onRetry != null)
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
      ],
    ),
  );
}

Widget _errorMessage(
  BuildContext context,
  Object error,
  VoidCallback onRetry, {
  String? message,
}) {
  final l10n = AppLocalizations.of(context);
  final localized = error is AppFailure
      ? failureMessage(l10n, error)
      : l10n.unexpectedError;
  if (localized == null) return const SizedBox.shrink();
  return _SectionMessage(message ?? localized, onRetry: onRetry);
}

class _LoadingRegion extends StatelessWidget {
  const _LoadingRegion({required this.child, this.announce = true, super.key});

  final Widget child;
  final bool announce;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: announce,
    label: announce ? AppLocalizations.of(context).loading : null,
    excludeSemantics: true,
    child: Skeletonizer.zone(child: child),
  );
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsetsDirectional.fromSTEB(14, 16, 14, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        AspectRatio(
          aspectRatio: PropertyGridCard.imageAspectRatio,
          child: Bone(uniRadius: 10),
        ),
        Bone.text(fontSize: 16, words: 2),
        Bone.text(fontSize: 12, words: 2),
        Bone.text(fontSize: 16, words: 1),
      ],
    ),
  );
}
