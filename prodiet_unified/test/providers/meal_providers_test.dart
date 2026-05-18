import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/data/meal_repository.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';

class MockMealRepository extends Mock implements MealRepository {}

void main() {
  late MockMealRepository mockRepo;

  setUp(() {
    mockRepo = MockMealRepository();
  });

  group('Meal Planner Providers', () {
    test('todayMealsProvider should calculate summary from repository stream', () async {
      final tMeals = [
        Meal(
          id: '1',
          userId: 'u1',
          name: 'Eggs',
          calories: 200,
          proteinG: 12,
          carbsG: 1,
          fatG: 15,
          ingredients: ['Eggs'],
          status: MealStatus.eaten,
          mealType: MealType.breakfast,
          plannedDate: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockRepo.watchTodayMeals('user_123'))
          .thenAnswer((_) => Stream.value(tMeals));

      final container = ProviderContainer(
        overrides: [
          mealRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
        ],
      );
      addTearDown(container.dispose);

      // Keep the provider alive with a listener during the async read
      final subscription = container.listen(todayMealsProvider, (_, __) {});
      final result = await container.read(todayMealsProvider.future);
      subscription.close();

      expect(result.totalCalories, 200);
      expect(result.meals.length, 1);
      verify(() => mockRepo.watchTodayMeals('user_123')).called(1);
    });

    test('weeklyMealsProvider should return meal list', () async {
      when(() => mockRepo.getMealHistory('user_123', days: 7))
          .thenAnswer((_) async => []);

      final container = ProviderContainer(
        overrides: [
          mealRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
        ],
      );
      addTearDown(container.dispose);

      // Keep the provider alive with a listener during the async read
      final subscription = container.listen(weeklyMealsProvider, (_, __) {});
      final result = await container.read(weeklyMealsProvider.future);
      subscription.close();

      expect(result, []);
      verify(() => mockRepo.getMealHistory('user_123', days: 7)).called(1);
    });
  });
}
