import 'package:flutter/material.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_card.dart';
import 'package:dietmate/features/dashboard/presentation/mock/dashboard_mock.dart';

class CalorieSummaryCard extends StatelessWidget {
  const CalorieSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DmCard(
      padding: AppSpacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CALORIES',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${DashboardMockData.caloriesConsumed}',
                    style: context.textTheme.displayMedium?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '/ ${DashboardMockData.dailyCalorieGoal} kcal',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  value: DashboardMockData.caloriesConsumed / DashboardMockData.dailyCalorieGoal,
                  strokeWidth: 6,
                  backgroundColor: context.colorScheme.outline,
                  color: context.colorScheme.primary,
                ),
              ),
              Text(
                '${((DashboardMockData.caloriesConsumed / DashboardMockData.dailyCalorieGoal) * 100).toInt()}%',
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

