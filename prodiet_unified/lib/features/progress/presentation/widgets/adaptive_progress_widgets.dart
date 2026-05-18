import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AdaptiveMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const AdaptiveMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AppCard(
      padding: const EdgeInsets.all(16),
      color: isT2 ? tokens.colors.surfaceContainerLow : color.withValues(alpha: 0.08),
      border: BorderSide(
        color: isT2 ? tokens.colors.outline.withValues(alpha: 0.1) : color.withValues(alpha: 0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isT2 ? label.toUpperCase() : label,
            style: tokens.typography.labelSmall.copyWith(
              color: isT2 ? tokens.colors.onSurface.withValues(alpha: 0.4) : color.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
              letterSpacing: isT2 ? 1.2 : null,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: (isT2 ? tokens.typography.headlineSmall : tokens.typography.titleLarge).copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: tokens.typography.labelSmall.copyWith(
                  fontSize: 10,
                  color: isT2 ? tokens.colors.onSurface.withValues(alpha: 0.3) : color.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdaptiveStreakBadge extends StatelessWidget {
  final int days;

  const AdaptiveStreakBadge({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppCard(
      padding: const EdgeInsets.all(16),
      color: tokens.colors.secondary.withValues(alpha: 0.1),
      border: BorderSide(color: tokens.colors.secondary.withValues(alpha: 0.2)),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$days DAY STREAK', 
                  style: tokens.typography.titleMedium.copyWith(
                    fontWeight: FontWeight.w900, 
                    color: tokens.colors.secondary
                  )
                ),
                Text(
                  'You are consistently tracking your progress!', 
                  style: tokens.typography.bodySmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5))
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

