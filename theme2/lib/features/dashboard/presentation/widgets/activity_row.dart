import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class ActivityRow extends StatelessWidget {
  const ActivityRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          _buildActivityItem(context, 0, "4,820", "Steps", Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          _buildActivityItem(context, 1, "312", "kcal Burned", const Color(0xFFFF5C3A)),
          const SizedBox(width: 6),
          _buildActivityItem(context, 2, "48m", "Active", const Color(0xFF38BFFF)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, int index, String value, String label, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: DmCard(
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: index == 0 ? 22 : 20,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(fontSize: 8, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
