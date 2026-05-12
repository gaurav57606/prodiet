import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/nutrition/application/nutrition_providers.dart';
import 'package:prodiet_unified/features/nutrition/domain/daily_macro_summary.dart';
import 'package:prodiet_unified/features/nutrition/domain/top_food_item.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_macro_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nutritional Insights')),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(T1Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMacroSection(context, summary),
              const SizedBox(height: T1Spacing.xl),
              
              Text(
                'WEEKLY CALORIES',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildWeeklyChart(context, ref),
              
              const SizedBox(height: T1Spacing.xl),
              Text(
                'TOP PROTEIN SOURCES (30 DAYS)',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildProteinSources(context, ref),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroSection(BuildContext context, dynamic summary) {
    return DmCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DmMacroChip(value: '${summary.proteinConsumed}g', label: 'Protein', type: MacroType.protein, large: true),
              DmMacroChip(value: '${summary.carbsConsumed}g', label: 'Carbs', type: MacroType.carbs, large: true),
              DmMacroChip(value: '${summary.fatConsumed}g', label: 'Fats', type: MacroType.fat, large: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyAsync = ref.watch(weeklyMacrosProvider);

    return DmCard(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: SizedBox(
        height: 200,
        child: AsyncValueWidget<List<DailyMacroSummary>>(
          value: weeklyAsync,
          builder: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('No meal data for the last 7 days.'));
            }
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (data.map((e) => e.calories).reduce((a, b) => a > b ? a : b) * 1.2).toDouble(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= data.length) return const SizedBox.shrink();
                        final date = DateTime.parse(data[index].date);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('EEE').format(date).toUpperCase(),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: data.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.calories.toDouble(),
                        color: theme.colorScheme.primary.withValues(alpha: 0.8),
                        width: 16,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProteinSources(BuildContext context, WidgetRef ref) {
    final sourcesAsync = ref.watch(topProteinSourcesProvider);

    return AsyncValueWidget<List<TopFoodItem>>(
      value: sourcesAsync,
      isEmpty: (data) => data.isEmpty,
      emptyState: const DmEmptyState(
        title: 'Log more meals',
        message: 'Data appears after you eat and mark meals as done.',
        icon: Icons.restaurant_menu_rounded,
      ),
      builder: (data) => DmCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: data.map((item) => ListTile(
            leading: const Text('🥩', style: TextStyle(fontSize: 20)),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            trailing: Text(
              '${item.proteinG}g protein',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }
}

