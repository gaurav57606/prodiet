import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/features/meal_planner/domain/daily_meal_summary.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AdaptiveMealSummaryHeader extends StatelessWidget {
  final DailyMealSummary summary;
  final int calorieGoal;

  const AdaptiveMealSummaryHeader({
    super.key,
    required this.summary,
    required this.calorieGoal,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final remaining = (calorieGoal - summary.totalCalories).toInt().clamp(0, 9999);

    if (isT2) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: tokens.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildT2Stat(context, 'CONSUMED', '${summary.totalCalories.toInt()}', tokens.colors.onSurface),
                _buildT2Stat(context, 'REMAINING', '$remaining', tokens.colors.primary),
                _buildT2Stat(context, 'MEALS', '${summary.eatenCount}/${summary.meals.length}', tokens.colors.onSurface.withValues(alpha: 0.5)),
              ],
            ),
            const SizedBox(height: 24),
            _AdaptiveMacroBar(summary: summary),
          ],
        ),
      );
    }

    return AppCard(
      color: tokens.colors.primary.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildT1Stat(context, 'TOTAL KCAL', '${summary.totalCalories.toInt()}', tokens.colors.primary),
              _buildT1Stat(context, 'REMAINING', '$remaining', const Color(0xFF40D8B8)),
              _buildT1Stat(context, 'MEALS', '${summary.eatenCount}/${summary.meals.length}', tokens.colors.onSurface.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: 20),
          _AdaptiveMacroBar(summary: summary),
        ],
      ),
    );
  }

  Widget _buildT1Stat(BuildContext context, String label, String value, Color color) {
    final tokens = context.tokens;
    return Column(
      children: [
        Text(label, style: tokens.typography.labelSmall.copyWith(fontSize: 8, color: tokens.colors.onSurface.withValues(alpha: 0.3), fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(value, style: tokens.typography.headlineSmall.copyWith(color: color, fontWeight: FontWeight.w900, fontSize: 20)),
      ],
    );
  }

  Widget _buildT2Stat(BuildContext context, String label, String value, Color color) {
    final tokens = context.tokens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tokens.typography.labelSmall.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.4), letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(value, style: tokens.typography.displaySmall.copyWith(color: color, fontWeight: FontWeight.w900, height: 1)),
      ],
    );
  }
}

class _AdaptiveMacroBar extends StatelessWidget {
  final DailyMealSummary summary;
  const _AdaptiveMacroBar({required this.summary});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final totalMacros = summary.totalProteinG + summary.totalCarbsG + summary.totalFatG;
    if (totalMacros == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(flex: (summary.totalProteinG * 100 / totalMacros).toInt(), child: Container(color: const Color(0xFF40D8B8))), // Protein
                const SizedBox(width: 2),
                Expanded(flex: (summary.totalCarbsG * 100 / totalMacros).toInt(), child: Container(color: tokens.colors.secondary)), // Carbs
                const SizedBox(width: 2),
                Expanded(flex: (summary.totalFatG * 100 / totalMacros).toInt(), child: Container(color: tokens.colors.error)), // Fat
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _MacroLabel(label: 'PROT', value: '${summary.totalProteinG.toInt()}g', color: const Color(0xFF40D8B8)),
            _MacroLabel(label: 'CARB', value: '${summary.totalCarbsG.toInt()}g', color: tokens.colors.secondary),
            _MacroLabel(label: 'FAT', value: '${summary.totalFatG.toInt()}g', color: tokens.colors.error),
          ],
        ),
      ],
    );
  }
}

class _MacroLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroLabel({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: tokens.typography.labelSmall.copyWith(fontSize: 9, fontWeight: FontWeight.w900, color: tokens.colors.onSurface.withValues(alpha: 0.3))),
        const SizedBox(width: 4),
        Text(value, style: tokens.typography.labelSmall.copyWith(fontSize: 9, fontWeight: FontWeight.w900, color: tokens.colors.onSurface)),
      ],
    );
  }
}

class AdaptiveMealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkEaten;

  const AdaptiveMealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onDelete,
    required this.onMarkEaten,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final accentColor = _getMealColor(context, meal.mealType);

    return Dismissible(
      key: Key(meal.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: tokens.colors.error, borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.delete_outline_rounded, color: tokens.colors.onError),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(color: const Color(0xFF40D8B8), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Mark Eaten', style: tokens.typography.labelLarge.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.check_circle_outline_rounded, color: Colors.black),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onDelete();
          return false; // Handled by onDelete callback dialog
        } else if (direction == DismissDirection.endToStart) {
          onMarkEaten();
          return false;
        }
        return false;
      },
      child: isT2 ? _buildT2Card(context, tokens, accentColor) : _buildT1Card(context, tokens, accentColor),
    );
  }

  Widget _buildT1Card(BuildContext context, AppThemeTokens tokens, Color accentColor) {
    return AppCard(
      padding: EdgeInsets.zero,
      color: accentColor.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        meal.mealType.name.toUpperCase(),
                        style: tokens.typography.labelSmall.copyWith(
                          color: accentColor.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusBadge(status: meal.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(meal.name, style: tokens.typography.titleMedium.copyWith(fontWeight: FontWeight.w900)),
                ],
              ),
              Text('${meal.calories.toInt()} kcal', style: tokens.typography.titleMedium.copyWith(color: accentColor, fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildT2Card(BuildContext context, AppThemeTokens tokens, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: tokens.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.colors.outline.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meal.mealType.name.toUpperCase(),
                    style: tokens.typography.labelSmall.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  _StatusBadge(status: meal.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                meal.name.toUpperCase(),
                style: tokens.typography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  color: tokens.colors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.local_fire_department_rounded, size: 16, color: accentColor),
                  const SizedBox(width: 4),
                  Text(
                    '${meal.calories.toInt()} KCAL',
                    style: tokens.typography.labelMedium.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: tokens.colors.onSurface.withValues(alpha: 0.2)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMealColor(BuildContext context, MealType type) {
    final tokens = context.tokens;
    switch (type) {
      case MealType.breakfast: return const Color(0xFFFF8C64);
      case MealType.lunch: return tokens.colors.secondary;
      case MealType.snack: return const Color(0xFF40D8B8);
      case MealType.dinner: return tokens.colors.primary;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final MealStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final color = status == MealStatus.eaten ? const Color(0xFF40D8B8) : (status == MealStatus.skipped ? tokens.colors.outline : tokens.colors.secondary);
    final label = status == MealStatus.eaten ? 'Eaten' : (status == MealStatus.skipped ? 'Skipped' : 'Pending');
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: tokens.typography.labelSmall.copyWith(color: color, fontSize: 8, fontWeight: FontWeight.w900),
      ),
    );
  }
}
