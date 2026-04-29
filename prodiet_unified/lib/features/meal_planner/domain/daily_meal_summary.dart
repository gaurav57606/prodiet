import 'meal.dart';

class DailyMealSummary {
  final List<Meal> meals;
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;

  const DailyMealSummary({
    required this.meals,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
  });

  List<Meal> byType(MealType t) => meals.where((m) => m.mealType == t).toList();
  int get eatenCount => meals.where((m) => m.status == MealStatus.eaten).length;

  factory DailyMealSummary.calculate(List<Meal> meals) {
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (var meal in meals) {
      if (meal.status == MealStatus.eaten) {
        calories += meal.calories;
        protein += meal.proteinG;
        carbs += meal.carbsG;
        fat += meal.fatG;
      }
    }

    return DailyMealSummary(
      meals: meals,
      totalCalories: calories,
      totalProteinG: protein,
      totalCarbsG: carbs,
      totalFatG: fat,
    );
  }
}
