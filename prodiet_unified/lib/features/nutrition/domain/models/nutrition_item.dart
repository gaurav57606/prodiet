import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

class NutritionItem {
  final String id;
  final String productName;
  final String? brand;
  final String? barcode;
  final int calories100g;
  final double protein100g;
  final double carbs100g;
  final double fat100g;
  final double fiber100g;
  final double sugar100g;
  final double? servingSize; // in grams
  final String? imageUrl;
  final String? category;
  final DateTime createdAt;

  const NutritionItem({
    required this.id,
    required this.productName,
    this.brand,
    this.barcode,
    required this.calories100g,
    required this.protein100g,
    required this.carbs100g,
    required this.fat100g,
    required this.fiber100g,
    required this.sugar100g,
    this.servingSize,
    this.imageUrl,
    this.category,
    required this.createdAt,
  });

  // Computed
  int? get caloriesPerServing {
    if (servingSize == null) return null;
    return (calories100g * (servingSize! / 100)).round();
  }

  factory NutritionItem.fromJson(Map<String, dynamic> json) {
    return NutritionItem(
      id: json['id'],
      productName: json['product_name'],
      brand: json['brand'],
      barcode: json['barcode'],
      calories100g: (json['calories_100g'] as num? ?? 0).toInt(),
      protein100g: (json['protein_100g'] as num? ?? 0).toDouble(),
      carbs100g: (json['carbs_100g'] as num? ?? 0).toDouble(),
      fat100g: (json['fat_100g'] as num? ?? 0).toDouble(),
      fiber100g: (json['fiber_100g'] as num? ?? 0).toDouble(),
      sugar100g: (json['sugar_100g'] as num? ?? 0).toDouble(),
      servingSize: (json['serving_size'] as num?)?.toDouble(),
      imageUrl: json['image_url'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'brand': brand,
      'barcode': barcode,
      'calories_100g': calories100g,
      'protein_100g': protein100g,
      'carbs_100g': carbs100g,
      'fat_100g': fat100g,
      'fiber_100g': fiber100g,
      'sugar_100g': sugar100g,
      'serving_size': servingSize,
      'image_url': imageUrl,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NutritionalValues calculatePortion(double grams) {
    if (grams <= 0) {
      return const NutritionalValues(
        calories: 0,
        proteinG: 0,
        carbsG: 0,
        fatG: 0,
        fiberG: 0,
      );
    }
    final ratio = grams / 100;
    return NutritionalValues(
      calories: (calories100g * ratio).round(),
      proteinG: (protein100g * ratio).round(),
      carbsG: (carbs100g * ratio).round(),
      fatG: (fat100g * ratio).round(),
      fiberG: (fiber100g * ratio).round(),
    );
  }
}
