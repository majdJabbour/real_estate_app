import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../app/navigation/explore_intent.dart';
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
import '../../domain/property_query.dart';
import '../../domain/property_type.dart';
import '../filters/property_filter_sheet.dart';
import '../widgets/explore/explore_categories.dart';
import '../widgets/explore/explore_header.dart';
import '../widgets/explore/explore_loading_card.dart';
import '../widgets/explore/explore_results_message.dart';
import '../widgets/shared/property_card_rows.dart';
import '../widgets/shared/property_grid_card.dart';
import '../widgets/shared/property_list_card.dart';

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
    final filtersApplied =
        query.types.isNotEmpty ||
        query.minPrice != null ||
        query.maxPrice != null ||
        (query.minBedrooms ?? 0) > 0 ||
        (query.minBathrooms ?? 0) > 0 ||
        query.minArea != null ||
        query.maxArea != null ||
        query.featured == true;

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
                      const ExploreHeader(),
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
                        filtersApplied: filtersApplied,
                        filter: (
                          label: filtersApplied
                              ? l10n.openAppliedPropertyFilters
                              : l10n.openPropertyFilters,
                          onPressed: _openFilters,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: ExploreCategories(
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
                  PropertyCardRows(
                    insets: insets,
                    columns: _list ? 1 : grid.columns,
                    count: _list ? 3 : grid.columns * 2,
                    rowSpacing: _list
                        ? DesignSpacing.medium
                        : ResponsiveLayout.mainAxisSpacing,
                    item: (_) => ExploreLoadingCard(list: _list),
                  )
                else if (value.items.isNotEmpty) ...[
                  PropertyCardRows(
                    insets: insets,
                    columns: _list ? 1 : grid.columns,
                    count: value.items.length,
                    rowSpacing: _list
                        ? DesignSpacing.medium
                        : ResponsiveLayout.mainAxisSpacing,
                    item: (index) => _card(value.items[index]),
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
                      ExploreResultsMessage(
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
                    ExploreResultsMessage(
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
          )
        : PropertyGridCard(
            key: ValueKey(property.id),
            property: property,
            onOpen: open,
          );
  }

  static String? _message(AppLocalizations l10n, Object error) =>
      error is AppFailure ? failureMessage(l10n, error) : l10n.unexpectedError;

  static Widget _box(EdgeInsetsGeometry padding, Widget child) => SliverPadding(
    padding: padding,
    sliver: SliverToBoxAdapter(child: child),
  );
}
