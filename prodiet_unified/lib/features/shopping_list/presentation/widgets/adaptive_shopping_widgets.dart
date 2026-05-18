import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/shopping_list/domain/models/shopping_item.dart';

class AdaptiveShoppingItemTile extends StatelessWidget {
  final ShoppingItem item;
  final ValueChanged<bool?> onToggle;

  const AdaptiveShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isPurchased = item.isPurchased;
    final isT2 = tokens.customCheckboxShape;

    return Container(
      margin: EdgeInsets.only(bottom: isT2 ? tokens.spacing.md : tokens.spacing.sm),
      padding: isT2 
          ? EdgeInsets.all(tokens.spacing.lg) 
          : EdgeInsets.symmetric(horizontal: tokens.spacing.md, vertical: tokens.spacing.sm),
      decoration: BoxDecoration(
        color: isT2 ? tokens.colors.surfaceContainerLowest : tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(isT2 ? 16 : 12),
        border: isT2 
            ? Border.all(color: isPurchased ? tokens.colors.primary.withValues(alpha: 0.1) : tokens.colors.outline.withValues(alpha: 0.1)) 
            : null,
      ),
      child: Row(
        children: [
          if (isT2)
            InkWell(
              onTap: () => onToggle(!isPurchased),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isPurchased ? tokens.colors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isPurchased ? tokens.colors.primary : tokens.colors.outline.withValues(alpha: 0.3)),
                ),
                child: isPurchased ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
              ),
            )
          else
            Checkbox(
              value: isPurchased,
              onChanged: onToggle,
              activeColor: tokens.colors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          SizedBox(width: isT2 ? 16 : 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tokens.useUpperCasing ? item.ingredientName.toUpperCase() : item.ingredientName,
                  style: (isT2 ? tokens.typography.headlineLarge : tokens.typography.titleSmall).copyWith(
                    fontSize: isT2 ? 18 : 14,
                    fontWeight: isT2 ? FontWeight.w900 : FontWeight.w500,
                    color: isPurchased ? tokens.colors.onSurface.withValues(alpha: 0.3) : tokens.colors.onSurface,
                    decoration: isPurchased ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  tokens.useUpperCasing 
                      ? '${item.quantity} ${item.unit.toUpperCase()}' 
                      : '${item.quantity} ${item.unit}',
                  style: tokens.typography.labelSmall.copyWith(
                    fontSize: isT2 ? 10 : 9,
                    fontWeight: isT2 ? FontWeight.w600 : FontWeight.w700,
                    color: tokens.colors.onSurface.withValues(alpha: isT2 ? 0.4 : 0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
