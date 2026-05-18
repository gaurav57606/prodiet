import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';

// Unified Components
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_calorie_section.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_hydration_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_macro_section.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_meal_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_activity_section.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/alerts_list.dart';
import 'package:prodiet_unified/shared/presentation/widgets/unified_alert_strip.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_dashboard_header.dart';

class AdaptiveDashboardHeader extends StatelessWidget {
  const AdaptiveDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const UnifiedDashboardHeader();
  }
}

class AdaptiveCalorieProgress extends ConsumerWidget {
  const AdaptiveCalorieProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calorieData = ref.watch(dashboardProvider.select((v) {
      final s = v.value;
      if (s == null) return null;
      return (
        s.caloriesConsumed,
        s.caloriesGoal,
        s.caloriesBurned,
        s.netCalories,
        s.streakDays,
        s.activeDietPlanName,
      );
    }));
    
    return UnifiedCalorieSection(
      consumed: calorieData?.$1 ?? 0,
      goal: calorieData?.$2 ?? 2000,
      burned: calorieData?.$3 ?? 0,
      net: calorieData?.$4 ?? 0,
      streak: calorieData?.$5 ?? 0,
      planName: calorieData?.$6,
    );
  }
}

class AdaptiveHydrationCard extends ConsumerWidget {
  final VoidCallback onAddGlass;
  const AdaptiveHydrationCard({super.key, required this.onAddGlass});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hydrationData = ref.watch(dashboardProvider.select((v) {
      final s = v.value;
      if (s == null) return null;
      return (
        s.waterMl,
        s.waterGoalMl,
        s.waterProgress,
      );
    }));
    
    return UnifiedHydrationCard(
      consumed: hydrationData?.$1 ?? 0,
      target: hydrationData?.$2 ?? 2000,
      progress: hydrationData?.$3 ?? 0.0,
      onAddGlass: onAddGlass,
    );
  }
}

class AdaptiveMacroSection extends ConsumerWidget {
  const AdaptiveMacroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final macroData = ref.watch(dashboardProvider.select((v) {
      final s = v.value;
      if (s == null) return null;
      return (
        s.caloriesConsumed,
        s.calorieProgress,
        s.proteinConsumed,
        s.proteinProgress,
        s.carbsConsumed,
        s.carbsProgress,
        s.fatConsumed,
        s.fatProgress,
      );
    }));
    
    return UnifiedMacroSection(
      calories: macroData?.$1 ?? 0,
      calorieProgress: macroData?.$2 ?? 0.0,
      protein: macroData?.$3 ?? 0,
      proteinProgress: macroData?.$4 ?? 0.0,
      carbs: macroData?.$5 ?? 0,
      carbsProgress: macroData?.$6 ?? 0.0,
      fat: macroData?.$7 ?? 0,
      fatProgress: macroData?.$8 ?? 0.0,
    );
  }
}

class AdaptiveActivitySection extends ConsumerWidget {
  const AdaptiveActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityData = ref.watch(dashboardProvider.select((v) {
      final s = v.value;
      if (s == null) return null;
      return (
        s.stepsToday,
        s.caloriesBurned,
        s.netCalories,
      );
    }));
    
    return UnifiedActivitySection(
      steps: activityData?.$1 ?? 0,
      burned: activityData?.$2 ?? 0,
      net: activityData?.$3 ?? 0,
    );
  }
}

class AdaptiveMealSection extends ConsumerWidget {
  const AdaptiveMealSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nextMeal = ref.watch(dashboardProvider.select((v) => v.value?.nextMeal));
    return UnifiedMealCard(meal: nextMeal);
  }
}

class AdaptiveAlertsSection extends ConsumerWidget {
  const AdaptiveAlertsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return const UnifiedAlertStrip(
        message: 'Snack skipped · Dinner adjusted',
        subMessage: '+15g protein added to dinner tonight',
        isWarning: true,
      );
    }
    return const AlertsList();
  }
}
