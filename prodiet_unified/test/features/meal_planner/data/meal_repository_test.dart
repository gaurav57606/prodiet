import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/features/meal_planner/data/meal_repository.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

// We need a helper to mock the Future behavior of Postgrest builders
abstract class FakePostgrestFilterBuilder extends Fake implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

void main() {
  late MealRepository repository;
  late MockSupabaseClient mockSupabase;
  late MockPostgrestQueryBuilder mockQueryBuilder;
  late MockPostgrestFilterBuilder mockFilterBuilder;

  setUpAll(() {
    registerFallbackValue(const {});
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockQueryBuilder = MockPostgrestQueryBuilder();
    mockFilterBuilder = MockPostgrestFilterBuilder();
    repository = MealRepository(mockSupabase);

    when(() => mockSupabase.from(any())).thenReturn(mockQueryBuilder);
  });

  group('MealRepository', () {
    test('getMealHistory should return a list of meals', () async {
      final mockResponse = [
        {
          'id': 'm1',
          'user_id': 'u1',
          'name': 'Breakfast',
          'meal_type': 'breakfast',
          'calories': 500.0,
          'protein_g': 20.0,
          'carbs_g': 50.0,
          'fat_g': 15.0,
          'ingredients': ['Oats', 'Milk'],
          'status': 'eaten',
          'planned_date': '2026-05-01',
          'created_at': '2026-05-01T08:00:00Z',
        }
      ];

      when(() => mockQueryBuilder.select()).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.eq(any(), any())).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.gte(any(), any())).thenAnswer((_) async => mockResponse);

      final result = await repository.getMealHistory('u1');

      expect(result, isA<List<Meal>>());
      expect(result.length, 1);
    });

    test('markEaten should update meal status', () async {
      when(() => mockQueryBuilder.update(any())).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.eq(any(), any())).thenAnswer((_) async => []);

      await repository.markEaten('m1');

      verify(() => mockQueryBuilder.update({'status': 'eaten'})).called(1);
    });

    test('deleteMeal should call delete on supabase', () async {
      when(() => mockQueryBuilder.delete()).thenReturn(mockFilterBuilder);
      when(() => mockFilterBuilder.eq(any(), any())).thenAnswer((_) async => []);

      await repository.deleteMeal('m1');

      verify(() => mockQueryBuilder.delete()).called(1);
    });
  });
}
