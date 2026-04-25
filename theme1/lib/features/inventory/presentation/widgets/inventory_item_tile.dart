import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../mock/inventory_mock.dart';

class InventoryItemTile extends StatelessWidget {
  final InventoryItem item;

  const InventoryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color levelColor;
    switch (item.level) {
      case StockLevel.low:
        levelColor = const Color(0xFFFF6080);
        break;
      case StockLevel.medium:
        levelColor = const Color(0xFFFFB040);
        break;
      case StockLevel.ok:
        levelColor = const Color(0xFF40D8B8);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.level == StockLevel.low ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
                  size: 18,
                  color: levelColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      item.subtext,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: item.level == StockLevel.low ? levelColor : theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.quantity,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${(item.percentage * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.06),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: item.percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: levelColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
