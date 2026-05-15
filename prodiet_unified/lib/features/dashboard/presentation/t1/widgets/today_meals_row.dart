import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/macro_components.dart';
import 'package:prodiet_unified/shared/widgets/app_card.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';
import 'package:prodiet_unified/core/utils/date_providers.dart';
import 'package:intl/intl.dart';

class TodayMealsRow extends ConsumerWidget {
  final Meal? meal;

  const TodayMealsRow({
    super.key,
    this.meal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = ref.watch(nowProvider);

    if (meal == null) {
      return AppCard(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'NO SCHEDULED MEALS TODAY',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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

    final mealTime = DateFormat('hh:mm a').format(meal!.scheduledTime);
    final timeUntil = meal!.scheduledTime.difference(now);
    final hoursUntil = timeUntil.inHours;
    final minutesUntil = timeUntil.inMinutes % 60;
    final timeUntilStr = hoursUntil > 0 ? '${hoursUntil}h ${minutesUntil}m' : '${minutesUntil}m';

    return AppCard(
      padding: EdgeInsets.zero,
      color: isDark ? const Color(0xFFFF8C64).withValues(alpha: 0.08) : const Color(0xFFFFE6D7).withValues(alpha: 0.85),
      borderSide: BorderSide(color: const Color(0xFFFF8C64).withValues(alpha: 0.18)),
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
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFFF8C64).withValues(alpha: 0.6),
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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${meal!.nutritionalValues.calories} kcal · Balanced · Easy prep',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppMacroChip(
                        value: '${meal!.nutritionalValues.proteinG.toInt()}g',
                        label: 'PROT',
                        type: AppMacroType.protein,
                      ),
                    ),
                  ),
                ),
                _buildDivider(theme),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppMacroChip(
                        value: '${meal!.nutritionalValues.carbsG.toInt()}g',
                        label: 'CARB',
                        type: AppMacroType.carbs,
                      ),
                    ),
                  ),
                ),
                _buildDivider(theme),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppMacroChip(
                        value: '${meal!.nutritionalValues.fatG.toInt()}g',
                        label: 'FAT',
                        type: AppMacroType.fat,
                      ),
                    ),
                  ),
                ),
                _buildDivider(theme),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AppMacroChip(
                        value: '${meal!.nutritionalValues.fiberG}g',
                        label: 'FIBRE',
                        type: AppMacroType.fibre,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 30,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
    );
  }
}
