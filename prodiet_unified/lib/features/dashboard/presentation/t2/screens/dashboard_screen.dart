import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/font_config.dart';
import 'package:prodiet_unified/core/router/app_routes.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/macro_ring_chart.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/water_banner.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/next_meal_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/activity_row.dart';
import 'package:prodiet_unified/shared/t2/widgets/alert_strip.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/calorie_stat.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/dashboard_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authProvider).currentUser;
    final name = user?.name?.split(' ')[0] ?? 'there';
    final greeting = 'Good morning, $name'; // Reverted to match original T2

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      body: SafeArea(
        top: true,
        child: AsyncValueWidget<DashboardSummary>(
          value: ref.watch(dashboardProvider),
          skeleton: const DashboardSkeleton(),
          isEmpty: (data) => data.mealsToday == 0 && data.waterMl == 0,
          emptyState: ProDietEmptyState(
            icon: EmptyStateConfigs.dashboard.icon,
            headline: EmptyStateConfigs.dashboard.headline,
            subtext: EmptyStateConfigs.dashboard.subtext,
            buttonLabel: EmptyStateConfigs.dashboard.buttonLabel,
            onButtonTap: () => context.goNamed(AppRoutes.t2Meals),
          ),
          builder: (data) => CustomScrollView(
            slivers: [
              // Static Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: T2Colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "EAT",
                              style: theme.textTheme.displayLarge?.copyWith(fontSize: 56, color: Colors.white),
                            ),
                            Text(
                              "RIGHT.",
                              style: theme.textTheme.displayLarge?.copyWith(fontSize: 56, color: T2Colors.lime),
                            ),
                          ],
                        ),
                      ),
                      // Right Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "CALORIES LEFT",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: T2Colors.textSecondary,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (data.caloriesGoal - data.caloriesConsumed).toString(),
                            style: AppFonts.barlowCondensed(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: T2Colors.lime,
                              letterSpacing: -1.5,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'of ${data.caloriesGoal}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: T2Colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Calorie Stat Bar
              SliverToBoxAdapter(
                child: CalorieStat(
                  consumed: data.caloriesConsumed,
                  burned: data.caloriesBurned,
                  net: data.netCalories,
                ),
              ),

              // Divider
              const SliverToBoxAdapter(
                child: Divider(color: T2Colors.border, height: 1, thickness: 1),
              ),

              // Water Banner
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.t2Water),
                  child: WaterBanner(
                    consumed: data.waterMl,
                    target: data.waterGoalMl,
                    progress: data.waterProgress,
                  ),
                ),
              ),
              
              // Macros Today Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(T2Spacing.lg, T2Spacing.lg, T2Spacing.lg, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "MACROS TODAY",
                        style: T2TextStyles.sectionLabel(colorScheme),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(AppRoutes.t2DietPlan),
                        child: Text(
                          "Full view",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(T2Spacing.lg, T2Spacing.md, T2Spacing.lg, T2Spacing.md),
                  child: MacroRingChart(
                    calorieProgress: data.calorieProgress,
                    calories: data.caloriesConsumed,
                    proteinProgress: data.proteinProgress,
                    protein: data.proteinConsumed,
                    carbsProgress: data.carbsProgress,
                    carbs: data.carbsConsumed,
                    fatProgress: data.fatProgress,
                    fat: data.fatConsumed,
                  ),
                ),
              ),

              // Next Meal Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: T2Spacing.lg, vertical: T2Spacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NEXT MEAL",
                        style: T2TextStyles.sectionLabel(colorScheme),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(AppRoutes.t2Meals),
                        child: Text(
                          "Meal plan ›",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: NextMealCard(meal: data.nextMeal),
              ),

              // Activity Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: T2Spacing.lg, vertical: T2Spacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ACTIVITY · FITBAND",
                        style: T2TextStyles.sectionLabel(colorScheme),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed(AppRoutes.t2Fitband),
                        child: Text(
                          "Details",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(
                child: ActivityRow(),
              ),

              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.t2Compensation),
                  child: const AlertStrip(
                    message: "Skipped snack → Dinner adjusted",
                    subMessage: "+15g protein auto-added to dinner",
                    isWarning: true,
                  ),
                ),
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        ),
      ),
    );
  }
}



