import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AdaptiveDietPlanSummary extends StatelessWidget {
  final DietPlan plan;
  final WidgetRef ref;
  const AdaptiveDietPlanSummary({super.key, required this.plan, required this.ref});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: tokens.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildT2Stat(context, plan.summaryCalories.toInt().toString(), 'KCAL'),
                _buildT2Stat(context, plan.summaryProteinG.toInt().toString(), 'PROT'),
                _buildT2Stat(context, plan.summaryCarbsG.toInt().toString(), 'CARB'),
                _buildT2Stat(context, plan.summaryFatG.toInt().toString(), 'FAT'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await ref.read(dietPlanProvider.notifier).saveTodayMeals();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Today\'s meals added ✅')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: tokens.colors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'ADD TODAY\'S MEALS TO LOG',
                  style: tokens.typography.labelLarge.copyWith(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: tokens.gradients.hero,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: tokens.colors.primary.withValues(alpha: 0.3),
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
                _buildT1Chip(context, '${plan.summaryCalories.toInt()} kcal/day'),
                const SizedBox(width: 8),
                _buildT1Chip(context, 'P ${plan.summaryProteinG.toInt()}g'),
                const SizedBox(width: 8),
                _buildT1Chip(context, 'C ${plan.summaryCarbsG.toInt()}g'),
                const SizedBox(width: 8),
                _buildT1Chip(context, 'F ${plan.summaryFatG.toInt()}g'),
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

  Widget _buildT2Stat(BuildContext context, String value, String label) {
    final tokens = context.tokens;
    return Column(
      children: [
        Text(
          value,
          style: tokens.typography.displaySmall.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: tokens.colors.onSurface,
          ),
        ),
        Text(
          label,
          style: tokens.typography.labelSmall.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: tokens.colors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildT1Chip(BuildContext context, String label) {
    final tokens = context.tokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tokens.colors.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: tokens.typography.labelSmall.copyWith(
          color: tokens.colors.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class AdaptiveDietPlanDayTab extends StatelessWidget {
  final DietDay day;
  const AdaptiveDietPlanDayTab({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildMealSection(context, 'BREAKFAST', day.breakfast),
        _buildMealSection(context, 'LUNCH', day.lunch),
        _buildMealSection(context, 'DINNER', day.dinner),
        _buildMealSection(context, 'SNACKS', day.snacks),
      ],
    );
  }

  Widget _buildMealSection(BuildContext context, String title, List<DietMeal> meals) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final totalCals = meals.fold(0.0, (sum, m) => sum + m.calories);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: tokens.typography.labelMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: isT2 ? tokens.colors.primary : tokens.colors.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${totalCals.toInt()} KCAL',
                style: tokens.typography.labelSmall.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: tokens.colors.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
        ...meals.map((meal) => AdaptiveDietPlanMealTile(meal: meal)),
        const SizedBox(height: 12),
      ],
    );
  }
}

class AdaptiveDietPlanMealTile extends StatelessWidget {
  final DietMeal meal;
  const AdaptiveDietPlanMealTile({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: tokens.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
        ),
        child: ListTile(
          title: Text(
            meal.name.toUpperCase(),
            style: tokens.typography.labelMedium.copyWith(fontWeight: FontWeight.w800, color: tokens.colors.onSurface),
          ),
          subtitle: Text(
            '${meal.calories.toInt()} KCAL  •  P${meal.proteinG.toInt()} C${meal.carbsG.toInt()} F${meal.fatG.toInt()}',
            style: tokens.typography.bodySmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5), fontSize: 12),
          ),
          trailing: meal.ingredients.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.info_outline, color: tokens.colors.onSurface.withValues(alpha: 0.3), size: 20),
                  onPressed: () => _showIngredients(context, meal),
                )
              : null,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          title: Text(meal.name, style: tokens.typography.labelMedium.copyWith(fontWeight: FontWeight.w900)),
          subtitle: Text(
            '${meal.calories.toInt()} kcal  •  P${meal.proteinG.toInt()}g C${meal.carbsG.toInt()}g F${meal.fatG.toInt()}g',
            style: tokens.typography.bodySmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5)),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: tokens.colors.onSurface.withValues(alpha: 0.2)),
        ),
      ),
    );
  }

  void _showIngredients(BuildContext context, DietMeal meal) {
    final tokens = context.tokens;
    showModalBottomSheet(
      context: context,
      backgroundColor: tokens.colors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INGREDIENTS: ${meal.name.toUpperCase()}',
              style: tokens.typography.headlineSmall.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: tokens.colors.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...meal.ingredients.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.bolt, size: 14, color: tokens.colors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ing.toUpperCase(),
                          style: tokens.typography.bodyMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: tokens.colors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
