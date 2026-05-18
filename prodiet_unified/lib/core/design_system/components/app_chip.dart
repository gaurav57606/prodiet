import 'package:flutter/material.dart';
import '../tokens/app_theme_tokens.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BorderSide? borderSide;
  final Widget? leading;
  final Color? color;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.borderSide,
    this.leading,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    
    final effectiveColor = color ?? tokens.colors.primary;
    final bgColor = isSelected 
        ? effectiveColor.withValues(alpha: 0.15) 
        : tokens.colors.surfaceContainerLow;
    final textColor = isSelected 
        ? effectiveColor 
        : tokens.colors.onSurface.withValues(alpha: 0.7);
    final borderColor = isSelected 
        ? effectiveColor.withValues(alpha: 0.3) 
        : tokens.colors.outline.withValues(alpha: 0.1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacing.md,
          vertical: tokens.spacing.xs,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              SizedBox(width: tokens.spacing.xs),
            ],
            Text(
              label,
              style: tokens.typography.labelMedium.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
