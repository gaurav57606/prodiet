import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/core/widgets/loaders/ai_thinking_loader.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dietPlanAsync = ref.watch(dietPlanProvider);
    final isGenerating = ref.watch(isGeneratingDietPlanProvider);
    final userId = ref.watch(currentUserIdProvider);

    // STATE 1: Loading / Generating
    if (isGenerating) {
      return const AiThinkingLoader(mode: 'diet');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Diet Plan'),
        actions: [
          if (dietPlanAsync.value != null)
            IconButton(
              onPressed: () => ref.read(dietPlanProvider.notifier).generate(),
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Regenerate Plan',
            ),
        ],
      ),
      body: dietPlanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (plan) {
          // STATE 2: Empty / No Plan
          if (plan == null) {
            return ProDietEmptyState(
              emoji: EmptyStateConfigs.dietPlan.emoji,
              headline: EmptyStateConfigs.dietPlan.headline,
              subtext: EmptyStateConfigs.dietPlan.subtext,
              buttonLabel: 'Create My Plan',
              onButtonTap: () => ref.read(dietPlanProvider.notifier).generate(),
            );
          }

          // STATE 3: Plan Exists
          return _buildPlanView(context, ref, theme, plan, userId);
        },
      ),
    );
  }

  Widget _buildPlanView(BuildContext context, WidgetRef ref, ThemeData theme, DietPlan plan, String userId) {
    return DefaultTabController(
      length: plan.days.length,
      child: Column(
        children: [
          _buildSummaryHeader(theme, plan),
          const SizedBox(height: 16),
          TabBar(
            isScrollable: true,
            labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: plan.days.map((d) => Tab(text: 'DAY ${d.dayNumber}')).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: plan.days.map((day) => _buildDayView(context, theme, day)).toList(),
            ),
          ),
          _buildAddTodayButton(context, ref, plan, userId),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme, DietPlan plan) {
    return Container(
      margin: const EdgeInsets.all(T1Spacing.lg),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B1FA8), Color(0xFF6B35FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            '~${plan.summaryCalories} kcal/day',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _macroTag('P', '${plan.summaryProteinG}g'),
              const SizedBox(width: 8),
              _macroTag('C', '${plan.summaryCarbsG}g'),
              const SizedBox(width: 8),
              _macroTag('F', '${plan.summaryFatG}g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroTag(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildDayView(BuildContext context, ThemeData theme, DietDay day) {
    return ListView(
      padding: const EdgeInsets.all(T1Spacing.lg),
      children: [
        _mealCard(theme, '🌅 BREAKFAST', day.breakfast),
        const SizedBox(height: 12),
        _mealCard(theme, '☀️ LUNCH', day.lunch),
        const SizedBox(height: 12),
        _mealCard(theme, '🌙 DINNER', day.dinner),
        const SizedBox(height: 12),
        _mealCard(theme, '🍎 SNACKS', day.snacks),
      ],
    );
  }

  Widget _mealCard(ThemeData theme, String title, String content) {
    return DmCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          Text(content, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildAddTodayButton(BuildContext context, WidgetRef ref, DietPlan plan, String userId) {
    return Padding(
      padding: const EdgeInsets.all(T1Spacing.lg),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(dietPlanRepositoryProvider).savePlanToMeals(userId, plan);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Today's meals added to your log ✅", style: TextStyle(fontWeight: FontWeight.w900)),
                  backgroundColor: Color(0xFF40D8B8),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B1FA8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('ADD TODAY TO MEALS', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        ),
      ),
    );
  }
}
