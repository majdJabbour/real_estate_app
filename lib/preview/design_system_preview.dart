import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';

import '../core/design_system/app_theme.dart';
import '../core/design_system/design_controls.dart';
import '../core/design_system/design_tokens.dart';

@Preview(name: 'Design system', size: Size(430, 932))
@Preview(name: 'Compact and enlarged', size: Size(320, 720), textScaleFactor: 2)
Widget designSystemPreview() => const DesignSystemPreview();

class DesignSystemPreview extends StatefulWidget {
  const DesignSystemPreview({super.key});

  @override
  State<DesignSystemPreview> createState() => _DesignSystemPreviewState();
}

class _DesignSystemPreviewState extends State<DesignSystemPreview> {
  AppThemeVariant _variant = AppTheme.defaultVariant;
  bool _arabic = false;
  bool _apartments = false;
  bool _favorite = false;

  String _text(String en, String ar) => _arabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Design system preview',
      theme: AppTheme.light(_variant),
      themeAnimationDuration: Duration.zero,
      locale: Locale(_arabic ? 'ar' : 'en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Builder(builder: _buildPage),
    );
  }

  Widget _buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final colors = AppThemeColors.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme;
    void showMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = DesignSpacing.pageInset(constraints.maxWidth);
            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(
                padding,
                DesignSpacing.large,
                padding,
                DesignSpacing.large,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: DesignSpacing.medium,
                    children: [
                      Text(
                        _text('Design system', 'نظام التصميم'),
                        style: text.headlineLarge,
                      ),
                      Text(
                        _text(
                          'Explore the shared controls in English and Arabic.',
                          'جرّب عناصر التحكم المشتركة بالعربية والإنجليزية.',
                        ),
                        style: text.bodyMedium,
                      ),
                      Wrap(
                        spacing: DesignSpacing.small,
                        runSpacing: DesignSpacing.xSmall,
                        children: [
                          for (final variant in AppThemeVariant.values)
                            AppChoiceChip(
                              label: switch (variant) {
                                AppThemeVariant.blue => _text('Blue', 'أزرق'),
                                AppThemeVariant.purple => _text(
                                  'Purple',
                                  'بنفسجي',
                                ),
                                AppThemeVariant.orange => _text(
                                  'Orange',
                                  'برتقالي',
                                ),
                              },
                              selected: _variant == variant,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _variant = variant);
                                }
                              },
                            ),
                          TextButton(
                            onPressed: () => setState(() => _arabic = !_arabic),
                            child: Text(_text('العربية', 'English')),
                          ),
                        ],
                      ),
                      Text(
                        _text('Find your next home', 'اعثر على منزلك القادم'),
                        style: text.titleLarge,
                      ),
                      Text(
                        _text(
                          'Modern apartments with room to grow.',
                          'شقق حديثة بمساحات تناسب احتياجاتك.',
                        ),
                        style: text.bodyLarge,
                      ),
                      AppSearchField(
                        hintText: _text('Search properties', 'ابحث عن عقار'),
                        onSubmitted: (query) => showMessage(query),
                        filter: (
                          label: _text('Filters', 'الفلاتر'),
                          onPressed: () => showMessage(
                            _text('Filter action', 'إجراء التصفية'),
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: DesignSpacing.chipWrapGap,
                        runSpacing: DesignSpacing.xSmall,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          AppChoiceChip(
                            label: _text('All', 'الكل'),
                            compact: true,
                            selected: !_apartments,
                            onSelected: (selected) =>
                                setState(() => _apartments = !selected),
                          ),
                          AppChoiceChip(
                            label: _text('Apartments', 'شقق'),
                            compact: true,
                            selected: _apartments,
                            onSelected: (selected) =>
                                setState(() => _apartments = selected),
                          ),
                          AppIconButton(
                            label: _text('Favorite', 'المفضلة'),
                            isSelected: _favorite,
                            onPressed: () =>
                                setState(() => _favorite = !_favorite),
                            icon: Icon(
                              Icons.favorite_border,
                              color: colors.favoriteOutline,
                            ),
                            selectedIcon: Icon(
                              Icons.favorite,
                              color: colors.favoriteSelected,
                            ),
                          ),
                          AppIconButton(
                            label: _text(
                              'Notifications unavailable',
                              'الإشعارات غير متاحة',
                            ),
                            icon: const Icon(Icons.notifications_none),
                            onPressed: null,
                          ),
                        ],
                      ),
                      AppPrimaryButton(
                        label: _text('Apply filters', 'طبّق الفلاتر'),
                        onPressed: () => showMessage(
                          _text(
                            'Filters applied in preview',
                            'تم تطبيق الفلاتر في المعاينة',
                          ),
                        ),
                      ),
                      AppPrimaryButton(
                        label: _text('Unavailable', 'غير متاح'),
                        onPressed: null,
                      ),
                      AppPrimaryButton(
                        label: _text('Apply filters', 'طبّق الفلاتر'),
                        loadingLabel: _text(
                          'Applying filters…',
                          'جارٍ تطبيق الفلاتر…',
                        ),
                        onPressed: null,
                      ),
                      Wrap(
                        spacing: DesignSpacing.small,
                        runSpacing: DesignSpacing.small,
                        children: [
                          _SemanticSample(
                            label: _text('Something went wrong', 'حدث خطأ'),
                            icon: Icons.error_outline,
                            ink: scheme.onErrorContainer,
                            surface: scheme.errorContainer,
                          ),
                          _SemanticSample(
                            label: _text('Saved', 'تم الحفظ'),
                            icon: Icons.check_circle_outline,
                            ink: colors.success,
                            surface: colors.successSurface,
                          ),
                          _SemanticSample(
                            label: _text(
                              'Image unavailable',
                              'الصورة غير متاحة',
                            ),
                            icon: Icons.image_not_supported_outlined,
                            ink: colors.placeholderInk,
                            surface: colors.placeholderSurface,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SemanticSample extends StatelessWidget {
  const _SemanticSample({
    required this.label,
    required this.icon,
    required this.ink,
    required this.surface,
  });

  final String label;
  final IconData icon;
  final Color ink;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(DesignShape.searchRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignSpacing.small),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: DesignSize.searchIcon, color: ink),
            const SizedBox(width: DesignSpacing.small),
            Flexible(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(color: ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
