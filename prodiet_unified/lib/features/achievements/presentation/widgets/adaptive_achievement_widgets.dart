import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/achievements/domain/models/achievement.dart';
import 'package:google_fonts/google_fonts.dart';

class AdaptiveAchievementTile extends StatelessWidget {
  final Achievement achievement;

  const AdaptiveAchievementTile({super.key, required this.achievement});

  IconData _getIcon(String type) {
    switch (type) {
      case 'streak_7':     return Icons.local_fire_department_rounded;
      case 'streak_30':    return Icons.bolt_rounded;
      case 'protein_goal': return Icons.fitness_center_rounded;
      case 'hydration':    return Icons.water_drop_rounded;
      case 'weight_loss':  return Icons.monitor_weight_rounded;
      default:             return Icons.emoji_events_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return _buildT2Tile(context);
    }
    return _buildT1Tile(context);
  }

  Widget _buildT1Tile(BuildContext context) {
    final tokens = context.tokens;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: tokens.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(_getIcon(achievement.type), size: 24, color: tokens.colors.primary)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(achievement.title, style: tokens.typography.titleSmall.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    achievement.description,
                    style: tokens.typography.bodySmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),
            Text(
              achievement.earnedAt.length >= 10 ? achievement.earnedAt.substring(0, 10) : achievement.earnedAt,
              style: tokens.typography.bodySmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.35)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildT2Tile(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIcon(achievement.type), color: tokens.colors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title.toUpperCase(),
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: tokens.colors.onSurface,
                  ),
                ),
                Text(
                  achievement.description,
                  style: tokens.typography.bodySmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
          Text(
            achievement.earnedAt.split('T')[0].toUpperCase(),
            style: GoogleFonts.barlowCondensed(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: tokens.colors.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
