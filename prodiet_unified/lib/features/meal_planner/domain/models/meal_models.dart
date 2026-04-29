class Meal {
  final String id;
  final String userId;
  final String? dietPlanId;
  final String mealType; // breakfast, lunch, snack, dinner
  final String name;
  final List<Ingredient> ingredients;
  final NutritionalValues nutritionalValues;
  final DateTime scheduledTime;
  final String status; // pending, completed, skipped
  final DateTime date;

  const Meal({
    required this.id,
    required this.userId,
    this.dietPlanId,
    required this.mealType,
    required this.name,
    required this.ingredients,
    required this.nutritionalValues,
    required this.scheduledTime,
    required this.status,
    required this.date,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      userId: json['user_id'],
      dietPlanId: json['diet_plan_id'],
      mealType: json['meal_type'],
      name: json['name'],
      ingredients: (json['ingredients'] as List? ?? [])
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      nutritionalValues: NutritionalValues.fromJson(json['nutritional_values'] ?? {}),
      scheduledTime: DateTime.parse(json['scheduled_time']),
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'diet_plan_id': dietPlanId,
      'meal_type': mealType,
      'name': name,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'nutritional_values': nutritionalValues.toJson(),
      'scheduled_time': scheduledTime.toIso8601String(),
      'status': status,
      'date': date.toIso8601String().split('T')[0],
    };
  }
}

class Ingredient {
  final String name;
  final double quantity;
  final String unit;
  final int caloriesPer100g;

  const Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.caloriesPer100g,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: (json['quantity'] as num? ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      caloriesPer100g: (json['calories_per_100g'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'calories_per_100g': caloriesPer100g,
    };
  }
}

class NutritionalValues {
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int fiberG;

  const NutritionalValues({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
  });

  factory NutritionalValues.fromJson(Map<String, dynamic> json) {
    return NutritionalValues(
      calories: (json['calories'] as num? ?? 0).toInt(),
      proteinG: (json['protein_g'] as num? ?? 0).toInt(),
      carbsG: (json['carbs_g'] as num? ?? 0).toInt(),
      fatG: (json['fat_g'] as num? ?? 0).toInt(),
      fiberG: (json['fiber_g'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein_g': proteinG,
      'carbs_g': carbsG,
      'fat_g': fatG,
      'fiber_g': fiberG,
    };
  }
}

class MealLog {
  final String id;
  final String userId;
  final String mealId;
  final String actualTime;
  final int actualCalories;
  final String? notes;
  final bool compensationApplied;

  const MealLog({
    required this.id,
    required this.userId,
    required this.mealId,
    required this.actualTime,
    required this.actualCalories,
    this.notes,
    required this.compensationApplied,
  });

  factory MealLog.fromJson(Map<String, dynamic> json) {
    return MealLog(
      id: json['id'],
      userId: json['user_id'],
      mealId: json['meal_id'],
      actualTime: json['actual_time'],
      actualCalories: (json['actual_calories'] as num? ?? 0).toInt(),
      notes: json['notes'],
      compensationApplied: json['compensation_applied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'meal_id': mealId,
      'actual_time': actualTime,
      'actual_calories': actualCalories,
      'notes': notes,
      'compensation_applied': compensationApplied,
    };
  }
}
