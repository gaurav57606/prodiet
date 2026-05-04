import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';
import 'package:prodiet_unified/features/diet_plan/application/diet_plan_providers.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan_state.dart';

class DietPlanScreen extends ConsumerWidget {
  const DietPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dietPlanProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (state is DietPlanInitial) {
      return Scaffold(
        backgroundColor: T2Colors.bgDefault,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('DIET PLAN',
              style: GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900)),
        ),
        body: ProDietEmptyState(
          emoji: '🥗',
          headline: 'NO DIET PLAN YET',
          subtext:
              'Let AI build your personalised 7-day plan based on your goals.',
          buttonLabel: '✨ CREATE MY PLAN',
          onButtonTap: () => ref.read(dietPlanProvider.notifier).generate(),
        ),
      );
    }

    if (state is DietPlanLoading) {
      return Scaffold(
        backgroundColor: T2Colors.bgDefault,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: T2Colors.lime),
              const SizedBox(height: 24),
              Text(
                'BUILDING YOUR PLAN...',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ANALYSING YOUR GOALS & PREFERENCES',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DietPlanError) {
      return Scaffold(
        backgroundColor: T2Colors.bgDefault,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('DIET PLAN',
              style: GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900)),
        ),
        body: ProDietEmptyState(
          emoji: '⚠️',
          headline: 'SOMETHING WENT WRONG',
          subtext: state.message,
          buttonLabel: 'TRY AGAIN',
          onButtonTap: () => ref.read(dietPlanProvider.notifier).generate(),
        ),
      );
    }

    if (state is DietPlanLoaded) {
      final plan = state.plan;
      return DefaultTabController(
        length: 7,
        child: Scaffold(
          backgroundColor: T2Colors.bgDefault,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('YOUR DIET PLAN',
                style:
                    GoogleFonts.barlowCondensed(fontWeight: FontWeight.w900)),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: T2Colors.lime),
                onPressed: () => ref.read(dietPlanProvider.notifier).generate(),
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              indicatorColor: T2Colors.lime,
              labelColor: T2Colors.lime,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
              labelStyle: GoogleFonts.barlowCondensed(
                  fontWeight: FontWeight.w800, fontSize: 16),
              tabs: const [
                Tab(text: 'MON'),
                Tab(text: 'TUE'),
                Tab(text: 'WED'),
                Tab(text: 'THU'),
                Tab(text: 'FRI'),
                Tab(text: 'SAT'),
                Tab(text: 'SUN'),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildSummaryCard(context, ref, plan),
              Expanded(
                child: TabBarView(
                  children: plan.days
                      .map((day) => _buildDayTab(context, day))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildSummaryCard(BuildContext context, WidgetRef ref, DietPlan plan) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: T2Colors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(plan.summaryCalories.toInt().toString(), 'KCAL'),
              _buildStat(plan.summaryProteinG.toInt().toString(), 'PROT'),
              _buildStat(plan.summaryCarbsG.toInt().toString(), 'CARB'),
              _buildStat(plan.summaryFatG.toInt().toString(), 'FAT'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                await ref.read(dietPlanProvider.notifier).saveTodayMeals();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Today\'s meals added ✅')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: T2Colors.lime,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'ADD TODAY\'S MEALS TO LOG',
                style: GoogleFonts.barlowCondensed(
                    fontWeight: FontWeight.w900, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.barlowCondensed(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.barlowCondensed(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: T2Colors.lime,
          ),
        ),
      ],
    );
  }

  Widget _buildDayTab(BuildContext context, DietDay day) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildMealSection(context, 'BREAKFAST', day.breakfast),
        _buildMealSection(context, 'LUNCH', day.lunch),
        _buildMealSection(context, 'DINNER', day.dinner),
        _buildMealSection(context, 'SNACKS', day.snacks),
      ],
    );
  }

  Widget _buildMealSection(
      BuildContext context, String title, List<DietMeal> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.barlowCondensed(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: T2Colors.lime,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                '${meals.fold(0.0, (sum, m) => sum + m.calories).toInt()} KCAL',
                style: GoogleFonts.barlowCondensed(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        ...meals.map((meal) => _buildMealTile(context, meal)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMealTile(BuildContext context, DietMeal meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: T2Colors.border),
      ),
      child: ListTile(
        title: Text(
          meal.name.toUpperCase(),
          style: GoogleFonts.barlowCondensed(
              fontWeight: FontWeight.w800, color: Colors.white),
        ),
        subtitle: Text(
          '${meal.calories.toInt()} KCAL  •  P${meal.proteinG.toInt()} C${meal.carbsG.toInt()} F${meal.fatG.toInt()}',
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        ),
        trailing: meal.ingredients.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.info_outline,
                    color: T2Colors.border, size: 20),
                onPressed: () => _showIngredients(context, meal),
              )
            : null,
      ),
    );
  }

  void _showIngredients(BuildContext context, DietMeal meal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: T2Colors.bgElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INGREDIENTS: ${meal.name.toUpperCase()}',
              style: GoogleFonts.barlowCondensed(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: T2Colors.lime,
              ),
            ),
            const SizedBox(height: 16),
            ...meal.ingredients.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, size: 14, color: T2Colors.lime),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ing.toUpperCase(),
                          style: GoogleFonts.barlowCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
