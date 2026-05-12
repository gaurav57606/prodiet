import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/widgets/base_button.dart';

enum DmButtonVariant { primary, secondary, outline, ghost, danger }

class DmButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DmButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const DmButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DmButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide = BorderSide.none;
    double elevation = 2;

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
        borderSide = BorderSide(color: colorScheme.primary, width: 1.5);
        elevation = 0;
        break;
      case DmButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        elevation = 0;
        break;
      case DmButtonVariant.danger:
        backgroundColor = colorScheme.error.withValues(alpha: 0.1);
        foregroundColor = colorScheme.error;
        borderSide = BorderSide(color: colorScheme.error.withValues(alpha: 0.2));
        break;
    }

    return BaseButton(
      label: label,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      width: width,
      height: 48,
      style: BaseButtonStyle(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: elevation,
        shadowColor: backgroundColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
        borderSide: borderSide,
        padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
        textStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

