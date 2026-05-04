import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/theme/t1/t1_spacing.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_macro_chip.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_empty_state.dart';

class NutritionScreen extends ConsumerWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(dashboardProvider);

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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              const DmEmptyState(
                title: 'Data Integration Pending',
                message: 'Detailed micronutrient tracking will be available in a future update.',
                icon: Icons.biotech_rounded,
              ),
              const SizedBox(height: T1Spacing.lg),
              Text(
                'TOP PROTEIN SOURCES',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: T1Spacing.md),
              const DmEmptyState(
                title: 'Coming Soon',
                message: 'Identify your best protein sources once you log more meals.',
                icon: Icons.restaurant_menu_rounded,
              ),
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
              DmMacroChip(value: '${summary.proteinConsumed}g', label: 'Protein', type: MacroType.protein, large: true),
              DmMacroChip(value: '${summary.carbsConsumed}g', label: 'Carbs', type: MacroType.carbs, large: true),
              DmMacroChip(value: '${summary.fatConsumed}g', label: 'Fats', type: MacroType.fat, large: true),
            ],
          ),
        ],
      ),
    );
  }
}
