import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class DietHero extends StatelessWidget {
  const DietHero({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          DmCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  "Current Plan · Week 3/12",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: primary,
                    fontSize: 9,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  "High Protein\nLean Cut",
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 24,
                    height: 1.1,
                  ),
                ),
                Text(
                  "By Dr. Meera Kapoor · 12-week programme",
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildPill(context, "2,000 kcal", primary),
                    const SizedBox(width: 5),
                    _buildPill(context, "150g protein", const Color(0xFF38BFFF)),
                    const SizedBox(width: 5),
                    _buildPill(context, "No dairy", const Color(0xFFFF5C3A)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, const Color(0xFF38BFFF)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }
}
