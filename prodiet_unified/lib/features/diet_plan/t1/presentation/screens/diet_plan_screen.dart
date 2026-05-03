import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/core/theme/t1/t1_text_styles.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan_state.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dietPlanProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (state is DietPlanInitial) {
      return Scaffold(
        appBar: AppBar(title: const Text('Diet Plan')),
        body: ProDietEmptyState(
          emoji: '🥗',
          headline: 'No Diet Plan Yet',
          subtext: 'Let AI build your personalised 7-day plan based on your goals.',
          buttonLabel: '✨ Create My Plan',
          onButtonTap: () => ref.read(dietPlanProvider.notifier).generate(),
        ),
      );
    }

    if (state is DietPlanLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: scheme.primary),
              const SizedBox(height: 24),
              Text('Building your plan...', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Analysing your goals & preferences',
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DietPlanError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Diet Plan')),
        body: ProDietEmptyState(
          emoji: '⚠️',
          headline: 'Something went wrong',
          subtext: state.message,
          buttonLabel: 'Try Again',
          onButtonTap: () => ref.read(dietPlanProvider.notifier).generate(),
        ),
      );
    }

    if (state is DietPlanLoaded) {
      final plan = state.plan;
      return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Your Diet Plan'),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Regenerate'),
                onPressed: () => ref.read(dietPlanProvider.notifier).generate(),
              ),
            ],
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Mon'),
                Tab(text: 'Tue'),
                Tab(text: 'Wed'),
                Tab(text: 'Thu'),
                Tab(text: 'Fri'),
                Tab(text: 'Sat'),
                Tab(text: 'Sun'),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildSummaryCard(context, ref, plan),
              Expanded(
                child: TabBarView(
                  children: plan.days.map((day) => _buildDayTab(context, day)).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSummaryCard(BuildContext context, WidgetRef ref, DietPlan plan) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(T1Spacing.lg),
      padding: const EdgeInsets.all(T1Spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip(context, '${plan.summaryCalories.toInt()} kcal/day'),
                const SizedBox(width: 8),
                _buildChip(context, 'P ${plan.summaryProteinG.toInt()}g'),
                const SizedBox(width: 8),
                _buildChip(context, 'C ${plan.summaryCarbsG.toInt()}g'),
                const SizedBox(width: 8),
                _buildChip(context, 'F ${plan.summaryFatG.toInt()}g'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: () async {
                await ref.read(dietPlanProvider.notifier).saveTodayMeals();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Today\'s meals added ✅')),
                  );
                }
              },
              child: const Text('Add Today\'s Meals to Log'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDayTab(BuildContext context, DietDay day) {
    return ListView(
      padding: const EdgeInsets.all(T1Spacing.lg),
      children: [
        _buildMealSection(context, 'Breakfast', day.breakfast),
        _buildMealSection(context, 'Lunch', day.lunch),
        _buildMealSection(context, 'Dinner', day.dinner),
        _buildMealSection(context, 'Snacks', day.snacks),
      ],
    );
  }

  Widget _buildMealSection(BuildContext context, String title, List<DietMeal> meals) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final totalCals = meals.fold(0.0, (sum, m) => sum + m.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: T1Spacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: T1TextStyleExtensions.sectionLabel(scheme),
              ),
              Text(
                '${totalCals.toInt()} kcal',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...meals.map((meal) => _buildMealTile(context, meal)),
        const SizedBox(height: T1Spacing.md),
      ],
    );
  }

  Widget _buildMealTile(BuildContext context, DietMeal meal) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          onTap: () => context.goNamed(AppRoutes.t1DietPlanDetail, extra: meal),
          title: Text(meal.name, style: const TextStyle(fontWeight: FontWeight.w900)),
          subtitle: Text(
            '${meal.calories.toInt()} kcal  •  P${meal.proteinG.toInt()}g C${meal.carbsG.toInt()}g F${meal.fatG.toInt()}g',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.2)),
        ),
      ),
    );
  }

  void _showIngredients(BuildContext context, DietMeal meal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(T1Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients for ${meal.name}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: T1Spacing.md),
            ...meal.ingredients.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(child: Text(ing)),
                    ],
                  ),
                )),
            const SizedBox(height: T1Spacing.lg),
          ],
        ),
      ),
    );
  }
}
