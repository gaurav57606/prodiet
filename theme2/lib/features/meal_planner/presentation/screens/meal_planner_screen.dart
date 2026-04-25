import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dietmate_pro/core/theme/app_spacing.dart';
import 'package:dietmate_pro/features/meal_planner/presentation/widgets/meal_card.dart';
import 'package:dietmate_pro/features/meal_planner/presentation/widgets/variety_toggle.dart';
import 'package:dietmate_pro/shared/widgets/dm_card.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meal Planner",
          style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Today's Targets", style: theme.textTheme.titleMedium),
                  const Icon(Icons.calendar_today_outlined, size: 18),
                ],
              ),
            ),
            
            GestureDetector(
              onTap: () {}, // Toggle logic
              child: const VarietyToggle(),
            ),
            
            const MealCard(),
            
            // Navigation dots placeholder
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(true, theme),
                  const SizedBox(width: 5),
                  _buildDot(false, theme),
                  const SizedBox(width: 5),
                  _buildDot(false, theme),
                ],
              ),
            ),

            // Order CTA
            Padding(
              padding: const EdgeInsets.all(18),
              child: GestureDetector(
                onTap: () => context.pushNamed('vendor'),
                child: DmCard(
                  backgroundColor: const Color(0xFFB06EFF).withOpacity(0.1),
                  borderSide: const BorderSide(color: Color(0x33B06EFF)),
                  borderRadius: 14,
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFFB06EFF), size: 15),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Can't cook? Order this meal",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFB06EFF),
                              ),
                            ),
                            Text(
                              "3 matches on Zomato · Best match 94%",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "View ›",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFB06EFF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isActive, ThemeData theme) {
    return Container(
      width: isActive ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
