import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan_state.dart';
import 'package:prodiet_unified/core/widgets/loaders/ai_thinking_loader.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/core/widgets/empty_states/empty_state_configs.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanState = ref.watch(dietPlanProvider);
    final userId = ref.watch(currentUserIdProvider);

    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (dietPlanState is DietPlanLoaded)
            IconButton(
              onPressed: () => ref.read(dietPlanProvider.notifier).generate(),
              icon: const Icon(Icons.refresh_rounded, color: T2Colors.lime),
            ),
        ],
      ),
      body: switch (dietPlanState) {
        DietPlanLoading() => const AiThinkingLoader(mode: 'diet'),
        DietPlanError(message: final msg) => Center(child: Text('Error: $msg', style: const TextStyle(color: Colors.white))),
        DietPlanInitial() => Center(
            child: ProDietEmptyState(
              emoji: EmptyStateConfigs.dietPlan.emoji,
              headline: EmptyStateConfigs.dietPlan.headline.toUpperCase(),
              subtext: EmptyStateConfigs.dietPlan.subtext,
              buttonLabel: 'CREATE MY PLAN',
              onButtonTap: () => ref.read(dietPlanProvider.notifier).generate(),
            ),
          ),
        DietPlanLoaded(plan: final plan) => _buildPlanContent(context, ref, plan, userId),
      },
    );
  }

  Widget _buildPlanContent(BuildContext context, WidgetRef ref, DietPlan plan, String userId) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PLAN',
                  style: GoogleFonts.barlowCondensed(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    color: T2Colors.lime,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: T2Colors.lime.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AI GENERATED 7-DAY PLAN',
                    style: TextStyle(fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w800, color: T2Colors.lime),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildMacroGrid(plan),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'WEEKLY OVERVIEW',
              style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: T2Colors.textMuted, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          _buildDaySelector(context, plan),
          const SizedBox(height: 40),
          _buildActionCard(context, ref, plan, userId),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMacroGrid(DietPlan plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildTargetCard('CALORIES', '${plan.summaryCalories.toInt()}', 'kcal/day', T2Colors.sky),
          _buildTargetCard('PROTEIN', '${plan.summaryProteinG.toInt()}g', 'Daily Target', T2Colors.coral),
          _buildTargetCard('CARBS', '${plan.summaryCarbsG.toInt()}g', 'Daily Target', T2Colors.amber),
          _buildTargetCard('FATS', '${plan.summaryFatG.toInt()}g', 'Daily Target', T2Colors.purple),
        ],
      ),
    );
  }

  Widget _buildTargetCard(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: T2Colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 8, letterSpacing: 1.2, color: T2Colors.textMuted, fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(value, style: GoogleFonts.barlowCondensed(fontSize: 28, fontWeight: FontWeight.w800, color: color)),
          Text(sub, style: TextStyle(fontSize: 10, color: T2Colors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context, DietPlan plan) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: plan.days.map((day) {
          final isToday = day.dayNumber == (DateTime.now().weekday); 
          return InkWell(
            onTap: () => context.pushNamed('t2DietPlanDetail', extra: day),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isToday ? T2Colors.lime : T2Colors.bgDeep,
                shape: BoxShape.circle,
                border: Border.all(color: isToday ? T2Colors.lime : T2Colors.border),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.dayNumber}',
                style: TextStyle(color: isToday ? Colors.black : T2Colors.textPrimary, fontWeight: FontWeight.w800, fontSize: 14),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, WidgetRef ref, DietPlan plan, String userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: T2Colors.bgDeep,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: T2Colors.border),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: T2Colors.lime, size: 32),
            const SizedBox(height: 16),
            Text(
              'READY TO START?',
              style: GoogleFonts.barlowCondensed(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Add today's meals to your daily log to begin tracking.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: T2Colors.textSecondary),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
                await ref.read(dietPlanProvider.notifier).saveTodayMeals();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("MEALS ADDED ✅", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black)),
                      backgroundColor: T2Colors.lime,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: T2Colors.lime, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: const Text('ADD TODAY TO MEALS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
