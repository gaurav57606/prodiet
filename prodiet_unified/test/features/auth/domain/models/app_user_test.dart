import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';

void main() {
  group('AppUser', () {
    final createdAt = DateTime(2024, 1, 1);
    const userId = 'user_123';
    const email = 'test@example.com';

    final tAppUser = AppUser(
      id: userId,
      email: email,
      name: 'Test User',
      age: 25,
      weightKg: 70.0,
      heightCm: 175.0,
      createdAt: createdAt,
    );

    test('fromJson should return a valid model', () {
      final json = {
        'id': userId,
        'email': email,
        'name': 'Test User',
        'age': 25,
        'weight_kg': 70.0,
        'height_cm': 175.0,
        'onboarding_complete': false,
        'daily_water_goal_ml': 2000,
        'variety_preference': 'balanced',
        'created_at': createdAt.toIso8601String(),
      };

      final result = AppUser.fromJson(json);

      expect(result.id, userId);
      expect(result.email, email);
      expect(result.weightKg, 70.0);
    });

    test('toJson should return a valid Map', () {
      final result = tAppUser.toJson();

      expect(result['id'], userId);
      expect(result['email'], email);
      expect(result['weight_kg'], 70.0);
    });

    test('copyWith should return a modified model', () {
      final result = tAppUser.copyWith(name: 'Updated Name');

      expect(result.name, 'Updated Name');
      expect(result.id, tAppUser.id);
    });

    group('Computed Properties', () {
      test('bmi should calculate correctly', () {
        // BMI = weight / (height/100)^2
        // 70 / (1.75 * 1.75) = 70 / 3.0625 = 22.857
        expect(tAppUser.bmi, closeTo(22.86, 0.01));
      });

      test('bmiCategory should return correct category', () {
        final underweight = tAppUser.copyWith(weightKg: 50.0); // BMI ~16.3
        final normal = tAppUser.copyWith(weightKg: 70.0); // BMI ~22.9
        final overweight = tAppUser.copyWith(weightKg: 85.0); // BMI ~27.7
        final obese = tAppUser.copyWith(weightKg: 100.0); // BMI ~32.6

        expect(underweight.bmiCategory, 'Underweight');
        expect(normal.bmiCategory, 'Normal');
        expect(overweight.bmiCategory, 'Overweight');
        expect(obese.bmiCategory, 'Obese');
      });

      test('hasCompletedHealthGoals should return true if all goals set', () {
        final complete = tAppUser.copyWith(
          fitnessGoal: 'lose_weight',
          activityLevel: 'moderate',
        );
        expect(complete.hasCompletedHealthGoals, true);

        final incomplete = tAppUser.copyWith(fitnessGoal: null);
        expect(incomplete.hasCompletedHealthGoals, false);
      });
    });
  });
}
