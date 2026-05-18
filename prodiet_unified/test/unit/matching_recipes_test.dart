import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/recipe/application/recipe_providers.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/inventory/domain/inventory_item.dart';

void main() {
  group('Recipe Matcher Engine Tests', () {
    test('Empty inventory matching works without crashing', () async {
      final container = ProviderContainer(
        overrides: [
          inventoryStreamProvider.overrideWith(
            (ref) => Stream.value(<InventoryItem>[]),
          ),
        ],
      );

      // Keep the provider alive by listening to it
      final subscription = container.listen(
        matchingRecipesProvider,
        (previous, next) {},
      );

      // Wait for stream to emit
      await container.read(inventoryStreamProvider.future);

      final result = container.read(matchingRecipesProvider);
      expect(result.hasValue, isTrue);
      
      final list = result.value!;
      // All recipes should have 0% match
      for (var item in list) {
        expect(item.matchPercentage, equals(0.0));
      }

      subscription.close();
      container.dispose();
    });

    test('Inventory matches ingredients using substring / plural forms', () async {
      // Mock pantry with paneer
      final mockPantry = [
        InventoryItem(
          id: '1',
          userId: 'user123',
          ingredientName: 'paneer',
          quantity: 200.0,
          unit: 'g',
          category: 'Protein',
          reorderThreshold: 50.0,
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          inventoryStreamProvider.overrideWith(
            (ref) => Stream.value(mockPantry),
          ),
        ],
      );

      // Keep the provider alive by listening to it
      final subscription = container.listen(
        matchingRecipesProvider,
        (previous, next) {},
      );

      await container.read(inventoryStreamProvider.future);

      final list = container.read(matchingRecipesProvider).value!;
      
      // "Keto Paneer Bowl" contains "paneer" as a required ingredient, so it should be matched!
      final paneerBowlResult = list.firstWhere((r) => r.recipe.name == 'Keto Paneer Bowl');
      expect(paneerBowlResult.inStockCount, greaterThan(0));
      expect(paneerBowlResult.matchPercentage, greaterThan(0.0));

      subscription.close();
      container.dispose();
    });

    test('Allergen filters exclude recipes', () async {
      // Mock pantry with paneer
      final mockPantry = [
        InventoryItem(
          id: '1',
          userId: 'user123',
          ingredientName: 'paneer',
          quantity: 200.0,
          unit: 'g',
          category: 'Protein',
          reorderThreshold: 50.0,
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          inventoryStreamProvider.overrideWith(
            (ref) => Stream.value(mockPantry),
          ),
        ],
      );

      // Keep the provider alive by listening to it
      final subscription = container.listen(
        matchingRecipesProvider,
        (previous, next) {},
      );

      await container.read(inventoryStreamProvider.future);

      // Active dairy filter
      container.read(allergyFiltersProvider.notifier).state = {'dairy'};

      final list = container.read(matchingRecipesProvider).value!;
      
      // "Keto Paneer Bowl" contains dairy, so it must be EXCLUDED!
      final hasPaneerBowl = list.any((r) => r.recipe.name == 'Keto Paneer Bowl');
      expect(hasPaneerBowl, isFalse);

      subscription.close();
      container.dispose();
    });
  });
}
