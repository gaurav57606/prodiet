import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/shopping_list/domain/models/shopping_item.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return _buildT2(context);
    }
    return _buildT1(context);
  }

  Widget _buildT1(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.isPurchased,
            onChanged: onToggle,
            activeColor: tokens.colors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.ingredientName,
                  style: tokens.typography.titleSmall.copyWith(
                    decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                    color: item.isPurchased ? tokens.colors.onSurface.withValues(alpha: 0.3) : null,
                  ),
                ),
                Text(
                  '${item.quantity} ${item.unit}',
                  style: tokens.typography.labelSmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildT2(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isPurchased ? tokens.colors.primary.withValues(alpha: 0.1) : tokens.colors.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => onToggle(!item.isPurchased),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isPurchased ? tokens.colors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: item.isPurchased ? tokens.colors.primary : tokens.colors.outline.withValues(alpha: 0.3)),
              ),
              child: item.isPurchased ? const Icon(Icons.check, size: 16, color: Colors.black) : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.ingredientName.toUpperCase(),
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: item.isPurchased ? tokens.colors.onSurface.withValues(alpha: 0.3) : tokens.colors.onSurface,
                    decoration: item.isPurchased ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  '${item.quantity} ${item.unit.toUpperCase()}',
                  style: tokens.typography.labelSmall.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: tokens.colors.onSurface.withValues(alpha: 0.4),
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
