import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final weeklyAsync = ref.watch(weeklyMealsProvider);
    final todayAsync = ref.watch(todayMealsProvider);

    final combinedAsync = weeklyAsync.whenData((weeklyMeals) {
      return todayAsync.maybeWhen(
        data: (todaySummary) {
          final otherDays = weeklyMeals.where((m) => !DateUtils.isSameDay(m.plannedDate, DateTime.now())).toList();
          return [...otherDays, ...todaySummary.meals];
        },
        orElse: () => weeklyMeals,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Planner'),
        actions: [
          IconButton(
            onPressed: () => context.push('/t1/diet-plan'),
            icon: const Icon(Icons.auto_awesome_rounded, color: Colors.orangeAccent),
          ),
        ],
      ),
      body: AsyncValueWidget<List<Meal>>(
        value: combinedAsync,
        skeleton: const Center(child: CircularProgressIndicator()),
        isEmpty: (meals) => meals.isEmpty,
        emptyState: ProDietEmptyState(
          emoji: EmptyStateConfigs.mealPlanner.emoji,
          headline: EmptyStateConfigs.mealPlanner.headline,
          subtext: EmptyStateConfigs.mealPlanner.subtext,
          buttonLabel: 'Generate AI Plan',
          onButtonTap: () => context.push('/t1/diet-plan'),
        ),
        builder: (meals) {
          final groupedMeals = _groupMealsByDay(meals);
          return ListView.separated(
            padding: const EdgeInsets.all(T1Spacing.lg),
            itemCount: 7,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index - DateTime.now().weekday + 1));
              final dayMeals = groupedMeals[DateFormat('yyyy-MM-dd').format(date)] ?? [];
              return _buildDayCard(context, theme, date, dayMeals);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/t1/today-meals'),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.list_alt_rounded, color: Colors.white),
      ),
    );
  }

  Map<String, List<Meal>> _groupMealsByDay(List<Meal> meals) {
    final Map<String, List<Meal>> grouped = {};
    for (var meal in meals) {
      final dateStr = DateFormat('yyyy-MM-dd').format(meal.plannedDate);
      grouped.putIfAbsent(dateStr, () => []).add(meal);
    }
    return grouped;
  }

  Widget _buildDayCard(BuildContext context, ThemeData theme, DateTime date, List<Meal> meals) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final totalCals = meals.fold(0.0, (sum, m) => sum + m.calories);
    
    return DmCard(
      padding: EdgeInsets.zero,
      color: isToday ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
      borderSide: isToday ? BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.3)) : null,
      child: InkWell(
        onTap: () => context.push('/t1/today-meals'), // For simplicity, go to daily view
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isToday ? theme.colorScheme.primary : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(DateFormat('E').format(date).toUpperCase(), 
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isToday ? Colors.black : Colors.white54)),
                    Text(DateFormat('dd').format(date), 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isToday ? Colors.black : Colors.white)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meals.isEmpty ? 'No meals planned' : '${meals.length} meals scheduled',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${totalCals.toInt()} kcal total',
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
            ],
          ),
        ),
      ),
    );
  }
}
