import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/widgets/base_button.dart';

enum DmButtonVariant { primary, secondary, outline, ghost, danger }

class DmButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DmButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;

  const DmButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DmButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case DmButtonVariant.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        break;
      case DmButtonVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;
        break;
      case DmButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide(color: colorScheme.primary);
        break;
      case DmButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.onSurface;
        break;
      case DmButtonVariant.danger:
        backgroundColor = colorScheme.errorContainer;
        foregroundColor = colorScheme.onErrorContainer;
        break;
    }

    if (this.backgroundColor != null) backgroundColor = this.backgroundColor!;
    if (textColor != null) foregroundColor = textColor!;

    return BaseButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      loadingSize: 18,
      style: BaseButtonStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        borderRadius: BorderRadius.circular(T2Spacing.radiusMedium),
        borderSide: borderSide,
        padding: const EdgeInsets.symmetric(vertical: T2Spacing.md, horizontal: T2Spacing.lg),
        textStyle: theme.textTheme.titleMedium,
      ),
    );
  }
}

