import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_colors.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class ActivitySyncScreen extends StatelessWidget {
  const ActivitySyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Sync'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(T1Spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceCard(context),
            const SizedBox(height: T1Spacing.lg),
            _buildStatsRow(context),
            const SizedBox(height: T1Spacing.lg),
            _buildAdjustmentCard(context),
            const SizedBox(height: T1Spacing.lg),
            Text(
              'WEEK ACTIVITY',
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurface.withOpacity(0.25),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: T1Spacing.md),
            _buildActivityChart(context),
            const SizedBox(height: 100),
          ],
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
            child: Icon(Icons.watch_rounded, color: theme.colorScheme.primary, size: 22),
          ),
          const SizedBox(width: T1Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mi Band 8', style: theme.textTheme.titleMedium),
                Text(
                  'Last synced: 2 min ago · Battery 78%',
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
              'Connected',
              style: TextStyle(color: Color(0xFF40D8B8), fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        _buildStatTile(context, '4,820', 'STEPS', T1ColorSchemes.accentViolet),
        const SizedBox(width: T1Spacing.sm),
        _buildStatTile(context, '312', 'BURNED', T1ColorSchemes.accentPink),
        const SizedBox(width: T1Spacing.sm),
        _buildStatTile(context, '48m', 'ACTIVE', T1ColorSchemes.accentTeal),
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
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(color: color, fontSize: 20)),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: color.withOpacity(0.4), letterSpacing: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustmentCard(BuildContext context) {
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
            style: theme.textTheme.titleSmall?.copyWith(color: teal),
          ),
          const SizedBox(height: T1Spacing.sm),
          _buildAdjustmentRow('Extra calories allowed', '+312 kcal', teal),
          _buildAdjustmentRow('Protein target', '+12g (162g total)', teal),
          _buildAdjustmentRow('Hydration target', '+500ml (3.0L)', teal),
          _buildAdjustmentRow('Post-workout window', 'Eat within 45m', teal, isLast: true),
        ],
      ),
    );
  }

  Widget _buildAdjustmentRow(String label, String value, Color color, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: color.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
          Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildActivityChart(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final burned = [32, 42, 28, 46, 38, 48, 30];
    final consumed = [40, 44, 38, 40, 46, 40, 38];
    const double maxH = 100;
    final maxV = [32, 42, 28, 46, 38, 48, 30, 40, 44, 38, 40, 46, 40, 38].reduce((a, b) => a > b ? a : b).toDouble();

    return DmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CALORIES BURNED VS CONSUMED',
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.4),
              letterSpacing: 0.8,
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
                          // Consumed bar (Brown/Gold)
                          Container(
                            width: 8,
                            height: (consumed[i] / maxV) * maxH,
                            decoration: BoxDecoration(
                              color: T1ColorSchemes.chartConsumed.withOpacity(0.3),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 2),
                          // Burned bar (Teal)
                          Container(
                            width: 8,
                            height: (burned[i] / maxV) * maxH,
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
              _buildLegendItem('Consumed', T1ColorSchemes.chartConsumed.withOpacity(0.4)),
              const SizedBox(width: T1Spacing.md),
              _buildLegendItem('Burned', T1ColorSchemes.chartBurned),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
      ],
    );
  }
}
