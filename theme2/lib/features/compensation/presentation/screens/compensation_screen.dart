import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_button.dart';

class CompensationScreen extends StatelessWidget {
  const CompensationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coral = const Color(0xFFFF5C3A);
    final amber = const Color(0xFFFFB800);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meal Adjustment",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 24),
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
                  border: Border.all(color: coral.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MISSED MEAL",
                      style: theme.textTheme.labelSmall?.copyWith(color: coral, fontWeight: FontWeight.w700),
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
                    Text("IMPACT ANALYSIS", style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildImpact(context, "-180", "kcal missed", coral),
                        const SizedBox(width: 8),
                        _buildImpact(context, "-6g", "protein missed", coral),
                        const SizedBox(width: 8),
                        _buildImpact(context, "-12g", "carbs missed", amber),
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
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Auto-Adjustment Plan",
                                style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700),
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
                    Text("Recalculate plan ›", style: theme.textTheme.labelLarge?.copyWith(color: amber)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpact(BuildContext context, String value, String label, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.displayMedium?.copyWith(fontSize: 22, color: color)),
            Text(label, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
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
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 14, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
