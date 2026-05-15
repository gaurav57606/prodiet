import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/font_config.dart';
import 'package:prodiet_unified/core/router/app_routes.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/macro_ring_chart.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/water_banner.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/next_meal_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/activity_row.dart';
import 'package:prodiet_unified/shared/t2/widgets/alert_strip.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/calorie_stat.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/dashboard_components.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/dashboard_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;
    final user = ref.watch(authProvider).currentUser;
    final name = user?.name?.split(' ')[0] ?? 'there';
    final greeting = 'Good morning, $name';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "EAT",
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 56, 
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              "RIGHT.",
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 56, 
                                color: ext.macroCalories,
                              ),
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
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (data.caloriesGoal - data.caloriesConsumed).toString(),
                            style: AppFonts.barlowCondensed(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              color: ext.macroCalories,
                              letterSpacing: -1.5,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'of ${data.caloriesGoal}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: AppSectionHeader(
                    title: "MACROS TODAY",
                    onAction: () => context.goNamed(AppRoutes.t2DietPlan),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: AppSectionHeader(
                    title: "NEXT MEAL",
                    actionLabel: "Meal plan ›",
                    onAction: () => context.goNamed(AppRoutes.t2Meals),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(
                child: NextMealCard(meal: data.nextMeal),
              ),

              // Activity Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: AppSectionHeader(
                    title: "ACTIVITY · FITBAND",
                    actionLabel: "Details",
                    onAction: () => context.goNamed(AppRoutes.t2Fitband),
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



