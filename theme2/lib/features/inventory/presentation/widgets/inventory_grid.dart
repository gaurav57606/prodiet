import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class InventoryGrid extends StatelessWidget {
  const InventoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.2,
        children: [
          _buildStatCard(context, "32", "Items tracked", Theme.of(context).colorScheme.primary),
          _buildStatCard(context, "4", "Need restock", const Color(0xFFFF5C3A)),
          _buildStatCard(context, "₹2,840", "Monthly", const Color(0xFFFFB800)),
          _buildStatCard(context, "7d", "Avg shelf life", const Color(0xFF38BFFF)),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, Color color) {
    final theme = Theme.of(context);
    return DmCard(
      borderSide: BorderSide(color: color.withValues(alpha: 0.3), width: 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: 36,
              color: color,
            ),
          ),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
