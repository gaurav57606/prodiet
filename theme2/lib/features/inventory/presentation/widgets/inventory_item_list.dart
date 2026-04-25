import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class InventoryItemList extends StatelessWidget {
  const InventoryItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final coral = const Color(0xFFFF5C3A);
    
    final items = [
      {'ico': '🥛', 'bg': Color(0xFF1a140a), 'nm': 'Skimmed Milk', 'sb': 'Expires 3 days', 'qty': '500ml', 'isLow': false, 'w': 40.0},
      {'ico': '🥩', 'bg': Color(0xFF1a0d14), 'nm': 'Paneer', 'sb': 'Running low · Expires tmrw', 'qty': '100g', 'isLow': true, 'w': 14.0},
      {'ico': '🌿', 'bg': Color(0xFF0a1a0d), 'nm': 'Spinach', 'sb': 'Critical · 1 bunch left', 'qty': '1 bunch', 'isLow': true, 'w': 10.0},
      {'ico': '🌾', 'bg': Color(0xFF14140a), 'nm': 'Oats', 'sb': 'Good stock · 400g left', 'qty': '400g', 'isLow': false, 'w': 32.0},
      {'ico': '🫒', 'bg': Color(0xFF0a1014), 'nm': 'Olive Oil', 'sb': 'Well stocked · 450ml', 'qty': '450ml', 'isLow': false, 'w': 44.0},
      {'ico': '🥜', 'bg': Color(0xFF14080a), 'nm': 'Almonds', 'sb': 'Critical · Only 20g left', 'qty': '20g', 'isLow': true, 'w': 7.0},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => Divider(height: 1, color: theme.colorScheme.outline),
          itemBuilder: (context, index) {
            final item = items[index];
            final color = (item['isLow'] as bool) ? coral : primary;
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item['bg'] as Color,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(child: Text(item['ico'] as String, style: const TextStyle(fontSize: 16))),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['nm'] as String, style: theme.textTheme.titleMedium),
                        Text(item['sb'] as String, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item['qty'] as String,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 15,
                          color: color,
                        ),
                      ),
                      Container(
                        height: 3,
                        width: item['w'] as double,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
