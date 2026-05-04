import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/meal_planner/domain/models/meal_models.dart';

void main() {
  group('NutritionalValues', () {
    test('fromJson should handle nulls and provide defaults', () {
      final json = <String, dynamic>{};
      final result = NutritionalValues.fromJson(json);

      expect(result.calories, 0);
      expect(result.proteinG, 0);
    });

    test('toJson should return correct map', () {
      const values = NutritionalValues(
        calories: 500,
        proteinG: 30,
        carbsG: 50,
        fatG: 15,
        fiberG: 5,
      );

      final result = values.toJson();

      expect(result['calories'], 500);
      expect(result['protein_g'], 30);
    });
  });

  group('Meal', () {
    test('fromJson should parse nested objects correctly', () {
      final json = {
        'id': 'meal_1',
        'user_id': 'user_1',
        'meal_type': 'breakfast',
        'name': 'Oatmeal',
        'ingredients': [
          {
            'name': 'Oats',
            'quantity': 50.0,
            'unit': 'g',
            'calories_per_100g': 389
          }
        ],
        'nutritional_values': {
          'calories': 195,
          'protein_g': 7,
          'carbs_g': 33,
          'fat_g': 3,
          'fiber_g': 5,
        },
        'scheduled_time': '2024-01-01T08:00:00Z',
        'status': 'pending',
      };

      final result = Meal.fromJson(json);

      expect(result.name, 'Oatmeal');
      expect(result.ingredients.length, 1);
      expect(result.nutritionalValues.calories, 195);
    });
  });
}
