import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_macro_chip.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nutritional Insights')),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(T1Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMacroSection(context, summary),
              const SizedBox(height: T1Spacing.lg),
              Text(
                'MICRONUTRIENTS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.25),
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildMicronutrientList(context),
              const SizedBox(height: T1Spacing.lg),
              Text(
                'TOP PROTEIN SOURCES',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.25),
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              _buildContributorList(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroSection(BuildContext context, dynamic summary) {
    return DmCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DmMacroChip(value: '${summary.proteinConsumed}g', label: 'Protein', type: MacroType.protein),
              DmMacroChip(value: '${summary.carbsConsumed}g', label: 'Carbs', type: MacroType.carbs),
              DmMacroChip(value: '${summary.fatConsumed}g', label: 'Fats', type: MacroType.fat),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildMicronutrientList(BuildContext context) {
    return DmCard(
      child: Column(
        children: [
          _buildMicroBar(context, 'Vitamin A', 0.85, '850 IU'),
          _buildMicroBar(context, 'Vitamin C', 1.20, '120 mg'),
          _buildMicroBar(context, 'Iron', 0.65, '12 mg'),
          _buildMicroBar(context, 'Calcium', 0.90, '900 mg'),
          _buildMicroBar(context, 'Zinc', 0.40, '4 mg'),
        ],
      ),
    );
  }

  Widget _buildMicroBar(BuildContext context, String name, double value, String total) {
    final theme = Theme.of(context);
    final color = value >= 1.0 ? const Color(0xFF40D8B8) : (value < 0.5 ? const Color(0xFFFF6080) : const Color(0xFFC090FF));
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: theme.textTheme.bodyMedium),
              Text(total, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.4))),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value > 1.0 ? 1.0 : value,
            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildContributorList(BuildContext context) {
    return Column(
      children: [
        _buildFoodTile(context, 'Grilled Chicken', '42g', 'Lunch'),
        _buildFoodTile(context, 'Greek Yogurt', '18g', 'Snack'),
        _buildFoodTile(context, 'Boiled Eggs', '12g', 'Breakfast'),
      ],
    );
  }

  Widget _buildFoodTile(BuildContext context, String name, String amount, String meal) {
    final theme = Theme.of(context);
    return DmCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: theme.textTheme.titleSmall),
              Text(meal, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.3))),
            ],
          ),
          Text(amount, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
