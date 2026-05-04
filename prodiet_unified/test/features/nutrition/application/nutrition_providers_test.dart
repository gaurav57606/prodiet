import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/nutrition/application/nutrition_providers.dart';
import 'package:prodiet_unified/features/nutrition/data/nutrition_repository.dart';
import 'package:prodiet_unified/features/nutrition/domain/models/nutrition_item.dart';

class MockNutritionRepository extends Mock implements NutritionRepository {}
class MockAppUser extends Mock implements AppUser {}

void main() {
  late MockNutritionRepository mockRepo;
  late MockAppUser mockUser;

  setUp(() {
    mockRepo = MockNutritionRepository();
    mockUser = MockAppUser();
    when(() => mockUser.id).thenReturn('user_1');
  });

  group('Nutrition Providers', () {
    test('nutritionSearchProvider should return empty list for short queries', () async {
      final container = ProviderContainer(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(nutritionSearchProvider('a').future);

      expect(result, isEmpty);
      verifyNever(() => mockRepo.searchByName(any(), any()));
    });

    test('nutritionSearchProvider should return results from repository', () async {
      final tItems = [
        NutritionItem(
          id: '1',
          productName: 'Apple',
          calories100g: 52,
          protein100g: 0.3,
          carbs100g: 13.8,
          fat100g: 0.2,
          fiber100g: 2.4,
          sugar100g: 10.4,
          createdAt: DateTime.now(),
        )
      ];

      when(() => mockRepo.searchByName('user_1', 'Apple'))
          .thenAnswer((_) async => Right(tItems));

      final container = ProviderContainer(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(mockRepo),
          currentUserProvider.overrideWithValue(mockUser),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(nutritionSearchProvider('Apple').future);

      expect(result, tItems);
      verify(() => mockRepo.searchByName('user_1', 'Apple')).called(1);
    });

    test('barcodeLookupProvider should return item from repository', () async {
      final tItem = NutritionItem(
        id: '1',
        productName: 'Milk',
        calories100g: 42,
        protein100g: 3.4,
        carbs100g: 5.0,
        fat100g: 1.0,
        fiber100g: 0.0,
        sugar100g: 5.0,
        createdAt: DateTime.now(),
      );

      when(() => mockRepo.lookupByBarcode('123456789'))
          .thenAnswer((_) async => Right(tItem));

      final container = ProviderContainer(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(barcodeLookupProvider('123456789').future);

      expect(result, tItem);
      verify(() => mockRepo.lookupByBarcode('123456789')).called(1);
    });
  });
}
