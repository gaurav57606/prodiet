import 'package:flutter/material.dart';
import 'package:prodiet_unified/shared/t2/widgets/alert_strip.dart';
import 'package:prodiet_unified/shared/t2/widgets/variety_toggle.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_chip.dart';
import 'package:prodiet_unified/features/recipe/presentation/t2/widgets/recipe_card_widget.dart';

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
            // Production ready
            const Padding(
              padding: EdgeInsets.all(18),
              child: VarietyToggle(),
            ),
            
            const AlertStrip(
              message: "3 ingredients in stock match these",
              subMessage: "Tap to see items in your pantry",
              isWarning: false,
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  RecipeCardWidget(
                    title: "Keto Paneer Bowl",
                    type: "LUNCH",
                    match: "92%",
                  ),
                  SizedBox(height: 5),
                  RecipeCardWidget(
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
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      DmChip(label: "No Dairy", isSelected: true, color: Color(0xFFFF5C3A)),
                      DmChip(label: "No Nuts", isSelected: true, color: Color(0xFFFF5C3A)),
                      DmChip(label: "No Gluten", isSelected: false),
                      DmChip(label: "No Eggs", isSelected: false),
                      DmChip(label: "No Soy", isSelected: false),
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

