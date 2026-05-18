class RecipeIngredient {
  final String name;
  final double quantity;
  final String unit;

  RecipeIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });
}

class Recipe {
  final String id;
  final String name;
  final String type; // Breakfast, Lunch, Dinner, Snack
  final List<RecipeIngredient> requiredIngredients;
  final List<String> steps;
  final int calories;
  final int protein; // in grams
  final int carbs; // in grams
  final int fats; // in grams
  final List<String> allergens; // "dairy", "nuts", "gluten", etc.
  final String imageUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.type,
    required this.requiredIngredients,
    required this.steps,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.allergens,
    this.imageUrl = '',
  });
}
