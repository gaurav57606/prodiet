import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/extensions.dart';

class DmChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const DmChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textStyle = context.textTheme.labelLarge?.copyWith(
      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }
}
