import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final activePlanAsync = ref.watch(activeDietPlanProvider);
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final mealsAsync = ref.watch(todayMealsProvider(todayStr));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Program'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month_rounded)),
        ],
      ),
      body: activePlanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (plan) => ListView(
          padding: const EdgeInsets.all(T1Spacing.lg),
          children: [
            _buildHeroCard(theme, plan),
            const SizedBox(height: T1Spacing.xl),
            _buildGoalMetrics(theme, user),
            const SizedBox(height: T1Spacing.xl),
            Text(
              'TODAY\'S SCHEDULE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: T1Spacing.md),
            mealsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading meals: $err'),
              data: (meals) => _buildTimeline(theme, meals),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(ThemeData theme, dynamic plan) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B1FA8).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.fitness_center_rounded, size: 180, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ACTIVE PLAN',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ),
                const Spacer(),
                Text(
                  plan?.name ?? 'No Active Plan',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Text(
                  plan != null 
                    ? 'Duration: ${plan.durationWeeks} Weeks'
                    : 'Select a plan to get started',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalMetrics(ThemeData theme, dynamic user) {
    return Row(
      children: [
        Expanded(child: _metric(theme, 'WEIGHT', user?.weightKg?.toString() ?? '--', 'kg', const Color(0xFF40D8B8))),
        const SizedBox(width: 12),
        Expanded(child: _metric(theme, 'BMI', user?.bmi?.toStringAsFixed(1) ?? '--', '', const Color(0xFFFF3060))),
        const SizedBox(width: 12),
        Expanded(child: _metric(theme, 'WATER GOAL', (user?.dailyWaterGoalMl ?? 2000 / 1000).toString(), 'L', const Color(0xFF3B1FA8))),
      ],
    );
  }

  Widget _metric(ThemeData theme, String label, String value, String unit, Color color) {
    return DmCard(
      color: color.withValues(alpha: 0.06),
      borderSide: BorderSide(color: color.withValues(alpha: 0.15)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: color.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: color),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: theme.textTheme.labelSmall?.copyWith(color: color.withValues(alpha: 0.5), fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(ThemeData theme, List<dynamic> meals) {
    if (meals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(T1Spacing.xl),
          child: Text('No meals scheduled for today',
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))
          ),
        ),
      );
    }

    return Column(
      children: meals.map((meal) {
        final isDone = meal.status == 'completed';
        final timeStr = meal.scheduledTime != null 
            ? DateFormat('HH:mm').format(meal.scheduledTime)
            : '--:--';

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  timeStr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: isDone ? 0.2 : 0.5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? const Color(0xFF40D8B8) : Colors.white.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: DmCard(
                  color: Colors.white.withValues(alpha: isDone ? 0.01 : 0.03),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    meal.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: isDone ? 0.3 : 1.0),
                      fontWeight: FontWeight.w700,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
