import 'package:flutter/material.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/core/theme/text_styles.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';
import 'package:dietmate_pro/shared/widgets/dm_button.dart';
import 'package:dietmate_pro/shared/widgets/dm_macro_chip.dart';

class CompensationScreen extends StatelessWidget {
  const CompensationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final coral = const Color(0xFFFF5C3A);
    final amber = const Color(0xFFFFB800);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meal Adjustment",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
              child: Text(
                "You missed a meal — here's the fix",
                style: theme.textTheme.bodySmall,
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: coral.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  border: Border.all(color: coral.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MISSED MEAL",
                      style: AppTextStyles.sectionLabel(colorScheme).copyWith(color: coral),
                    ),
                    Text(
                      "Morning Snack",
                      style: theme.textTheme.displayMedium?.copyWith(fontSize: 24, color: coral),
                    ),
                    Text(
                      "10:00 AM · Almonds + Fruit · 180 kcal · 6g protein",
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: DmCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IMPACT ANALYSIS", 
                      style: AppTextStyles.sectionLabel(colorScheme),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        DmMacroChip(
                          value: "-180",
                          label: "kcal",
                          type: MacroType.calories,
                        ),
                        SizedBox(width: 8),
                        DmMacroChip(
                          value: "-6g",
                          label: "Protein",
                          type: MacroType.protein,
                        ),
                        SizedBox(width: 8),
                        DmMacroChip(
                          value: "-12g",
                          label: "Carbs",
                          type: MacroType.carbs,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: DmCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.12),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
                        border: Border(left: BorderSide(color: theme.colorScheme.primary, width: 3)),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AUTO-ADJUSTMENT PLAN",
                                style: AppTextStyles.sectionLabel(colorScheme).copyWith(color: theme.colorScheme.primary),
                              ),
                              Text("Distributed across remaining meals", style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildAdjustItem(context, "Lunch · 12:30 PM", "+15g protein · Quinoa 100g → 120g", "+15g"),
                    _buildAdjustItem(context, "Dinner · 7:30 PM", "+80 kcal · Extra salmon 30g", "+80"),
                    _buildAdjustItem(context, "Evening Snack", "+12g carbs · Add banana", "+12g"),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(child: DmButton(label: "Accept Adjustment", onPressed: () {})),
                  const SizedBox(width: 8),
                  Expanded(child: DmButton(label: "Customise", variant: DmButtonVariant.outline, onPressed: () {})),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: amber.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Break from diet plan?", style: theme.textTheme.labelLarge?.copyWith(color: amber, fontWeight: FontWeight.w700)),
                    Text("Recalculate entire plan for remaining days to meet weekly goals", style: theme.textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Text("Recalculate plan ›", style: theme.textTheme.labelLarge?.copyWith(color: amber, decoration: TextDecoration.underline)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustItem(BuildContext context, String title, String sub, String delta) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Text(sub, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
              ],
            ),
          ),
          Text(
            delta,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 14, color: const Color(0xFFB8FF00)),
          ),
        ],
      ),
    );
  }
}
