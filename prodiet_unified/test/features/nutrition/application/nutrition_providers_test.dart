import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/nutrition/application/nutrition_providers.dart';
import 'package:prodiet_unified/features/nutrition/data/nutrition_repository.dart';
import 'package:prodiet_unified/features/nutrition/domain/daily_macro_summary.dart';
import 'package:prodiet_unified/features/nutrition/domain/top_food_item.dart';

class MockNutritionRepository extends Mock implements NutritionRepository {}

void main() {
  late MockNutritionRepository mockRepo;

  setUp(() {
    mockRepo = MockNutritionRepository();
  });

  group('Nutrition Providers', () {
    test('weeklyMacrosProvider should call repository with userId', () async {
      final tMacros = [
        const DailyMacroSummary(date: '2024-01-01', calories: 2000),
      ];

      when(() => mockRepo.getWeeklyMacros('user_123'))
          .thenAnswer((_) async => tMacros);

      final container = ProviderContainer(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(weeklyMacrosProvider.future);

      expect(result, tMacros);
      verify(() => mockRepo.getWeeklyMacros('user_123')).called(1);
    });

    test('topProteinSourcesProvider should return ranked items', () async {
      final tItems = [
        const TopFoodItem(name: 'Chicken', proteinG: 30),
      ];

      when(() => mockRepo.getTopProteinSources('user_123'))
          .thenAnswer((_) async => tItems);

      final container = ProviderContainer(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(mockRepo),
          currentUserIdProvider.overrideWithValue('user_123'),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(topProteinSourcesProvider.future);

      expect(result, tItems);
      verify(() => mockRepo.getTopProteinSources('user_123')).called(1);
    });
  });
}
