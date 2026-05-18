import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan_state.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan_exceptions.dart';
import 'package:prodiet_unified/features/diet_plan/presentation/widgets/adaptive_diet_plan_widgets.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dietPlanProvider);
    final tokens = context.tokens;
    final isCurved = tokens.dashboardLayout == AppDashboardLayout.curved;

    if (state is DietPlanInitial) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isCurved ? 'DIET PLAN' : 'Diet Plan'),
          centerTitle: isCurved,
        ),
        body: ProDietEmptyState(
          icon: EmptyStateConfigs.dietPlan.icon,
          headline: isCurved ? 'NO DIET PLAN YET' : 'No Diet Plan Yet',
          subtext: 'Let AI build your personalised 7-day plan based on your goals.',
          buttonLabel: isCurved ? '✨ CREATE MY PLAN' : '✨ Create My Plan',
          onButtonTap: () async {
            try {
              await ref.read(dietPlanProvider.notifier).generate();
            } on PlanRateLimitException catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.message),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
          },
        ),
      );
    }

    if (state is DietPlanLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: tokens.colors.primary),
              const SizedBox(height: 24),
              Text(
                isCurved ? 'BUILDING YOUR PLAN...' : 'Building your plan...',
                style: tokens.typography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  color: tokens.colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isCurved ? 'ANALYSING YOUR GOALS & PREFERENCES' : 'Analysing your goals & preferences',
                style: tokens.typography.bodyMedium.copyWith(
                  color: tokens.colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DietPlanError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isCurved ? 'DIET PLAN' : 'Diet Plan'),
          centerTitle: isCurved,
        ),
        body: ProDietEmptyState(
          icon: Icons.error_outline_rounded,
          headline: isCurved ? 'SOMETHING WENT WRONG' : 'Something went wrong',
          subtext: state.message,
          buttonLabel: isCurved ? 'TRY AGAIN' : 'Try Again',
          onButtonTap: () async {
            try {
              await ref.read(dietPlanProvider.notifier).generate();
            } on PlanRateLimitException catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.message),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }
          },
        ),
      );
    }

    if (state is DietPlanLoaded) {
      final plan = state.plan;
      return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: Text(isCurved ? 'YOUR DIET PLAN' : 'Your Diet Plan'),
            centerTitle: isCurved,
            actions: [
              if (isCurved)
                IconButton(
                  icon: Icon(Icons.refresh, color: tokens.colors.primary),
                  onPressed: () => _regenerate(context, ref),
                )
              else
                TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                  onPressed: () => _regenerate(context, ref),
                ),
            ],
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: tokens.colors.primary,
              labelColor: tokens.colors.primary,
              unselectedLabelColor: tokens.colors.onSurface.withValues(alpha: 0.5),
              labelStyle: tokens.typography.labelLarge.copyWith(fontWeight: FontWeight.w800),
              tabs: const [
                Tab(text: 'MON'),
                Tab(text: 'TUE'),
                Tab(text: 'WED'),
                Tab(text: 'THU'),
                Tab(text: 'FRI'),
                Tab(text: 'SAT'),
                Tab(text: 'SUN'),
              ],
            ),
          ),
          body: Column(
            children: [
              AdaptiveDietPlanSummary(plan: plan, ref: ref),
              Expanded(
                child: TabBarView(
                  children: plan.days.map((day) => AdaptiveDietPlanDayTab(day: day)).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _regenerate(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(dietPlanProvider.notifier).generate();
    } on PlanRateLimitException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }
}
