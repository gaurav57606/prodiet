import 'package:flutter/material.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';

enum DmButtonVariant { primary, secondary, outline, ghost, danger }

class DmButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final DmButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  const DmButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = DmButtonVariant.primary,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textStyle = context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700);

    Color getBgColor() {
      switch (variant) {
        case DmButtonVariant.primary:
          return colorScheme.primary;
        case DmButtonVariant.secondary:
          return colorScheme.secondary;
        case DmButtonVariant.outline:
        case DmButtonVariant.ghost:
          return Colors.transparent;
        case DmButtonVariant.danger:
          return colorScheme.error;
      }
    }

    Color getFgColor() {
      switch (variant) {
        case DmButtonVariant.primary:
          return colorScheme.onPrimary;
        case DmButtonVariant.secondary:
          return colorScheme.onSecondary;
        case DmButtonVariant.outline:
        case DmButtonVariant.ghost:
          return colorScheme.primary;
        case DmButtonVariant.danger:
          return colorScheme.onError;
      }
    }

    BorderSide? getBorder() {
      if (variant == DmButtonVariant.outline) {
        return BorderSide(color: colorScheme.primary, width: 1.5);
      }
      return null;
    }

    return Container(
      width: double.infinity,
      height: 54,
      decoration: variant == DmButtonVariant.primary
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            )
          : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: variant == DmButtonVariant.primary ? Colors.transparent : getBgColor(),
          foregroundColor: getFgColor(),
          elevation: 0,
          shadowColor: Colors.transparent,
          side: getBorder(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(getFgColor()),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(label, style: textStyle),
                ],
              ),
      ),
    );
  }
}

