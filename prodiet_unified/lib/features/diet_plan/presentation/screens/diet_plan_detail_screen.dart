import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class DietPlanDetailScreen extends StatelessWidget {
  final DietMeal? meal;
  final DietPlan? plan;
  final DietDay? day;

  const DietPlanDetailScreen({
    super.key,
    this.meal,
    this.plan,
    this.day,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;

    if (isT2 && day != null) {
      return _buildT2DayDetail(context);
    }

    if (meal != null) {
      return _buildT1MealDetail(context);
    }

    return const Scaffold(
      body: Center(child: Text('Navigation error: missing data.')),
    );
  }

  Widget _buildT1MealDetail(BuildContext context) {
    final tokens = context.tokens;
    final meal = this.meal!;

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                children: [
                  Text(
                    'Nutritional Summary',
                    style: tokens.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMacroChip(context, '${meal.calories.toInt()}', 'KCAL', tokens.colors.primary),
                      _buildMacroChip(context, '${meal.proteinG.toInt()}g', 'PROT', tokens.colors.secondary),
                      _buildMacroChip(context, '${meal.carbsG.toInt()}g', 'CARB', tokens.colors.carbs),
                      _buildMacroChip(context, '${meal.fatG.toInt()}g', 'FAT', tokens.colors.fat),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'INGREDIENTS',
              style: tokens.typography.labelSmall.copyWith(
                color: tokens.colors.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            if (meal.ingredients.isEmpty)
              const Text('No ingredients listed')
            else
              ...meal.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: tokens.colors.primary.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            ing,
                            style: tokens.typography.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildT2DayDetail(BuildContext context) {
    final tokens = context.tokens;
    final day = this.day!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          day.dayNumber == 1 ? 'MONDAY PLAN' : 'DAY ${day.dayNumber} DETAILS',
          style: tokens.typography.titleLarge.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: day.meals.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_rounded, size: 40, color: tokens.colors.primary),
                const SizedBox(height: 12),
                Text('No meals planned for this day',
                  style: tokens.typography.bodyMedium.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5))),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.symmetric(vertical: 10),
            children: day.meals.map((m) => _T2MealCard(meal: m)).toList(),
          ),
    );
  }

  Widget _buildMacroChip(BuildContext context, String value, String label, Color color) {
    final tokens = context.tokens;
    return Column(
      children: [
        Text(value, style: tokens.typography.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(label, style: tokens.typography.labelSmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5))),
      ],
    );
  }
}

class _T2MealCard extends StatelessWidget {
  final DietMeal meal;
  const _T2MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal.name.toUpperCase(), style: tokens.typography.labelLarge.copyWith(
            fontWeight: FontWeight.w800, color: tokens.colors.onSurface)),
          const SizedBox(height: 8),
          Row(children: [
            _macro(context, '${meal.calories.toInt()} kcal', tokens.colors.primary),
            const SizedBox(width: 12),
            _macro(context, 'P: ${meal.proteinG.toInt()}g', tokens.colors.onSurface),
            const SizedBox(width: 8),
            _macro(context, 'C: ${meal.carbsG.toInt()}g', tokens.colors.onSurface),
            const SizedBox(width: 8),
            _macro(context, 'F: ${meal.fatG.toInt()}g', tokens.colors.onSurface),
          ]),
          if (meal.ingredients.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              meal.ingredients.join(', ').toUpperCase(),
              style: tokens.typography.bodySmall.copyWith(fontSize: 10, color: tokens.colors.onSurface.withValues(alpha: 0.4), height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _macro(BuildContext context, String label, Color color) {
    final tokens = context.tokens;
    return Text(label, style: tokens.typography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600));
  }
}
