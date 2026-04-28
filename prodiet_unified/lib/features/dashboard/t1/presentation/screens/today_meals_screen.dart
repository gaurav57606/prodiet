import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class TodayMealsScreen extends ConsumerWidget {
  const TodayMealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mealsAsync = ref.watch(todayMealsProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Meals'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (summary) => mealsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (meals) => ListView(
            padding: const EdgeInsets.all(T1Spacing.lg),
            children: [
              _buildSummaryHeader(theme, summary),
              const SizedBox(height: T1Spacing.xl),
              Text(
                'LOGGED MEALS',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              if (meals.isEmpty)
                _buildEmptyState(theme)
              else
                ...meals.map((meal) {
                  final accentColor = _getMealColor(meal.mealType);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildMealCard(theme, meal, accentColor),
                  );
                }),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/t1/meal-planner'),
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('LOG MEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
      ),
    );
  }

  Color _getMealColor(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast': return const Color(0xFFC080FF);
      case 'lunch': return const Color(0xFFFF8C64);
      case 'snack': return const Color(0xFF40D8B8);
      case 'dinner': return const Color(0xFF4C84FF);
      default: return const Color(0xFF94A3B8);
    }
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.restaurant_rounded, size: 48, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            const SizedBox(height: 16),
            Text('No meals logged today', 
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme, dynamic summary) {
    return DmCard(
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryStat(theme, 'TOTAL KCAL', '${summary.caloriesConsumed}', theme.colorScheme.primary),
          _buildSummaryStat(theme, 'REMAINING', '${(summary.caloriesGoal - summary.caloriesConsumed).clamp(0, 9999)}', const Color(0xFF40D8B8)),
          _buildSummaryStat(theme, 'MEALS', '${summary.mealsLogged}/${summary.mealsScheduled}', Colors.white.withValues(alpha: 0.5)),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(ThemeData theme, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(ThemeData theme, Meal meal, Color accentColor) {
    final timeStr = DateFormat('hh:mm a').format(meal.scheduledTime);
    
    return DmCard(
      padding: EdgeInsets.zero,
      color: accentColor.withValues(alpha: 0.06),
      borderSide: BorderSide(color: accentColor.withValues(alpha: 0.15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${meal.mealType.toUpperCase()} · $timeStr',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: accentColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meal.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${meal.nutritionalValues.calories} kcal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroItem(theme, 'PROT', '${meal.nutritionalValues.proteinG}g'),
                _buildMacroItem(theme, 'CARB', '${meal.nutritionalValues.carbsG}g'),
                _buildMacroItem(theme, 'FAT', '${meal.nutritionalValues.fatG}g'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(ThemeData theme, String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
