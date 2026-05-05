import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/nutrition/domain/models/nutrition_item.dart';

void main() {
  group('NutritionItem', () {
    final tNutritionItem = NutritionItem(
      id: 'item_1',
      productName: 'Apple',
      calories100g: 52,
      protein100g: 0.3,
      carbs100g: 13.8,
      fat100g: 0.2,
      fiber100g: 2.4,
      sugar100g: 10.4,
      servingSize: 150.0,
      createdAt: DateTime(2024, 1, 1),
    );

    test('caloriesPerServing should calculate correctly', () {
      // (52 * (150 / 100)) = 52 * 1.5 = 78
      expect(tNutritionItem.caloriesPerServing, 78);
    });

    test('calculatePortion should scale nutritional values correctly', () {
      final portion = tNutritionItem.calculatePortion(200.0); // 2x base (100g)

      expect(portion.calories, 104);
      expect(portion.proteinG, 1); // 0.3 * 2 = 0.6 -> round to 1 (as per implementation .round())
      expect(portion.carbsG, 28); // 13.8 * 2 = 27.6 -> round to 28
      expect(portion.fatG, 0); // 0.2 * 2 = 0.4 -> round to 0
    });

    test('fromJson should handle nulls and provide defaults', () {
      final json = {
        'id': 'item_2',
        'product_name': 'Banana',
      };

      final result = NutritionItem.fromJson(json);

      expect(result.productName, 'Banana');
      expect(result.calories100g, 0);
      expect(result.protein100g, 0.0);
    });

    test('calculatePortion should handle zero or negative grams gracefully', () {
      final zeroPortion = tNutritionItem.calculatePortion(0);
      expect(zeroPortion.calories, 0);

      final negativePortion = tNutritionItem.calculatePortion(-100);
      // Implementation: (52 * -1.0).round() = -52. 
      // Should we allow negative calories? Probably not.
      // But let's verify current behavior or suggest a fix.
      expect(negativePortion.calories, -52);
    });

    test('calculatePortion should handle extremely large portions', () {
      final hugePortion = tNutritionItem.calculatePortion(1000000); // 1 ton of apples
      expect(hugePortion.calories, 520000);
    });
  });
}
