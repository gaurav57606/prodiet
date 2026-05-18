import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:prodiet_unified/features/inventory/application/inventory_providers.dart';
import 'package:prodiet_unified/features/recipe/data/recipe_book.dart';
import 'package:prodiet_unified/features/recipe/domain/recipe.dart';

class MatchingRecipeResult {
  final Recipe recipe;
  final double matchPercentage;
  final int inStockCount;
  final int totalCount;
  final List<RecipeIngredient> missingIngredients;
  final List<RecipeIngredient> inStockIngredients;

  MatchingRecipeResult({
    required this.recipe,
    required this.matchPercentage,
    required this.inStockCount,
    required this.totalCount,
    required this.missingIngredients,
    required this.inStockIngredients,
  });
}

/// Simple provider for static recipe cookbook
final recipeBookProvider = Provider<List<Recipe>>((ref) {
  return RecipeBook.recipes;
});

/// Set of active allergen filters ("dairy", "nuts", "gluten")
final allergyFiltersProvider = StateProvider<Set<String>>((ref) {
  return {};
});

/// Dynamic matching processor provider
final matchingRecipesProvider = Provider<AsyncValue<List<MatchingRecipeResult>>>((ref) {
  final recipes = ref.watch(recipeBookProvider);
  final activeAllergens = ref.watch(allergyFiltersProvider);
  final inventoryAsync = ref.watch(inventoryStreamProvider);

  return inventoryAsync.when(
    data: (itemsList) {
      // Map pantry item names (lowercased)
      final pantryMap = <String, double>{};
      for (var item in itemsList) {
        pantryMap[item.ingredientName.toLowerCase().trim()] = item.quantity;
      }

      final List<MatchingRecipeResult> results = [];

      for (var recipe in recipes) {
        // 1. Filter out recipes matching selected allergens
        bool containsAllergen = false;
        for (var allergen in recipe.allergens) {
          if (activeAllergens.contains(allergen.toLowerCase())) {
            containsAllergen = true;
            break;
          }
        }
        if (containsAllergen) continue;

        // 2. Determine match status for each required ingredient
        final List<RecipeIngredient> inStock = [];
        final List<RecipeIngredient> missing = [];

        for (var req in recipe.requiredIngredients) {
          final reqNameLower = req.name.toLowerCase().trim();
          bool hasIt = false;

          // Smart flexible string check
          for (var pantryName in pantryMap.keys) {
            if (pantryName == reqNameLower ||
                pantryName == '${reqNameLower}s' ||
                '${pantryName}s' == reqNameLower ||
                pantryName.contains(reqNameLower) ||
                reqNameLower.contains(pantryName)) {
              hasIt = true;
              break;
            }
          }

          if (hasIt) {
            inStock.add(req);
          } else {
            missing.add(req);
          }
        }

        // 3. Compute dynamic match percentage
        final total = recipe.requiredIngredients.length;
        final matchedCount = inStock.length;
        final pct = total > 0 ? (matchedCount / total) * 100 : 100.0;

        results.add(MatchingRecipeResult(
          recipe: recipe,
          matchPercentage: pct,
          inStockCount: matchedCount,
          totalCount: total,
          missingIngredients: missing,
          inStockIngredients: inStock,
        ));
      }

      // 4. Sort: highest match percentage first
      results.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));

      return AsyncValue.data(results);
    },
    error: (err, stack) => AsyncValue.error(err, stack),
    loading: () => const AsyncValue.loading(),
  );
});
