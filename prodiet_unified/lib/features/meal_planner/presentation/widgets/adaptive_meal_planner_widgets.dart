import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/design_system/tokens/app_theme_tokens.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/core/design_system/components/app_card.dart';

class AdaptiveDayCard extends StatelessWidget {
  final DateTime date;
  final List<Meal> meals;
  final VoidCallback onTap;

  const AdaptiveDayCard({
    super.key,
    required this.date,
    required this.meals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final isT2 = tokens.dashboardLayout == AppDashboardLayout.t2;
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final totalCals = meals.fold(0.0, (sum, m) => sum + m.calories);

    return AppCard(
      padding: EdgeInsets.zero,
      color: isToday ? tokens.colors.primary.withValues(alpha: 0.1) : tokens.colors.surfaceContainerLowest,
      border: BorderSide(
        color: isToday ? tokens.colors.primary : tokens.colors.onSurface.withValues(alpha: 0.05),
        width: isToday ? 1.5 : 1,
      ),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isT2 ? 20 : 16,
          vertical: isT2 ? 12 : 16,
        ),
        child: Row(
          children: [
            Container(
              width: isT2 ? 60 : 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isToday ? tokens.colors.primary : tokens.colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(tokens.radius.sm),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat(isT2 ? 'EEE' : 'E').format(date).toUpperCase(),
                    style: tokens.typography.labelSmall.copyWith(
                      color: isToday ? tokens.colors.onPrimary : tokens.colors.onSurface.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    DateFormat('dd').format(date),
                    style: tokens.typography.headlineSmall.copyWith(
                      color: isToday ? tokens.colors.onPrimary : tokens.colors.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meals.isEmpty 
                        ? (isT2 ? 'REST DAY' : 'No meals planned')
                        : (isT2 ? '${meals.length} MEALS SCHEDULED' : '${meals.length} meals scheduled'),
                    style: tokens.typography.titleMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${totalCals.toInt()} KCAL ${isT2 ? 'PLANNED' : 'total'}',
                    style: tokens.typography.bodySmall.copyWith(
                      color: tokens.colors.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isT2 ? Icons.arrow_forward_ios_rounded : Icons.chevron_right_rounded,
              color: tokens.colors.onSurface.withValues(alpha: 0.2),
              size: isT2 ? 16 : 24,
            ),
          ],
        ),
      ),
    );
  }
}

