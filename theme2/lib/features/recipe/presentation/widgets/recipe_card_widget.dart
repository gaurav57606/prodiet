import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/dm_card.dart';
import '../../../../shared/widgets/dm_button.dart';

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
    final primary = theme.colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: DmCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              height: 90,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isExotic 
                    ? [const Color(0xFF1a0d06), const Color(0xFF2d1408)]
                    : [const Color(0xFF060d1a), const Color(0xFF081428)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
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
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        Text(
                          title,
                          style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22, height: 1.1),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$match match",
                        style: theme.textTheme.labelLarge?.copyWith(color: primary, fontSize: 10),
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
                  Row(
                    children: [
                      _buildMacro(context, "420", "kcal", primary),
                      _buildMacro(context, "32g", "Protein", const Color(0xFFFF5C3A)),
                      _buildMacro(context, "48g", "Carbs", const Color(0xFFFFB800)),
                      _buildMacro(context, "10g", "Fat", const Color(0xFFB06EFF)),
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

  Widget _buildMacro(BuildContext context, String value, String label, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16, color: color),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
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
          color: isGood ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
