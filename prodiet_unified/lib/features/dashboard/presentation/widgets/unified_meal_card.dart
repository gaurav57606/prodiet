import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/macro_components.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';
import 'package:prodiet_unified/core/utils/date_providers.dart';

class UnifiedMealCard extends ConsumerWidget {
  final Meal? meal;

  const UnifiedMealCard({
    super.key,
    this.meal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = context.tokens;
    final now = ref.watch(nowProvider);

    if (meal == null) {
      return _buildEmptyState(context);
    }

    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return _buildT2MealCard(context);
    }

    return _buildT1MealCard(context, now);
  }

  Widget _buildEmptyState(BuildContext context) {
    final tokens = context.tokens;
    if (tokens.dashboardLayout == AppDashboardLayout.curved) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            "No more meals today!",
            style: tokens.typography.bodyMedium.copyWith(color: tokens.colors.onSurface.withValues(alpha: 0.5)),
          ),
        ),
      );
    }

    return AppCard(
      color: tokens.colors.surfaceContainerLowest.withValues(alpha: 0.1),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.restaurant_menu_rounded,
                color: tokens.colors.onSurface.withValues(alpha: 0.2),
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'NO SCHEDULED MEALS TODAY',
                style: tokens.typography.labelSmall.copyWith(
                  color: tokens.colors.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildT1MealCard(BuildContext context, DateTime now) {
    final tokens = context.tokens;
    final mealTime = DateFormat('hh:mm a').format(meal!.scheduledTime);
    final timeUntil = meal!.scheduledTime.difference(now);
    final hoursUntil = timeUntil.inHours;
    final minutesUntil = timeUntil.inMinutes % 60;
    final timeUntilStr = hoursUntil > 0 ? '${hoursUntil}h ${minutesUntil}m' : '${minutesUntil}m';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    // T1 uses a specific warm orange for meals
    const orangeAccent = Color(0xFFFF8C64);

    return AppCard(
      padding: EdgeInsets.zero,
      color: isDark ? orangeAccent.withValues(alpha: 0.08) : const Color(0xFFFFE6D7).withValues(alpha: 0.85),
      border: BorderSide(color: orangeAccent.withValues(alpha: 0.18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${meal!.mealType.toUpperCase()} · $mealTime',
                      style: tokens.typography.labelSmall.copyWith(
                        color: orangeAccent.withValues(alpha: 0.6),
                        letterSpacing: 0.8,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0x2EFF965A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        timeUntil.isNegative ? 'Now' : 'In $timeUntilStr',
                        style: const TextStyle(
                          color: Color(0xFFFFB870),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  meal!.name,
                  style: tokens.typography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${meal!.nutritionalValues.calories} kcal · Balanced · Easy prep',
                  style: tokens.typography.bodySmall.copyWith(
                    color: tokens.colors.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: tokens.colors.onSurface.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              children: [
                _buildMacroChip(context, meal!.nutritionalValues.proteinG.toDouble(), 'PROT', AppMacroType.protein),
                _buildDivider(context),
                _buildMacroChip(context, meal!.nutritionalValues.carbsG.toDouble(), 'CARB', AppMacroType.carbs),
                _buildDivider(context),
                _buildMacroChip(context, meal!.nutritionalValues.fatG.toDouble(), 'FAT', AppMacroType.fat),
                _buildDivider(context),
                _buildMacroChip(context, meal!.nutritionalValues.fiberG.toDouble(), 'FIBRE', AppMacroType.fibre),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildT2MealCard(BuildContext context) {
    final tokens = context.tokens;
    final timeStr = DateFormat('HH:mm').format(meal!.scheduledTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 3, color: tokens.colors.primary),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                      child: Text(
                        "${meal!.mealType.toUpperCase()} · $timeStr",
                        style: tokens.typography.labelSmall.copyWith(
                          fontSize: 8,
                          letterSpacing: 1.2,
                          color: tokens.colors.onSurface.withValues(alpha: 0.4),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: Text(
                        meal!.name,
                        style: tokens.typography.headlineSmall.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: tokens.colors.onSurface,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: meal!.nutritionalValues.calories.toString(),
                              style: tokens.typography.headlineMedium.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: tokens.colors.primary,
                              ),
                            ),
                            TextSpan(
                              text: ' kcal',
                              style: tokens.typography.labelLarge.copyWith(
                                fontSize: 14,
                                color: tokens.colors.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: tokens.colors.outline.withValues(alpha: 0.1))),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: AppMacroChip(value: "${meal!.nutritionalValues.proteinG}g", label: "Protein", type: AppMacroType.protein)),
                          const SizedBox(width: 5),
                          Expanded(child: AppMacroChip(value: "${meal!.nutritionalValues.carbsG}g", label: "Carbs", type: AppMacroType.carbs)),
                          const SizedBox(width: 5),
                          Expanded(child: AppMacroChip(value: "${meal!.nutritionalValues.fatG}g", label: "Fat", type: AppMacroType.fat)),
                          const SizedBox(width: 5),
                          Expanded(child: AppMacroChip(value: "${meal!.nutritionalValues.fiberG}g", label: "Fibre", type: AppMacroType.fibre)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroChip(BuildContext context, double value, String label, AppMacroType type) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AppMacroChip(
            value: '${value.toInt()}g',
            label: label,
            type: type,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final tokens = context.tokens;
    return Container(
      width: 1,
      height: 30,
      color: tokens.colors.onSurface.withValues(alpha: 0.05),
    );
  }
}
