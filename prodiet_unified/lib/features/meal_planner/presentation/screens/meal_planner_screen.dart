import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/navigation/app_navigator.dart';
import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/core/widgets/skeletons/meal_planner_skeleton.dart';
import 'package:prodiet_unified/features/meal_planner/presentation/widgets/adaptive_meal_planner_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
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
        title: Text(isT2 ? 'PLANNER' : 'Weekly Planner'),
        centerTitle: isT2,
        actions: [
          IconButton(
            onPressed: () => AppNavigator.toDietPlan(context),
            icon: Icon(Icons.auto_awesome_rounded, color: isT2 ? tokens.colors.primary : Colors.orangeAccent),
          ),
        ],
      ),
      body: AsyncValueWidget<List<Meal>>(
        value: combinedAsync,
        skeleton: const MealPlannerSkeleton(),
        isEmpty: (meals) => meals.isEmpty,
        emptyState: ProDietEmptyState(
          icon: EmptyStateConfigs.mealPlanner.icon,
          headline: isT2 ? 'NO MEALS PLANNED' : EmptyStateConfigs.mealPlanner.headline,
          subtext: EmptyStateConfigs.mealPlanner.subtext,
          buttonLabel: isT2 ? 'GENERATE AI PLAN' : 'Generate AI Plan',
          onButtonTap: () => AppNavigator.toDietPlan(context),
        ),
        builder: (meals) {
          final groupedMeals = _groupMealsByDay(meals);
          
          if (isT2) {
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
                        color: tokens.colors.primary,
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
                        // T2 legacy showed last 6 days + today. 
                        // We'll stick to a forward-looking planner (Today + 6) or 
                        // make it exactly like legacy if preferred.
                        // I'll use today + 6 for consistency across themes in a "Planner".
                        final date = DateTime.now().add(Duration(days: index));
                        final dateKey = DateFormat('yyyy-MM-dd').format(date);
                        final dayMeals = groupedMeals[dateKey] ?? [];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AdaptiveDayCard(
                            date: date,
                            meals: dayMeals,
                            onTap: () => context.push(isT2 ? AppRoutes.t2DietPlan : AppRoutes.t1TodayMeals, extra: date),
                          ),
                        );
                      },
                      childCount: 7,
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 7,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final dateKey = DateFormat('yyyy-MM-dd').format(date);
              final dayMeals = groupedMeals[dateKey] ?? [];
              return AdaptiveDayCard(
                date: date,
                meals: dayMeals,
                onTap: () => context.push(AppRoutes.t1TodayMeals, extra: date),
              );
            },
          );
        },
      ),
      floatingActionButton: !isT2 
        ? FloatingActionButton(
            onPressed: () => context.push(AppRoutes.t1TodayMeals),
            backgroundColor: tokens.colors.primary,
            child: const Icon(Icons.list_alt_rounded, color: Colors.black),
          )
        : null,
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
}
