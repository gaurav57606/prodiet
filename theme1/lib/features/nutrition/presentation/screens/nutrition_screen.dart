import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nutritional Insights')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMacroSection(context),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'MICRONUTRIENTS',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.25),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildMicronutrientList(context),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'TOP PROTEIN SOURCES',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.25),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildContributorList(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroSection(BuildContext context) {
    final theme = Theme.of(context);
    return DmCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroDetail(theme, 'Protein', '142g', '95%', Colors.pinkAccent),
              _buildMacroDetail(theme, 'Carbs', '180g', '82%', Colors.orangeAccent),
              _buildMacroDetail(theme, 'Fats', '54g', '105%', Colors.lightBlueAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroDetail(ThemeData theme, String label, String value, String percent, Color color) {
    return Column(
      children: [
        Text(percent, style: theme.textTheme.titleMedium?.copyWith(color: color)),
        Text(value, style: theme.textTheme.labelSmall),
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.3))),
      ],
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
