import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_routes.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/core/theme/pro_diet_theme_extension.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/dashboard_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

// Import T1 widgets (to be refactored later)
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/calorie_summary_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/hydration_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/macro_grid.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/today_meals_row.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/activity_grid.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/alerts_list.dart';

// Import T2 widgets (to be refactored later)
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/macro_ring_chart.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/water_banner.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/next_meal_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/activity_row.dart';
import 'package:prodiet_unified/shared/t2/widgets/alert_strip.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t2/widgets/calorie_stat.dart';

import 'package:prodiet_unified/core/widgets/theme_toggle.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    final isT2 = activeTheme.name.startsWith('t2');
    
    return Scaffold(
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
            onButtonTap: () => context.goNamed(isT2 ? AppRoutes.t2Meals : AppRoutes.mealsName),
          ),
          builder: (data) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardProvider),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                if (isT2) 
                  _buildT2Header(context, ref, data)
                else 
                  _buildT1Header(context),

                if (isT2) ...[
                  SliverToBoxAdapter(
                    child: CalorieStat(
                      consumed: data.caloriesConsumed,
                      burned: data.caloriesBurned,
                      net: data.netCalories,
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Divider(height: 1, thickness: 1),
                  ),
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
                ] else ...[
                  SliverToBoxAdapter(
                    child: CalorieSummaryCard(
                      caloriesConsumed: data.caloriesConsumed,
                      caloriesGoal: data.caloriesGoal,
                      streakDays: data.streakDays,
                      activePlanName: data.activeDietPlanName,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: HydrationCard(
                        consumed: data.waterMl,
                        target: data.waterGoalMl,
                        progress: data.waterProgress,
                        onAddGlass: () async {
                          // Logic should ideally move to a notifier
                          ref.invalidate(dashboardProvider);
                        },
                      ),
                    ),
                  ),
                ],

                // Macros Section
                SliverToBoxAdapter(
                  child: _AppSectionHeader(
                    title: 'Macros Today',
                    onAction: () => context.goNamed(isT2 ? AppRoutes.t2DietPlan : AppRoutes.mealsName),
                    actionLabel: isT2 ? 'Full view' : 'Full view ›',
                  ),
                ),
                SliverToBoxAdapter(
                  child: isT2 
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                      )
                    : MacroGrid(
                        calories: data.caloriesConsumed,
                        calorieProgress: data.calorieProgress,
                        protein: data.proteinConsumed,
                        proteinProgress: data.proteinProgress,
                        carbs: data.carbsConsumed,
                        carbsProgress: data.carbsProgress,
                        fat: data.fatConsumed,
                        fatProgress: data.fatProgress,
                      ),
                ),

                // Next Meal Section
                SliverToBoxAdapter(
                  child: _AppSectionHeader(
                    title: 'Next Meal',
                    onAction: () => context.goNamed(isT2 ? AppRoutes.t2Meals : AppRoutes.mealsName),
                    actionLabel: isT2 ? 'Meal plan ›' : 'Full view ›',
                  ),
                ),
                SliverToBoxAdapter(
                  child: isT2 
                    ? NextMealCard(meal: data.nextMeal)
                    : TodayMealsRow(meal: data.nextMeal),
                ),

                // Activity Section
                SliverToBoxAdapter(
                  child: _AppSectionHeader(
                    title: 'Activity · Fitband',
                    onAction: () => context.goNamed(isT2 ? AppRoutes.t2Fitband : AppRoutes.activitySyncName),
                    actionLabel: isT2 ? 'Details' : 'Full view ›',
                  ),
                ),
                SliverToBoxAdapter(
                  child: isT2 
                    ? const ActivityRow()
                    : ActivityGrid(
                        steps: data.stepsToday,
                        caloriesBurned: data.caloriesBurned,
                        netCalories: data.netCalories,
                      ),
                ),

                // Alerts / Extra
                if (isT2)
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () => context.goNamed(AppRoutes.t2Compensation),
                      child: const AlertStrip(
                        message: "Skipped snack → Dinner adjusted",
                        subMessage: "+15g protein auto-added to dinner",
                        isWarning: true,
                      ),
                    ),
                  )
                else ...[
                  const SliverToBoxAdapter(
                    child: _AppSectionHeader(title: 'Alerts'),
                  ),
                  const SliverToBoxAdapter(child: AlertsList()),
                ],

                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildT1Header(BuildContext context) {
    return const SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Dashboard'),
      actions: [
        ThemeToggle(),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildT2Header(BuildContext context, WidgetRef ref, DashboardSummary data) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).currentUser;
    final name = user?.name?.split(' ')[0] ?? 'there';
    final greeting = 'Good morning, $name';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  const Text("EAT", style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
                  Text("RIGHT.", style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: theme.colorScheme.primary, height: 1)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("CALORIES LEFT", style: TextStyle(fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  (data.caloriesGoal - data.caloriesConsumed).toString(),
                  style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, height: 1),
                ),
                const SizedBox(height: 4),
                Text('of ${data.caloriesGoal}', style: theme.textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _AppSectionHeader({required this.title, this.onAction, this.actionLabel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<ProDietThemeExtension>()!;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: ext.sectionLabelStyle,
          ),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel ?? 'Full view',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
