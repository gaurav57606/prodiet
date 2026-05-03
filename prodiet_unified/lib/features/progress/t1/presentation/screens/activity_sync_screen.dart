import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';

class ActivitySyncScreen extends ConsumerWidget {
  const ActivitySyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final summaryAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Sync'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AsyncValueWidget<DashboardSummary>(
        value: summaryAsync,
        builder: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(T1Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDeviceCard(context),
              const SizedBox(height: T1Spacing.lg),
              _buildStatsRow(context, summary),
              const SizedBox(height: T1Spacing.lg),
              _buildAdjustmentCard(context, summary),
              const SizedBox(height: T1Spacing.lg),
              Text(
                'WEEK ACTIVITY',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurface.withOpacity(0.25),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildActivityChart(context, summary),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context) {
    final theme = Theme.of(context);
    return DmCard(
      color: theme.colorScheme.onSurface.withOpacity(0.04),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
            ),
            child: Icon(Icons.fitness_center_rounded, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: T1Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Google Fit', style: theme.textTheme.titleMedium),
                Text(
                  'Connected and syncing calories',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF40D8B8).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF40D8B8).withOpacity(0.2)),
            ),
            child: const Text(
              'Active',
              style: TextStyle(color: Color(0xFF40D8B8), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, DashboardSummary summary) {
    return Row(
      children: [
        _buildStatTile(context, summary.stepsToday.toString(), 'STEPS', T1ColorSchemes.accentViolet),
        const SizedBox(width: T1Spacing.sm),
        _buildStatTile(context, summary.caloriesBurned.toString(), 'BURNED', T1ColorSchemes.accentPink),
        const SizedBox(width: T1Spacing.sm),
        _buildStatTile(context, '0m', 'ACTIVE', T1ColorSchemes.accentTeal), // Active minutes not in summary yet
      ],
    );
  }

  Widget _buildStatTile(BuildContext context, String value, String label, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: DmCard(
        padding: const EdgeInsets.symmetric(vertical: T1Spacing.md),
        color: color.withOpacity(0.08),
        borderSide: BorderSide(color: color.withOpacity(0.15)),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: color, fontSize: 20, fontWeight: FontWeight.w900)),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: color.withOpacity(0.4), letterSpacing: 0.4, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustmentCard(BuildContext context, DashboardSummary summary) {
    final theme = Theme.of(context);
    final teal = const Color(0xFF40D8B8);
    return DmCard(
      color: teal.withOpacity(0.08),
      borderSide: BorderSide(color: teal.withOpacity(0.15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diet adjusted for today\'s activity',
            style: theme.textTheme.titleSmall?.copyWith(color: teal, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: T1Spacing.sm),
          _buildAdjustmentRow('Extra calories allowed', '+${summary.caloriesBurned} kcal', teal),
          _buildAdjustmentRow('Net calories today', '${summary.netCalories} kcal', teal),
          _buildAdjustmentRow('Activity bonus', 'Step goal reached', teal, isLast: true),
        ],
      ),
    );
  }

  Widget _buildAdjustmentRow(String label, String value, Color color, {bool isLast = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: color.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.6))),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildActivityChart(BuildContext context, DashboardSummary summary) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    
    // Simulate some historical data based on current stats for visual variety
    final burned = [
      (summary.caloriesBurned * 0.8).toInt(),
      (summary.caloriesBurned * 1.1).toInt(),
      (summary.caloriesBurned * 0.7).toInt(),
      (summary.caloriesBurned * 1.2).toInt(),
      (summary.caloriesBurned * 0.9).toInt(),
      (summary.caloriesBurned * 1.3).toInt(),
      summary.caloriesBurned,
    ];
    
    final consumed = [
      (summary.caloriesGoal * 0.9).toInt(),
      (summary.caloriesGoal * 1.0).toInt(),
      (summary.caloriesGoal * 0.8).toInt(),
      (summary.caloriesGoal * 1.1).toInt(),
      (summary.caloriesGoal * 0.9).toInt(),
      (summary.caloriesGoal * 1.2).toInt(),
      summary.caloriesConsumed,
    ];

    const double maxH = 100;
    // Find max value across all points for scaling
    final allValues = [...burned, ...consumed];
    final maxV = allValues.reduce((a, b) => a > b ? a : b).toDouble();
    final safeMaxV = maxV > 0 ? maxV : 2000.0;

    return DmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CALORIES BURNED VS CONSUMED',
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.4),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: T1Spacing.lg),
          SizedBox(
            height: maxH + 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(days.length, (i) {
                final isToday = i == 6; // Sunday is index 6
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Consumed bar
                          Container(
                            width: 8,
                            height: (consumed[i] / safeMaxV) * maxH,
                            decoration: BoxDecoration(
                              color: T1ColorSchemes.chartConsumed.withOpacity(0.3),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 2),
                          // Burned bar
                          Container(
                            width: 8,
                            height: (burned[i] / safeMaxV) * maxH,
                            decoration: BoxDecoration(
                              color: T1ColorSchemes.chartBurned,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[i],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isToday ? scheme.primary : scheme.onSurface.withOpacity(0.3),
                          fontWeight: isToday ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: T1Spacing.md),
          Row(
            children: [
              _buildLegendItem(context, 'Consumed', T1ColorSchemes.chartConsumed.withOpacity(0.4)),
              const SizedBox(width: T1Spacing.md),
              _buildLegendItem(context, 'Burned', T1ColorSchemes.chartBurned),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withOpacity(0.5))),
      ],
    );
  }
}
