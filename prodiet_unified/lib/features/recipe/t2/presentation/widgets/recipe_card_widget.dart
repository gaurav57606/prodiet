import 'package:flutter/material.dart';
import 'package:prodiet_unified/core/theme/t2/t2_spacing.dart';
import 'package:prodiet_unified/core/theme/t2/t2_text_styles.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_macro_chip.dart';

class RecipeCardWidget extends StatelessWidget {
  final String title;
  final String type;
  final String match;
  final bool isExotic;

  const RecipeCardWidget({
    super.key,
    required this.title,
    required this.type,
    required this.match,
    this.isExotic = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primary = colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isExotic
                      ? [const Color(0xFF1a0d06), const Color(0xFF2d1408)]
                      : [const Color(0xFF060d1a), const Color(0xFF081428)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(T2Spacing.radiusLarge)),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          type,
                          style: T2TextStyles.sectionLabel(colorScheme)
                              .copyWith(color: Colors.white70),
                        ),
                        Text(
                          title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 22,
                            height: 1.1,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$match match",
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: primary, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: DmMacroChip(
                          value: "420",
                          label: "kcal",
                          type: MacroType.calories,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: DmMacroChip(
                          value: "32g",
                          label: "Protein",
                          type: MacroType.protein,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: DmMacroChip(
                          value: "48g",
                          label: "Carbs",
                          type: MacroType.carbs,
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: DmMacroChip(
                          value: "10g",
                          label: "Fat",
                          type: MacroType.fat,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      _buildTag(context, "High fibre", isGood: true),
                      _buildTag(context, "Gut friendly", isGood: true),
                      _buildTag(context, "30 mins"),
                      _buildTag(context, "Easy prep"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DmButton(
                    label: "View Recipe & Steps",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label, {bool isGood = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontSize: 9,
          color: isGood
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
