import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_routes.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_text_styles.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/calorie_summary_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/hydration_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/macro_grid.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/today_meals_row.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/activity_grid.dart';
import 'package:prodiet_unified/features/dashboard/presentation/t1/widgets/alerts_list.dart';
import 'package:prodiet_unified/core/widgets/theme_toggle.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/skeletons/dashboard_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

import 'package:prodiet_unified/features/water/application/water_providers.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated) {
        ref.read(analyticsServiceProvider)
            .logScreen(authState.user.id, 't1_dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Removed greeting to match original T1

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
            onButtonTap: () => context.goNamed(AppRoutes.mealsName),
          ),
          builder: (data) => RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardProvider),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text('Dashboard'),
                  actions: [
                    ThemeToggle(),
                    SizedBox(width: 8),
                  ],
                ),
                
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
                    padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
                    child: HydrationCard(
                      consumed: data.waterMl,
                      target: data.waterGoalMl,
                      progress: data.waterProgress,
                      onAddGlass: () async {
                        final userId = ref.read(currentUserProvider)?.id;
                        if (userId != null) {
                          await ref.read(waterRepositoryProvider).logGlass(userId);
                          ref.invalidate(dashboardProvider);
                        }
                      },
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                    child: _SectionHeader(
                      title: 'Macros Today',
                      onAction: () => context.goNamed(AppRoutes.mealsName),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: MacroGrid(
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
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                    child: _SectionHeader(
                      title: 'Next Meal',
                      onAction: () => context.goNamed(AppRoutes.mealsName),
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(child: TodayMealsRow(meal: data.nextMeal)),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                    child: _SectionHeader(
                      title: 'Activity · Fitband',
                      onAction: () => context.pushNamed(AppRoutes.activitySyncName),
                    ),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: ActivityGrid(
                    steps: data.stepsToday,
                    caloriesBurned: data.caloriesBurned,
                    netCalories: data.netCalories,
                  ),
                ),
                
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                    child: _SectionHeader(
                      title: 'Alerts',
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: AlertsList()),
                
                const SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: T1TextStyleExtensions.sectionLabel(scheme),
        ),
        if (onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              'Full view ›',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}



