import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_macro_chip.dart';
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
      return DmCard(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: T1Spacing.xl),
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

    return DmCard(
      padding: EdgeInsets.zero,
      color: isDark ? const Color(0xFFFF8C64).withValues(alpha: 0.08) : const Color(0xFFFFE6D7).withValues(alpha: 0.85),
      borderSide: BorderSide(color: const Color(0xFFFF8C64).withValues(alpha: 0.18)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(T1Spacing.md),
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
                    DmChip(
                      label: timeUntil.isNegative ? 'Now' : 'In $timeUntilStr',
                      isSelected: true,
                      backgroundColor: const Color(0x2EFF965A),
                      textColor: const Color(0xFFFFB870),
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
                top: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(
                        value: '${meal!.nutritionalValues.proteinG.toInt()}g',
                        label: 'PROT',
                        type: MacroType.protein,
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(
                        value: '${meal!.nutritionalValues.carbsG.toInt()}g',
                        label: 'CARB',
                        type: MacroType.carbs,
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(
                        value: '${meal!.nutritionalValues.fatG.toInt()}g',
                        label: 'FAT',
                        type: MacroType.fat,
                      ),
                    ),
                  ),
                ),
                _buildDivider(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DmMacroChip(
                        value: '${meal!.nutritionalValues.fiberG}g',
                        label: 'FIBRE',
                        type: MacroType.fibre,
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

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}
