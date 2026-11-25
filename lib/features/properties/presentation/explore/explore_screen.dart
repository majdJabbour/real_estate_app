import 'dart:async';
import 'dart:math' as math;

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
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/failure_message.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/explore_controller.dart';
import '../../application/home_providers.dart';
import '../../domain/property.dart';
import '../../domain/property_filter_options.dart';
import '../../domain/property_query.dart';
import '../../domain/property_type.dart';
import '../filters/property_filter_sheet.dart';
import '../widgets/property_cards.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({required this.intent, super.key});

  final ExploreIntent intent;

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _scroll = ScrollController();
  final _focus = FocusNode();
  final _search = TextEditingController();
  bool _list = false;
  bool _sheetOpen = false;
  bool _pageCheckScheduled = false;
  (ExploreEntry, PropertyType?, String?)? _handled;

  ExploreController get _controller =>
      ref.read(exploreControllerProvider.notifier);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_schedulePaging);
    _search.addListener(_rebuildSearch);
    _scheduleIntent();
  }

  @override
  void didUpdateWidget(covariant ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_intentKey(oldWidget.intent) != _intentKey(widget.intent)) {
      _scheduleIntent();
    }
  }

  static (ExploreEntry, PropertyType?, String?) _intentKey(
    ExploreIntent intent,
  ) => (intent.entry, intent.category, intent.request);

  void _scheduleIntent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final intent = widget.intent;
      final key = _intentKey(intent);
      if (_handled == key) return;
      _handled = key;
      switch (intent.entry) {
        case ExploreEntry.browse:
          unawaited(_controller.start());
        case ExploreEntry.search:
          unawaited(_controller.start());
          _focus.requestFocus();
        case ExploreEntry.filters:
          unawaited(_controller.start());
          unawaited(_openFilters());
        case ExploreEntry.featured:
        case ExploreEntry.recommendations:
          _focus.unfocus();
          _search.clear();
          unawaited(
            _controller.start(
              PropertyQuery(
                featured: intent.entry == ExploreEntry.featured ? true : null,
                types: {?intent.category},
              ),
            ),
          );
      }
    });
  }

  void _rebuildSearch() => setState(() {});

  void _schedulePaging() {
    if (_pageCheckScheduled) return;
    _pageCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageCheckScheduled = false;
      if (!mounted ||
          _sheetOpen ||
          !_scroll.hasClients ||
          !TickerMode.valuesOf(context).enabled) {
        return;
      }
      final position = _scroll.position;
      if (position.hasContentDimensions && position.extentAfter <= 200) {
        unawaited(_controller.loadMore());
      }
    });
  }

  Future<void> _openFilters() async {
    if (_sheetOpen) return;
    _focus.unfocus();
    unawaited(_controller.submitSearch());
    _sheetOpen = true;
    try {
      final draft = await openPropertyFilterSheet(
        context,
        ref.read(exploreControllerProvider).query,
      );
      if (!mounted || draft == null) return;
      final query = ref.read(exploreControllerProvider).query;
      unawaited(
        _controller.setQuery(
          query.copyWith(
            types: draft.types,
            minPrice: draft.minPrice,
            maxPrice: draft.maxPrice,
            minBedrooms: draft.minBedrooms,
            minBathrooms: draft.minBathrooms,
            minArea: draft.minArea,
            maxArea: draft.maxArea,
          ),
        ),
      );
    } finally {
      _sheetOpen = false;
      if (mounted) _schedulePaging();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _focus.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final value = ref.watch(exploreControllerProvider);
    final language = ref.watch(appLocaleProvider);
    final current = value.language == language;
    final options = ref.watch(propertyFilterOptionsProvider);
    final query = value.query;

    ref.listen(exploreControllerProvider, (previous, next) {
      if (previous?.query != next.query ||
          previous?.language != next.language) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scroll.hasClients) _scroll.jumpTo(0);
        });
      }
    });

    if (current && value.canLoadMore) _schedulePaging();
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = ResponsiveLayout.fromConstraints(constraints);
          final grid = layout.grid(
            textScaler: MediaQuery.textScalerOf(context),
          );
          final insets = layout.centeredInsets;
          if (grid.columns == 0) return const SizedBox.shrink();
          return RefreshIndicator(
            semanticsLabel: l10n.refreshHome,
            onRefresh: _controller.refresh,
            child: CustomScrollView(
              key: const PageStorageKey('explore-scroll'),
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                _box(
                  insets,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 4),
                      const _ExploreHeader(),
                      const SizedBox(height: 24),
                      AppSearchField(
                        hintText: l10n.searchProperties,
                        controller: _search,
                        focusNode: _focus,
                        onChanged: _controller.editSearch,
                        onSubmitted: (_) {
                          _focus.unfocus();
                          unawaited(_controller.submitSearch());
                        },
                        clear: _search.text.isEmpty
                            ? null
                            : (
                                label: l10n.clearSearch,
                                onPressed: () {
                                  _search.clear();
                                  _controller.editSearch('');
                                  unawaited(_controller.submitSearch());
                                },
                              ),
                        filter: (
                          label: l10n.openPropertyFilters,
                          onPressed: _openFilters,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: _ExploreCategories(
                    options: options,
                    query: query,
                    insets: insets,
                    onSelect: (type) => unawaited(
                      _controller.setQuery(query.copyWith(types: {?type})),
                    ),
                  ),
                ),
                _box(
                  insets,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            !current || value.pagination == null
                                ? l10n.exploreTab
                                : l10n.propertyResultCount(
                                    value.pagination!.total,
                                  ),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        AppIconButton(
                          label: _list ? l10n.showGrid : l10n.showList,
                          icon: Icon(
                            _list
                                ? Icons.grid_view_rounded
                                : Icons.view_agenda_outlined,
                          ),
                          onPressed: () => setState(() => _list = !_list),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!current || value.loading == ExploreLoad.initial)
                  _rows(
                    insets,
                    _list ? 1 : grid.columns,
                    _list ? 3 : grid.columns * 2,
                    (_) => _LoadingCard(list: _list),
                  )
                else if (value.items.isNotEmpty) ...[
                  _rows(
                    insets,
                    _list ? 1 : grid.columns,
                    value.items.length,
                    (index) => _card(value.items[index]),
                  ),
                  if (value.loading == ExploreLoad.next)
                    _box(
                      insets,
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: l10n.morePropertiesLoading,
                          ),
                        ),
                      ),
                    ),
                  if (value.failure case final failure?)
                    _box(
                      insets,
                      _ResultsMessage(
                        message: _message(l10n, failure.error),
                        action: failure.operation == ExploreLoad.next
                            ? l10n.retryMoreProperties
                            : l10n.retry,
                        retry: _controller.retry,
                      ),
                    ),
                ] else
                  _box(
                    insets,
                    _ResultsMessage(
                      message: value.failure == null
                          ? l10n.emptyResults
                          : _message(l10n, value.failure!.error),
                      action: value.failure == null ? null : l10n.retry,
                      retry: _controller.retry,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(PropertySummary property) {
    void open() => context.pushNamed(
      'propertyDetails',
      pathParameters: {'propertyId': property.id},
    );
    return _list
        ? PropertyListCard(
            key: ValueKey(property.id),
            property: property,
            onOpen: open,
            isFavorite: false,
            onFavoritePressed: null,
          )
        : PropertyGridCard(
            key: ValueKey(property.id),
            property: property,
            onOpen: open,
            isFavorite: false,
            onFavoritePressed: null,
          );
  }

  static String? _message(AppLocalizations l10n, Object error) =>
      error is AppFailure ? failureMessage(l10n, error) : l10n.unexpectedError;

  static Widget _box(EdgeInsetsGeometry padding, Widget child) => SliverPadding(
    padding: padding,
    sliver: SliverToBoxAdapter(child: child),
  );

  Widget _rows(
    EdgeInsetsGeometry insets,
    int columns,
    int count,
    Widget Function(int) item,
  ) => SliverPadding(
    padding: insets,
    sliver: SliverList.builder(
      itemCount: (count + columns - 1) ~/ columns,
      itemBuilder: (context, row) => Padding(
        padding: EdgeInsets.only(
          bottom: _list
              ? DesignSpacing.medium
              : ResponsiveLayout.mainAxisSpacing,
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

class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Row(
      spacing: 8,
      children: [
        AppIconButton(
          label: l10n.backToHome,
          icon: const AppIcon(AppIcons.back, size: 22),
          onPressed: () => context.go('/home'),
        ),
        Expanded(
          child: Text(
            l10n.exploreTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          tooltip: l10n.notificationsUnavailable,
          onPressed: null,
          icon: const AppIcon(AppIcons.notification, size: 22),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(DesignSize.tapTarget),
            disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ExploreCategories extends ConsumerWidget {
  const _ExploreCategories({
    required this.options,
    required this.query,
    required this.insets,
    required this.onSelect,
  });

  final AsyncValue<PropertyFilterOptions> options;
  final PropertyQuery query;
  final EdgeInsetsGeometry insets;
  final ValueChanged<PropertyType?> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final types = options.isReloading ? null : options.value?.types;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          key: const PageStorageKey('explore-categories'),
          scrollDirection: Axis.horizontal,
          padding: insets,
          child: Row(
            spacing: DesignSpacing.chipGap,
            children: [
              AppChoiceChip(
                label: l10n.all,
                selected: query.types.isEmpty,
                onSelected: (_) => onSelect(null),
              ),
              for (final type in types ?? const <PropertyTypeOption>[])
                if (type.type case final id?)
                  AppChoiceChip(
                    label: type.label,
                    selected: query.types.contains(id),
                    onSelected: (_) => onSelect(id),
                  ),
            ],
          ),
        ),
        if (query.featured == true)
          Padding(
            padding: insets,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: InputChip(
                label: Text(l10n.featuredOnly),
                deleteButtonTooltipMessage: l10n.clearFeaturedFilter,
                onDeleted: () => unawaited(
                  ref
                      .read(exploreControllerProvider.notifier)
                      .setQuery(query.copyWith(featured: null)),
                ),
              ),
            ),
          ),
        if (!options.isLoading && options.hasError)
          Padding(
            padding: insets,
            child: _ResultsMessage(
              message: l10n.categoriesUnavailable,
              action: l10n.retry,
              retry: () => ref.invalidate(propertyFilterOptionsProvider),
            ),
          ),
      ],
    );
  }
}

class _ResultsMessage extends StatelessWidget {
  const _ResultsMessage({
    required this.message,
    required this.action,
    required this.retry,
  });

  final String? message;
  final String? action;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(liveRegion: true, child: Text(message!)),
          if (action case final label?)
            TextButton(onPressed: retry, child: Text(label)),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.list});

  final bool list;

  @override
  Widget build(BuildContext context) => Skeletonizer.zone(
    child: LayoutBuilder(
      builder: (context, constraints) => list
          ? const Bone(height: 128, uniRadius: 28)
          : Bone(
              height: math.max(140, constraints.maxWidth * 1.38),
              uniRadius: 12,
            ),
    ),
  );
}
