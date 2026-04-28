import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/router/app_router.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_text_styles.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/calorie_summary_card.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/hydration_card.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/macro_grid.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/today_meals_row.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/activity_grid.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/alerts_list.dart';
import 'package:prodiet_unified/core/widgets/theme_toggle.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      body: SafeArea(
        top: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: const [
                ThemeToggle(),
                SizedBox(width: 8),
              ],
            ),
            
            dashboardAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(T1Spacing.xl),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(T1Spacing.lg),
                  child: Text('Error loading dashboard: $err'),
                ),
              ),
              data: (summary) => SliverMainAxisGroup(
                slivers: [
                  SliverToBoxAdapter(
                    child: CalorieSummaryCard(
                      caloriesConsumed: summary.caloriesConsumed,
                      caloriesGoal: summary.caloriesGoal,
                      streakDays: summary.streakDays,
                      activePlanName: summary.activeDietPlanName,
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg),
                      child: HydrationCard(
                        consumed: summary.waterMl,
                        target: summary.waterGoalMl,
                        progress: summary.waterProgress,
                      ),
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                      child: _SectionHeader(
                        title: 'Macros Today',
                        onAction: () => context.go('/meals'),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: MacroGrid(
                      calories: summary.caloriesConsumed,
                      calorieProgress: summary.calorieProgress,
                      protein: summary.proteinConsumed,
                      proteinProgress: summary.proteinProgress,
                      carbs: summary.carbsConsumed,
                      carbsProgress: summary.carbsProgress,
                      fat: summary.fatConsumed,
                      fatProgress: summary.fatProgress,
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                      child: _SectionHeader(
                        title: 'Next Meal',
                        onAction: () => context.go('/meals'),
                      ),
                    ),
                  ),
                  
                  SliverToBoxAdapter(child: TodayMealsRow(meal: summary.nextMeal)),
                  
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
                      steps: summary.stepsToday,
                      caloriesBurned: summary.caloriesBurned,
                      netCalories: summary.netCalories,
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: T1Spacing.lg, vertical: T1Spacing.sm),
                      child: _SectionHeader(
                        title: 'Alerts',
                      ),
                    ),
                  ),
                  
                  const SliverToBoxAdapter(child: AlertsList()),
                ],
              ),
            ),
            
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
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
