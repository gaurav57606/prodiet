import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/progress/application/progress_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final logsAsync = ref.watch(progressLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(T1Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard(context, summary),
              const SizedBox(height: T1Spacing.lg),
              Text(
                'WEEKLY COMPLIANCE',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildComplianceChart(context),
              const SizedBox(height: T1Spacing.lg),
              Text(
                'ACHIEVEMENTS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildAchievementList(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, dynamic summary) {
    final theme = Theme.of(context);
    return DmCard(
      color: theme.colorScheme.primary.withValues(alpha: 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(theme, '${summary.currentWeightKg ?? "--"}kg', 'Current'),
          _buildStatItem(theme, '${summary.streakDays}d', 'Streak'),
          _buildStatItem(theme, '${(summary.stepsToday / 1000).toStringAsFixed(1)}k', 'Steps'),
        ],
      ),
    );
  }

  Widget _buildStatItem(ThemeData theme, String value, String label) {
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w900)),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildComplianceChart(BuildContext context) {
    final theme = Theme.of(context);
    final days = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
    final values = [0.8, 0.4, 0.9, 0.95, 0.7, 0.85, 0.6];

    return DmCard(
      child: SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(days.length, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 30,
                  height: 100 * values[index],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.2),
                        theme.colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(days[index], style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAchievementList(BuildContext context) {
    return Column(
      children: [
        _buildAchievementTile(context, 'Consistent Crusader', '7 days of hitting protein goals', Icons.star_rounded, const Color(0xFFFFD700)),
        const SizedBox(height: T1Spacing.sm),
        _buildAchievementTile(context, 'Hydration Master', 'Drank 3L+ for 3 consecutive days', Icons.water_drop_rounded, const Color(0xFF40D8B8)),
        const SizedBox(height: T1Spacing.sm),
        _buildAchievementTile(context, 'Green Chef', 'Logged 10 unique vegetable types', Icons.eco_rounded, const Color(0xFF80C040)),
      ],
    );
  }

  Widget _buildAchievementTile(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    return DmCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: T1Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
