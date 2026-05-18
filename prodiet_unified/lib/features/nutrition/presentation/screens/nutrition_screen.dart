import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/nutrition/application/nutrition_providers.dart';
import 'package:prodiet_unified/features/nutrition/domain/daily_macro_summary.dart';
import 'package:prodiet_unified/features/nutrition/domain/top_food_item.dart';
import 'package:prodiet_unified/features/nutrition/presentation/widgets/adaptive_nutrition_widgets.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final summaryAsync = ref.watch(dashboardProvider.select((v) => v.whenData((s) => (
      proteinConsumed: s.proteinConsumed,
      carbsConsumed: s.carbsConsumed,
      fatConsumed: s.fatConsumed,
    ))));

    return Scaffold(
      backgroundColor: isT2 ? tokens.colors.background : null,
      appBar: AppBar(
        title: Text(isT2 ? 'INSIGHTS' : 'Nutritional Insights'),
        titleTextStyle: isT2 ? GoogleFonts.barlowCondensed(
          fontSize: 24, 
          fontWeight: FontWeight.w900, 
          color: tokens.colors.onSurface
        ) : null,
        centerTitle: isT2,
        leading: IconButton(
          icon: Icon(isT2 ? Icons.arrow_back : Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: summaryAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: tokens.colors.primary)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isT2) ...[
                Text(
                  'MACRO SPLIT',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: tokens.colors.primary,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              AdaptiveMacroSection(
                protein: summary.proteinConsumed.toDouble(),
                carbs: summary.carbsConsumed.toDouble(),
                fats: summary.fatConsumed.toDouble(),
              ),
              const SizedBox(height: 32),
              
              Text(
                'WEEKLY CALORIES',
                style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.labelSmall).copyWith(
                  color: tokens.colors.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildWeeklyChart(context, ref),
              
              const SizedBox(height: 32),
              Text(
                'TOP PROTEIN SOURCES (30 DAYS)',
                style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.labelSmall).copyWith(
                  color: tokens.colors.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildProteinSources(context, ref),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final weeklyAsync = ref.watch(weeklyMacrosProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: isT2 ? BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.05)),
      ) : BoxDecoration(
        color: tokens.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
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
                            style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 10) : tokens.typography.labelSmall).copyWith(
                              fontWeight: FontWeight.w900,
                              color: tokens.colors.onSurface.withValues(alpha: 0.3),
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
                        color: tokens.colors.primary.withValues(alpha: 0.8),
                        width: isT2 ? 20 : 16,
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
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    return AsyncValueWidget<List<TopFoodItem>>(
      value: sourcesAsync,
      isEmpty: (data) => data.isEmpty,
      emptyState: const ProDietEmptyState(
        headline: 'Log more meals',
        subtext: 'Data appears after you eat and mark meals as done.',
        icon: Icons.restaurant_menu_rounded,
      ),
      builder: (data) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: isT2 ? BoxDecoration(
          color: tokens.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.05)),
        ) : BoxDecoration(
          color: tokens.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: data.map((item) => ListTile(
            leading: const Text('🥩', style: TextStyle(fontSize: 20)),
            title: Text(
              item.name, 
              style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 16) : tokens.typography.titleSmall).copyWith(fontWeight: FontWeight.w700)
            ),
            trailing: Text(
              '${item.proteinG}g protein',
              style: (isT2 ? GoogleFonts.barlowCondensed(fontSize: 18) : tokens.typography.labelLarge).copyWith(
                color: tokens.colors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }
}
