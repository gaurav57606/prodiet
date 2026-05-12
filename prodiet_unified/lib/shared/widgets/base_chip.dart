import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/radius.dart';
import 'package:prodiet_unified/core/design_system/spacing.dart';

class BaseChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BorderSide? borderSide;
  final TextStyle? textStyle;

  const BaseChip({
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.borderSide,
    this.textStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.pill),
          border: borderSide != null ? Border.fromBorderSide(borderSide!) : null,
        ),
        child: Text(
          label,
          style: textStyle?.copyWith(color: textColor) ?? 
                 theme.textTheme.labelLarge?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
