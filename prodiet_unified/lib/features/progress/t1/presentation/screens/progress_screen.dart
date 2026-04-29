import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/progress/application/progress_providers.dart';
import 'package:prodiet_unified/features/progress/domain/progress_summary.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(progressSummaryProvider);
    final selectedRange = ref.watch(selectedRangeProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(progressSummaryProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: AsyncValueWidget<ProgressSummary>(
        value: summaryAsync,
        isEmpty: (s) => s.entries.isEmpty,
        emptyState: ProDietEmptyState(
          emoji: EmptyStateConfigs.progress.emoji,
          headline: 'No progress logged yet',
          subtext: 'Log your first weight to start tracking your journey.',
          buttonLabel: 'Log Weight',
          onButtonTap: () => _showLogWeightSheet(context, ref, userId),
        ),
        builder: (summary) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(progressSummaryProvider),
          child: ListView(
            padding: const EdgeInsets.all(T1Spacing.lg),
            children: [
              _buildStatsRow(theme, summary),
              const SizedBox(height: T1Spacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEIGHT HISTORY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  _buildRangeSelector(ref, selectedRange),
                ],
              ),
              const SizedBox(height: T1Spacing.md),
              _buildWeightChart(context, summary),
              const SizedBox(height: T1Spacing.xl),
              if (summary.streakDays > 0) _buildStreakBadge(theme, summary.streakDays),
              const SizedBox(height: T1Spacing.xl),
              Text(
                'ACHIEVEMENTS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildAchievementList(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogWeightSheet(context, ref, userId),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('LOG WEIGHT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Widget _buildRangeSelector(WidgetRef ref, int selected) {
    return Row(
      children: [7, 14, 30].map((days) => Padding(
        padding: const EdgeInsets.only(left: 8),
        child: InkWell(
          onTap: () => ref.read(selectedRangeProvider.notifier).state = days,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: selected == days ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${days}d', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: selected == days ? Colors.white : Colors.white30)),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildStatsRow(ThemeData theme, ProgressSummary summary) {
    return Row(
      children: [
        Expanded(child: _buildMetricCard(theme, 'CURRENT', summary.currentWeightKg.toString(), 'kg', theme.colorScheme.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildMetricCard(theme, 'CHANGE', (summary.totalChange > 0 ? '+' : '') + summary.totalChange.toStringAsFixed(1), 'kg', summary.isGoingRight ? const Color(0xFF40D8B8) : Colors.orangeAccent)),
        const SizedBox(width: 12),
        Expanded(child: _buildMetricCard(theme, 'GOAL', summary.remainingToGoal.abs().toStringAsFixed(1), 'to go', Colors.white.withValues(alpha: 0.5))),
      ],
    );
  }

  Widget _buildMetricCard(ThemeData theme, String label, String value, String unit, Color color) {
    return DmCard(
      color: color.withValues(alpha: 0.08),
      borderSide: BorderSide(color: color.withValues(alpha: 0.15)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: color.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: color)),
              const SizedBox(width: 2),
              Text(unit, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: color.withValues(alpha: 0.3))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBadge(ThemeData theme, int days) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orangeAccent.withValues(alpha: 0.1), Colors.redAccent.withValues(alpha: 0.1)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$days DAY STREAK', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.orangeAccent)),
              const Text('You are consistently tracking your progress!', style: TextStyle(fontSize: 10, color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart(BuildContext context, ProgressSummary summary) {
    final theme = Theme.of(context);
    if (summary.entries.isEmpty) return const SizedBox.shrink();

    final spots = summary.entries.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.weightKg);
    }).toList();

    // Determine interval for labels
    final interval = (summary.entries.length / 4).ceil().toDouble();

    return DmCard(
      padding: const EdgeInsets.only(top: 24, right: 24, bottom: 12, left: 12),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval > 0 ? interval : 1,
                  getTitlesWidget: (val, meta) {
                    final index = val.toInt();
                    if (index < 0 || index >= summary.entries.length) return const SizedBox.shrink();
                    final date = summary.entries[index].loggedAt;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(DateFormat('dd/MM').format(date), style: const TextStyle(fontSize: 8, color: Colors.white30, fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: const TextStyle(fontSize: 8, color: Colors.white30, fontWeight: FontWeight.bold)),
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: theme.colorScheme.primary,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [theme.colorScheme.primary.withValues(alpha: 0.3), Colors.transparent],
                  ),
                ),
              ),
            ],
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: summary.targetWeightKg,
                  color: Colors.white.withValues(alpha: 0.1),
                  strokeWidth: 2,
                  dashArray: [5, 5],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    style: const TextStyle(fontSize: 8, color: Colors.white30, fontWeight: FontWeight.bold),
                    labelResolver: (_) => 'GOAL ${summary.targetWeightKg}kg',
                  ),
                ),
              ],
            ),
          ),
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

  void _showLogWeightSheet(BuildContext context, WidgetRef ref, String userId) {
    final weightController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('LOG YOUR WEIGHT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Step on the scale and enter your current weight.', style: TextStyle(fontSize: 12, color: Colors.white30)),
            const SizedBox(height: 24),
            TextField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                suffixText: 'kg',
                suffixStyle: const TextStyle(fontSize: 16, color: Colors.white30),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (weightController.text.isEmpty) return;
                  final weight = double.tryParse(weightController.text);
                  if (weight == null) return;
                  
                  await ref.read(progressRepositoryProvider).logWeight(userId, weight);
                  ref.invalidate(progressSummaryProvider);
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4C84FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('CONFIRM LOG', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
