import 'package:material_ui/material_ui.dart';

import 'app_icon.dart';
import 'design_tokens.dart';
import 'design_typography.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.loadingLabel,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loading = loadingLabel;
    final button = FilledButton(
      onPressed: loading == null ? onPressed : null,
      style: loading == null
          ? null
          : ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(scheme.onPrimary),
              backgroundColor: WidgetStatePropertyAll(scheme.primary),
            ),
      child: loading == null
          ? Text(label, textAlign: TextAlign.center)
          : Semantics(
              liveRegion: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: SizedBox.square(
                      dimension: DesignSize.loadingIcon,
                      child: CircularProgressIndicator(
                        color: scheme.onPrimary,
                        strokeWidth: DesignShape.focusBorder,
                      ),
                    ),
                  ),
                  const SizedBox(width: DesignSpacing.small),
                  Flexible(child: Text(loading, textAlign: TextAlign.center)),
                ],
              ),
            ),
    );

    if (onPressed == null && loading == null) return button;
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        shadows: [DesignShadows.primaryButton],
      ),
      child: button,
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.selectedIcon,
    this.isSelected,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final Widget? selectedIcon;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Tooltip(
      message: label,
      excludeFromSemantics: true,
      child: MergeSemantics(
        child: Semantics(
          label: label,
          child: IconButton.filledTonal(
            onPressed: onPressed,
            icon: icon,
            selectedIcon: selectedIcon,
            isSelected: isSelected,
            style: IconButton.styleFrom(
              foregroundColor: scheme.onPrimaryContainer,
              backgroundColor: scheme.primaryContainer,
              disabledForegroundColor: theme.disabledColor,
              disabledBackgroundColor: DesignColors.disabledSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.hintText,
    this.controller,
    this.focusNode,
    this.clear,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.filter,
    this.enabled = true,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ({String label, VoidCallback onPressed})? clear;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final ({String label, VoidCallback onPressed})? filter;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trailingAction = filter;
    return Semantics(
      label: hintText,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        readOnly: onTap != null,
        showCursor: onTap == null,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        textInputAction: TextInputAction.search,
        style: theme.textTheme.bodySmall!.merge(
          DesignTypography.searchQuery.copyWith(
            color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
          ),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Center(
            widthFactor: 1,
            heightFactor: 1,
            child: AppIcon(
              AppIcons.exploreOutline,
              size: DesignSize.searchIcon,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: DesignSize.searchIconSlot,
            minHeight: DesignSize.tapTarget,
          ),
          suffixIcon: clear == null && trailingAction == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (clear case final action?)
                      IconButton(
                        tooltip: action.label,
                        onPressed: enabled ? action.onPressed : null,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: DesignSize.searchIcon,
                        ),
                      ),
                    if (trailingAction != null)
                      IconButton(
                        tooltip: trailingAction.label,
                        onPressed: enabled ? trailingAction.onPressed : null,
                        icon: const AppIcon(
                          AppIcons.filter,
                          size: DesignSize.searchIcon,
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.compact = false,
    this.multiSelect = false,
    this.focusNode,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final bool compact;
  final bool multiSelect;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = switch ((onSelected != null, selected)) {
      (false, _) => theme.disabledColor,
      (true, true) => scheme.onPrimary,
      (true, false) => scheme.onSurface,
    };
    final makeChip = multiSelect ? FilterChip.new : ChoiceChip.new;
    return makeChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      focusNode: focusNode,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      padding: compact || selected
          ? EdgeInsets.symmetric(
              horizontal: selected ? DesignSpacing.chipGap : DesignSpacing.page,
              vertical: compact ? DesignSpacing.xSmall : DesignSpacing.small,
            )
          : null,
      checkmarkColor: foreground,
      labelStyle: theme.textTheme.labelMedium!.copyWith(
        color: foreground,
        fontWeight: selected
            ? FontWeight.w600
            : compact
            ? FontWeight.w500
            : FontWeight.w400,
      ),
    );
  }
}
