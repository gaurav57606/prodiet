import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/t2/t2_colors.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';

class DietPlanDetailScreen extends StatelessWidget {
  final DietPlan plan;
  final DietDay day;
  const DietPlanDetailScreen(
      {required this.plan, required this.day, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T2Colors.bgDefault,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          day.dayNumber == 1 ? 'MONDAY PLAN' : 'DAY ${day.dayNumber} DETAILS',
          style: GoogleFonts.barlowCondensed(
              fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: day.meals.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Icon(Icons.restaurant_rounded,
                          size: 40, color: T2Colors.lime)),
                  const SizedBox(height: 12),
                  Text('No meals planned for this day',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: T2Colors.textSecondary)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: day.meals.map((meal) => _MealCard(meal: meal)).toList(),
            ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final DietMeal meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    final name = meal.name;
    final kcal = meal.calories;
    final protein = meal.proteinG;
    final carbs = meal.carbsG;
    final fat = meal.fatG;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: T2Colors.bgElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: T2Colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15)),
          const SizedBox(height: 8),
          Row(children: [
            _macro('${kcal.toInt()} kcal', T2Colors.lime),
            const SizedBox(width: 12),
            _macro('P: ${protein.toInt()}g', Colors.white),
            const SizedBox(width: 8),
            _macro('C: ${carbs.toInt()}g', Colors.white),
            const SizedBox(width: 8),
            _macro('F: ${fat.toInt()}g', Colors.white),
          ]),
          if (meal.ingredients.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              meal.ingredients.join(', ').toUpperCase(),
              style: const TextStyle(
                  fontSize: 10, color: T2Colors.textMuted, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _macro(String label, Color color) => Text(label,
      style:
          TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600));
}
