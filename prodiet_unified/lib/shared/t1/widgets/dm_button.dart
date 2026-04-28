import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';

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
        break;
      case DmButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        break;
      case DmButtonVariant.danger:
        backgroundColor = colorScheme.error.withOpacity(0.1);
        foregroundColor = colorScheme.error;
        borderSide = BorderSide(color: colorScheme.error.withOpacity(0.2));
        break;
    }

    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: variant == DmButtonVariant.ghost || variant == DmButtonVariant.outline ? 0 : 2,
          shadowColor: backgroundColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(T1Spacing.radiusMd),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: T1Spacing.sm),
                  ],
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
