import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class QuickAddGrid extends StatelessWidget {
  const QuickAddGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          _buildQuickAdd(context, "🥛", "1 Glass", "250ml"),
          const SizedBox(width: 6),
          _buildQuickAdd(context, "🫗", "2 Glasses", "500ml"),
          const SizedBox(width: 6),
          _buildQuickAdd(context, "🍶", "Bottle", "750ml"),
        ],
      ),
    );
  }

  Widget _buildQuickAdd(BuildContext context, String emoji, String label, String amount) {
    final theme = Theme.of(context);
    return Expanded(
      child: DmCard(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontSize: 9,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              amount,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
