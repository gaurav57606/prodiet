import 'package:flutter/material.dart';
import 'package:prodiet_unified/features/dashboard/t2/presentation/widgets/alert_strip.dart';
import 'package:prodiet_unified/features/meal_planner/t2/presentation/widgets/variety_toggle.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_card.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_chip.dart';
import 'package:prodiet_unified/features/recipe/t2/presentation/widgets/recipe_card_widget.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recipes",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AlertStrip(
              message: 'DEMO MODE — Sample data only',
              subMessage: 'Live integration coming in next version',
              isWarning: true,
            ),
            const Padding(
              padding: EdgeInsets.all(18),
              child: VarietyToggle(),
            ),
            
            const AlertStrip(
              message: "3 ingredients in stock match these",
              subMessage: "Tap to see items in your pantry",
              isWarning: false,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const RecipeCardWidget(
                    title: "Keto Paneer Bowl",
                    type: "LUNCH",
                    match: "92%",
                  ),
                  const SizedBox(height: 5),
                  const RecipeCardWidget(
                    title: "Quinoa Salad",
                    type: "DINNER",
                    match: "78%",
                    isExotic: true,
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Allergy Filter", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const DmChip(label: "No Dairy", isSelected: true, color: Color(0xFFFF5C3A)),
                      const DmChip(label: "No Nuts", isSelected: true, color: Color(0xFFFF5C3A)),
                      const DmChip(label: "No Gluten", isSelected: false),
                      const DmChip(label: "No Eggs", isSelected: false),
                      const DmChip(label: "No Soy", isSelected: false),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
