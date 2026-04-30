import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyMealsProvider);
    final todayAsync = ref.watch(todayMealsProvider);

    final combinedAsync = weeklyAsync.whenData((weeklyMeals) {
      return todayAsync.maybeWhen(
        data: (todaySummary) {
          // Remove any entries from history that match "today" to avoid duplicates
          final otherDays = weeklyMeals.where((m) => !DateUtils.isSameDay(m.plannedDate, DateTime.now())).toList();
          return [...otherDays, ...todaySummary.meals];
        },
        orElse: () => weeklyMeals,
      );
    });

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AsyncValueWidget<List<Meal>>(
        value: combinedAsync,
        skeleton: const Center(child: CircularProgressIndicator(color: T2Colors.lime)),
        isEmpty: (meals) => meals.isEmpty,
        emptyState: ProDietEmptyState(
          emoji: EmptyStateConfigs.mealPlanner.emoji,
          headline: EmptyStateConfigs.mealPlanner.headline,
          subtext: EmptyStateConfigs.mealPlanner.subtext,
          buttonLabel: 'GENERATE AI PLAN',
          onButtonTap: () => Navigator.of(context).pushNamed('/t2/diet-plan'),
        ),
        builder: (meals) {
          final groupedMeals = _groupMealsByDay(meals);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'WEEKLY PLAN',
                    style: GoogleFonts.barlowCondensed(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: T2Colors.lime,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Show last 6 days + today
                      final date = DateTime.now().subtract(Duration(days: 6 - index));
                      final dateKey = DateFormat('yyyy-MM-dd').format(date);
                      final dayMeals = groupedMeals[dateKey] ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildWeeklyDayCard(context, date, dayMeals),
                      );
                    },
                    childCount: 7,
                  ),
                ),
              ),
            ],
          );
        },
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

  Widget _buildWeeklyDayCard(BuildContext context, DateTime date, List<Meal> meals) {
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final totalCals = meals.fold(0.0, (sum, m) => sum + m.calories);
    
    return Container(
      decoration: BoxDecoration(
        color: isToday ? T2Colors.lime.withValues(alpha: 0.1) : T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isToday ? T2Colors.lime : T2Colors.border),
      ),
      child: ListTile(
        onTap: () => context.push(AppRoutes.t1TodayMeals),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date).toUpperCase(),
              style: GoogleFonts.barlowCondensed(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isToday ? T2Colors.lime : T2Colors.textMuted,
              ),
            ),
            Text(
              DateFormat('dd').format(date),
              style: GoogleFonts.barlowCondensed(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        title: Text(
          meals.isEmpty ? 'REST DAY' : '${meals.length} MEALS SCHEDULED',
          style: GoogleFonts.barlowCondensed(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '${totalCals.toInt()} KCAL PLANNED',
          style: TextStyle(
            color: T2Colors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: T2Colors.border, size: 16),
      ),
    );
  }
}
