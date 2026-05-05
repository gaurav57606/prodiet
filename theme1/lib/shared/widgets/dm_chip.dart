import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

class DmChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onSelected;
  final Color? backgroundColor;
  final Color? textColor;

  const DmChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onSelected,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = isSelected 
        ? (backgroundColor ?? colorScheme.primary)
        : (backgroundColor ?? (theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4)));
    
    final txtColor = isSelected
        ? (textColor ?? colorScheme.onPrimary)
        : (textColor ?? colorScheme.onSurface.withValues(alpha: 0.5));

    return GestureDetector(
      onTap: () {
        onTap?.call();
        onSelected?.call(!isSelected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: txtColor,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
