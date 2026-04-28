import 'package:flutter/material.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import '../../domain/models/inventory_item.dart';

class InventoryItemTile extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Logic for status color
    Color statusColor;
    String statusText;
    final daysUntilExpiry = item.daysUntilExpiry;

    if (item.isLowStock) {
      statusColor = const Color(0xFFFFB040);
      statusText = 'LOW STOCK';
    } else if (daysUntilExpiry <= 0) {
      statusColor = const Color(0xFFFF6080);
      statusText = 'EXPIRED';
    } else if (daysUntilExpiry <= 3) {
      statusColor = const Color(0xFFFF6080);
      statusText = 'EXPIRING SOON';
    } else {
      statusColor = const Color(0xFF40D8B8);
      statusText = 'IN STOCK';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: DmCard(
        color: Colors.white.withValues(alpha: 0.02),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(item.ingredientName, item.category),
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.ingredientName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.quantity} ${item.unit} remaining',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfo(theme, 'CATEGORY', item.category.toUpperCase(), const Color(0xFF8B5CF6)),
                  _buildInfo(theme, 'EXPIRY', daysUntilExpiry <= 0 ? 'Expired' : '$daysUntilExpiry days', statusColor),
                  _buildInfo(theme, 'UNIT', item.unit.toUpperCase(), theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(ThemeData theme, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String name, String category) {
    final n = name.toLowerCase();
    final c = category.toLowerCase();
    if (c.contains('protein') || n.contains('chicken') || n.contains('beef') || n.contains('egg')) return Icons.restaurant_rounded;
    if (c.contains('veg') || n.contains('spinach') || n.contains('kale') || n.contains('broccoli')) return Icons.eco_rounded;
    if (c.contains('dairy') || n.contains('milk') || n.contains('cheese')) return Icons.egg_rounded;
    if (c.contains('grain') || n.contains('rice') || n.contains('oat')) return Icons.bakery_dining_rounded;
    return Icons.inventory_2_rounded;
  }
}
