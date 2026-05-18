import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';

void main() {
  final baseDate = DateTime(2026, 1, 15, 10, 0, 0);

  /// A fully-populated user used across multiple test groups.
  final fullUser = AppUser(
    id: 'abc-123',
    email: 'test@prodiet.app',
    name: 'Gaurav',
    age: 28,
    weightKg: 75.0,
    heightCm: 175.0,
    allergies: ['peanuts', 'gluten'],
    dietaryPreferences: ['vegetarian'],
    fitnessGoal: 'lose_weight',
    activityLevel: 'moderate',
    onboardingComplete: true,
    dailyWaterGoalMl: 2500,
    dailyCalorieGoal: 1800,
    fcmToken: 'fcm_token_xyz',
    varietyPreference: 'variety',
    createdAt: baseDate,
    updatedAt: baseDate,
    targetWeightKg: 68.0,
  );

  // ─────────────────────────────────────────────────────────
  // fromJson
  // ─────────────────────────────────────────────────────────
  group('AppUser.fromJson', () {
    test('parses all fields from a fully-populated JSON map', () {
      final json = <String, dynamic>{
        'id': 'abc-123',
        'email': 'test@prodiet.app',
        'name': 'Gaurav',
        'age': 28,
        'weight_kg': 75.0,
        'height_cm': 175.0,
        'allergies': ['peanuts', 'gluten'],
        'dietary_preferences': ['vegetarian'],
        'fitness_goal': 'lose_weight',
        'activity_level': 'moderate',
        'onboarding_complete': true,
        'daily_water_goal_ml': 2500,
        'daily_calorie_goal': 1800,
        'fcm_token': 'fcm_token_xyz',
        'variety_preference': 'variety',
        'created_at': baseDate.toIso8601String(),
        'updated_at': baseDate.toIso8601String(),
        'target_weight_kg': 68.0,
      };
      final user = AppUser.fromJson(json);

      expect(user.id,                  'abc-123');
      expect(user.email,               'test@prodiet.app');
      expect(user.name,                'Gaurav');
      expect(user.age,                 28);
      expect(user.weightKg,            75.0);
      expect(user.heightCm,            175.0);
      expect(user.allergies,           ['peanuts', 'gluten']);
      expect(user.dietaryPreferences,  ['vegetarian']);
      expect(user.fitnessGoal,         'lose_weight');
      expect(user.activityLevel,       'moderate');
      expect(user.onboardingComplete,  true);
      expect(user.dailyWaterGoalMl,    2500);
      expect(user.dailyCalorieGoal,    1800);
      expect(user.fcmToken,            'fcm_token_xyz');
      expect(user.varietyPreference,   'variety');
      expect(user.targetWeightKg,      68.0);
      expect(user.updatedAt,           isNotNull);
    });

    test('applies correct defaults for missing optional fields', () {
      final json = <String, dynamic>{
        'id': 'x1',
        'email': 'x@t.com',
        'created_at': baseDate.toIso8601String(),
      };
      final user = AppUser.fromJson(json);

      expect(user.allergies,          isEmpty);
      expect(user.dietaryPreferences, isEmpty);
      expect(user.onboardingComplete, false);
      expect(user.dailyWaterGoalMl,   2000);
      expect(user.varietyPreference,  'balanced');
      expect(user.updatedAt,          isNull);
      expect(user.targetWeightKg,     isNull);
      expect(user.fcmToken,           isNull);
    });

    test('handles null created_at gracefully (falls back to DateTime.now())', () {
      final json = <String, dynamic>{
        'id': 'x1',
        'email': 'x@t.com',
        'created_at': null,
      };
      final user = AppUser.fromJson(json);
      expect(user.createdAt, isNotNull);
    });

    test('coerces num weight_kg to double', () {
      final json = <String, dynamic>{
        'id': 'x1',
        'email': 'x@t.com',
        'created_at': baseDate.toIso8601String(),
        'weight_kg': 80,  // int in JSON, must become double
      };
      final user = AppUser.fromJson(json);
      expect(user.weightKg, isA<double>());
      expect(user.weightKg, 80.0);
    });
  });

  // ─────────────────────────────────────────────────────────
  // toJson
  // ─────────────────────────────────────────────────────────
  group('AppUser.toJson', () {
    test('always serializes the 6 required fields', () {
      final json = fullUser.toJson();
      expect(json['id'],                 'abc-123');
      expect(json['email'],              'test@prodiet.app');
      expect(json['onboarding_complete'],true);
      expect(json['daily_water_goal_ml'],2500);
      expect(json['variety_preference'], 'variety');
      expect(json['created_at'],         isA<String>());
    });

    test('omits null optional fields from JSON output', () {
      final minUser = AppUser(
        id: 'x1',
        email: 'x@t.com',
        createdAt: baseDate,
      );
      final json = minUser.toJson();
      expect(json.containsKey('name'),             false);
      expect(json.containsKey('weight_kg'),        false);
      expect(json.containsKey('fcm_token'),        false);
      expect(json.containsKey('target_weight_kg'), false);
      expect(json.containsKey('updated_at'),       false);
    });

    test('includes non-empty lists in JSON output', () {
      final json = fullUser.toJson();
      expect(json['allergies'],           ['peanuts', 'gluten']);
      expect(json['dietary_preferences'], ['vegetarian']);
    });

    test('omits empty lists from JSON output', () {
      final noListUser = AppUser(
        id: 'x1',
        email: 'x@t.com',
        createdAt: baseDate,
      );
      final json = noListUser.toJson();
      expect(json.containsKey('allergies'),           false);
      expect(json.containsKey('dietary_preferences'), false);
    });

    test('round-trip: fromJson(toJson()) preserves all values exactly', () {
      final json     = fullUser.toJson();
      final restored = AppUser.fromJson(json);

      expect(restored.id,               fullUser.id);
      expect(restored.email,            fullUser.email);
      expect(restored.name,             fullUser.name);
      expect(restored.weightKg,         fullUser.weightKg);
      expect(restored.targetWeightKg,   fullUser.targetWeightKg);
      expect(restored.allergies,        fullUser.allergies);
      expect(restored.onboardingComplete, fullUser.onboardingComplete);
      expect(restored.dailyWaterGoalMl, fullUser.dailyWaterGoalMl);
      expect(restored.varietyPreference,fullUser.varietyPreference);
    });
  });

  // ─────────────────────────────────────────────────────────
  // copyWith
  // ─────────────────────────────────────────────────────────
  group('AppUser.copyWith', () {
    test('updates only changed fields, preserves all others', () {
      final updated = fullUser.copyWith(name: 'NewName', weightKg: 72.0);
      expect(updated.name,    'NewName');
      expect(updated.weightKg, 72.0);
      expect(updated.email,   fullUser.email);  // unchanged
      expect(updated.id,      fullUser.id);     // unchanged
      expect(updated.allergies, fullUser.allergies); // unchanged
    });

    test('returns new object (immutability check)', () {
      final updated = fullUser.copyWith(name: 'Other');
      expect(identical(updated, fullUser), false);
    });
  });

  // ─────────────────────────────────────────────────────────
  // Computed properties
  // ─────────────────────────────────────────────────────────
  group('AppUser — BMI', () {
    test('calculates correctly: 75kg / (1.75m)^2 ≈ 24.49', () {
      expect(fullUser.bmi, isNotNull);
      expect(fullUser.bmi!, closeTo(24.49, 0.1));
    });

    test('returns null when weight is missing', () {
      final user = AppUser(id: 'x', email: 'x@t.com', createdAt: baseDate,
          heightCm: 175.0);
      expect(user.bmi, isNull);
    });

    test('returns null when height is missing', () {
      final user = AppUser(id: 'x', email: 'x@t.com', createdAt: baseDate,
          weightKg: 75.0);
      expect(user.bmi, isNull);
    });
  });

  group('AppUser — bmiCategory', () {
    test('Normal for BMI ≈24.49 (75kg / 175cm)', () {
      expect(fullUser.bmiCategory, 'Normal');
    });

    test('Underweight for BMI < 18.5 (50kg / 175cm)', () {
      expect(
        fullUser.copyWith(weightKg: 50.0).bmiCategory,
        'Underweight',
      );
    });

    test('Overweight for BMI 25–30 (90kg / 175cm)', () {
      expect(
        fullUser.copyWith(weightKg: 90.0).bmiCategory,
        'Overweight',
      );
    });

    test('Obese for BMI ≥30 (120kg / 175cm)', () {
      expect(
        fullUser.copyWith(weightKg: 120.0).bmiCategory,
        'Obese',
      );
    });

    test('Unknown when bmi returns null', () {
      final user = AppUser(id: 'x', email: 'x@t.com', createdAt: baseDate);
      expect(user.bmiCategory, 'Unknown');
    });
  });

  group('AppUser — hasCompletedHealthGoals', () {
    test('true when all 4 required fields set', () {
      expect(fullUser.hasCompletedHealthGoals, true);
    });

    test('false when fitnessGoal is missing', () {
      final json = fullUser.toJson()
        ..remove('fitness_goal');
      final user = AppUser.fromJson({
        ...json,
        'created_at': baseDate.toIso8601String(),
      });
      expect(user.hasCompletedHealthGoals, false);
    });

    test('false when activityLevel is missing', () {
      final json = fullUser.toJson()
        ..remove('activity_level');
      final user = AppUser.fromJson({
        ...json,
        'created_at': baseDate.toIso8601String(),
      });
      expect(user.hasCompletedHealthGoals, false);
    });

    test('false when both weight and height are missing', () {
      final user = AppUser(
        id: 'x',
        email: 'x@t.com',
        fitnessGoal: 'lose_weight',
        activityLevel: 'moderate',
        createdAt: baseDate,
      );
      expect(user.hasCompletedHealthGoals, false);
    });
  });
}
