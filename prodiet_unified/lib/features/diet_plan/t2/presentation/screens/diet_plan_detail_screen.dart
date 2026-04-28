import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';

class DietPlanDetailScreen extends StatelessWidget {
  const DietPlanDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan Details"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(T2Spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primary.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "High Protein Lean Cut",
                    style: theme.textTheme.displaySmall?.copyWith(color: primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "This 12-week intensive programme is designed to help you shed body fat while maintaining muscle mass. It focuses on nutrient-dense whole foods with a specific macro distribution of 40% Protein, 30% Carbs, and 30% Fat.",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: T2Spacing.xl),
            Text("Core Guidelines", style: theme.textTheme.titleLarge),
            const SizedBox(height: T2Spacing.md),
            _buildGuideline(context, "Hydration", "Minimum 3L of water daily. Increase by 500ml on workout days."),
            _buildGuideline(context, "Meal Timing", "Eat within 60 minutes of waking up. Last meal 3 hours before sleep."),
            _buildGuideline(context, "Supplements", "Multivitamin with breakfast. Whey protein post-workout."),
            const SizedBox(height: T2Spacing.xxl),
            DmButton(
              label: "Modify My Plan",
              variant: DmButtonVariant.outline,
              onPressed: () {},
            ),
            const SizedBox(height: T2Spacing.md),
            DmButton(
              label: "End Programme",
              variant: DmButtonVariant.danger,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideline(BuildContext context, String title, String desc) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(desc, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
