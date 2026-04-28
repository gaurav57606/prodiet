import 'package:flutter/material.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import '../mock/inventory_mock.dart';

class InventoryItemTile extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Logic for status color
    Color statusColor;
    String statusText;
    if (item.level == StockLevel.low) {
      statusColor = const Color(0xFFFFB040);
      statusText = 'LOW STOCK';
    } else {
      statusColor = const Color(0xFF40D8B8);
      statusText = 'IN STOCK';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: DmCard(
        color: Colors.white.withOpacity(0.02),
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
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(item.name),
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.quantity} remaining',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.35),
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
                    color: statusColor.withOpacity(0.1),
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
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMacro(theme, 'PROT', '24g', const Color(0xFFFF3060)),
                  _buildMacro(theme, 'CARB', '0g', const Color(0xFFFFB870)),
                  _buildMacro(theme, 'FAT', '12g', const Color(0xFF40D8B8)),
                  _buildMacro(theme, 'KCAL', '210', theme.colorScheme.primary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacro(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('chicken') || n.contains('beef') || n.contains('egg')) return Icons.restaurant_rounded;
    if (n.contains('spinach') || n.contains('kale') || n.contains('broccoli')) return Icons.eco_rounded;
    if (n.contains('milk') || n.contains('cheese')) return Icons.egg_rounded;
    return Icons.inventory_2_rounded;
  }
}
