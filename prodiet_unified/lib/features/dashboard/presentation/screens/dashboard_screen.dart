import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/core/widgets/skeletons/dashboard_skeleton.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/core/design_system/components/app_section_header.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/adaptive_dashboard_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.curved;
    
    final isLoading = ref.watch(dashboardProvider.select((v) => v.isLoading && !v.hasValue));
    final hasError = ref.watch(dashboardProvider.select((v) => v.hasError));
    final isEmpty = ref.watch(dashboardProvider.select((v) {
      final d = v.asData?.value;
      if (d == null) return false;
      return d.mealsToday == 0 && d.waterMl == 0;
    }));

    if (isLoading) {
      return const Scaffold(
        body: SafeArea(top: true, child: DashboardSkeleton()),
      );
    }

    if (hasError) {
      return const Scaffold(
        body: Center(child: Text("Failed to load dashboard")),
      );
    }

    if (isEmpty) {
      return Scaffold(
        body: SafeArea(
          top: true,
          child: ProDietEmptyState(
            icon: EmptyStateConfigs.dashboard.icon,
            headline: EmptyStateConfigs.dashboard.headline,
            subtext: EmptyStateConfigs.dashboard.subtext,
            buttonLabel: EmptyStateConfigs.dashboard.buttonLabel,
            onButtonTap: () => context.go(AppRoutes.mealPlanner),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(dashboardProvider),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AdaptiveDashboardHeader(),

              const SliverToBoxAdapter(
                child: AdaptiveCalorieProgress(),
              ),
              
              if (isT2)
                SliverToBoxAdapter(
                  child: Divider(color: tokens.colors.outline.withValues(alpha: 0.1), height: 1, thickness: 1),
                ),

              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.hydration),
                  child: AdaptiveHydrationCard(
                    onAddGlass: () {
                      ref.read(dashboardProvider.notifier).addWaterLocally(250);
                    },
                  ),
                ),
              ),

              // Macros Section
              SliverToBoxAdapter(
                child: AppSectionHeader(
                  title: 'Macros Today',
                  padding: EdgeInsets.fromLTRB(tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.sm),
                  onAction: () => context.go(AppRoutes.dietPlan),
                  actionLabel: isT2 ? 'Full view' : 'Full view ›',
                ),
              ),
              const SliverToBoxAdapter(
                child: AdaptiveMacroSection(),
              ),

              // Next Meal Section
              SliverToBoxAdapter(
                child: AppSectionHeader(
                  title: 'Next Meal',
                  padding: EdgeInsets.fromLTRB(tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.sm),
                  onAction: () => context.go(AppRoutes.todayMeals),
                  actionLabel: isT2 ? 'Meal plan ›' : 'Full view ›',
                ),
              ),
              const SliverToBoxAdapter(
                child: AdaptiveMealSection(),
              ),

              // Activity Section
              SliverToBoxAdapter(
                child: AppSectionHeader(
                  title: 'Activity · Fitband',
                  padding: EdgeInsets.fromLTRB(tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.sm),
                  onAction: () => context.go(AppRoutes.activitySync),
                  actionLabel: isT2 ? 'Details' : 'Full view ›',
                ),
              ),
              const SliverToBoxAdapter(
                child: AdaptiveActivitySection(),
              ),

              // Alerts Section
              if (!isT2)
                SliverToBoxAdapter(
                  child: AppSectionHeader(
                    title: 'Alerts',
                    padding: EdgeInsets.fromLTRB(tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.lg, tokens.spacing.sm),
                  ),
                ),
              
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.notifications),
                  child: const AdaptiveAlertsSection(),
                ),
              ),

              SliverPadding(padding: EdgeInsets.only(bottom: tokens.spacing.xxl)),
            ],
          ),
        ),
      ),
    );
  }
}
