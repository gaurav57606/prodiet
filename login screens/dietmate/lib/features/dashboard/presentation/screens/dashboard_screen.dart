import 'package:flutter/material.dart';
import 'package:dietmate/core/theme/app_spacing.dart';
import 'package:dietmate/core/utils/extensions.dart';
import 'package:dietmate/shared/widgets/dm_avatar.dart';
import 'package:dietmate/features/dashboard/presentation/widgets/calorie_summary_card.dart';
import 'package:dietmate/features/dashboard/presentation/widgets/macro_ring_chart.dart';
import 'package:dietmate/features/dashboard/presentation/widgets/today_meals_row.dart';
import 'package:dietmate/features/dashboard/presentation/widgets/quick_action_grid.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const CalorieSummaryCard(),
                const SizedBox(height: AppSpacing.md),
                const MacroRingChart(),
                const SizedBox(height: AppSpacing.lg),
                const TodayMealsRow(),
                const SizedBox(height: AppSpacing.lg),
                const QuickActionGrid(),
                const SizedBox(height: 100), // Spacing for bottom nav
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      expandedHeight: 80,
      title: Row(
        children: [
          const DmAvatar(fallbackText: 'Rohan'),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: context.textTheme.labelLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
              Text('Rohan Sharma', style: context.textTheme.titleMedium),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}

