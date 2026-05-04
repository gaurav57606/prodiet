import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';

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

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      side: borderSide,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
          vertical: T2Spacing.md, horizontal: T2Spacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(T2Spacing.radiusMedium),
      ),
    );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: 18),
          const SizedBox(width: T2Spacing.sm),
        ],
        if (isLoading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        else
          Text(label,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: foregroundColor)),
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                onPressed?.call();
              },
        style: buttonStyle,
        child: content,
      ),
    );
  }
}
