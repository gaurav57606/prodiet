import 'package:flutter/material.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_card.dart';
import 'package:dietmate/features/dashboard/presentation/mock/dashboard_mock.dart';

class MacroRingChart extends StatelessWidget {
  const MacroRingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildMacroItem(context, 'Protein', DashboardMockData.proteinConsumed, DashboardMockData.proteinGoal, Colors.orange),
        const SizedBox(width: AppSpacing.md),
        _buildMacroItem(context, 'Carbs', DashboardMockData.carbsConsumed, DashboardMockData.carbsGoal, Colors.blue),
        const SizedBox(width: AppSpacing.md),
        _buildMacroItem(context, 'Fats', DashboardMockData.fatsConsumed, DashboardMockData.fatsGoal, Colors.green),
      ],
    );
  }

  Widget _buildMacroItem(BuildContext context, String label, double current, double goal, Color color) {
    return Expanded(
      child: DmCard(
        padding: 12,
        child: Column(
          children: [
            Text(label, style: context.textTheme.labelSmall),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: current / goal,
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 8),
            Text(
              '${current.toInt()}g',
              style: context.textTheme.titleSmall?.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

