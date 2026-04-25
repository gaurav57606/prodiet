import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../mock/diet_plan_mock.dart';
import '../widgets/day_selector.dart';
import '../widgets/meal_timeline_item.dart';

class DietPlanScreen extends StatelessWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          const DaySelector(),
          const SizedBox(height: AppSpacing.md),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TODAY\'S TIMELINE',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.25),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF40D8B8).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '4/5 done',
                    style: TextStyle(
                      color: Color(0xFF106050),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: DietPlanMockData.todayMeals.length,
              itemBuilder: (context, index) {
                final meal = DietPlanMockData.todayMeals[index];
                return MealTimelineItem(
                  data: meal,
                  isLast: index == DietPlanMockData.todayMeals.length - 1,
                );
              },
            ),
          ),
          
          // Weekly Summary Card at bottom
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: DmCard(
              color: theme.colorScheme.primary.withOpacity(0.05),
              child: Row(
                children: [
                  Icon(Icons.insights_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Compliance: 92%',
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          'You are on track to lose 0.5kg this week.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80), // Space for FAB/Nav
        ],
      ),
    );
  }
}
