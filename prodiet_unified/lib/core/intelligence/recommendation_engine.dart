import 'dart:async';
import 'inference_abstraction.dart';
import 'user_profile_engine.dart';

/// Models a highly structured intelligence card or recommendation item.
class RecommendationItem {
  final String id;
  final String title;
  final String category; // 'meal', 'alternative', 'hydration', 'grocery', 'calorie', 'correction'
  final String description;
  final double score;
  final Map<String, dynamic> metadata;

  const RecommendationItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.score,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'score': score,
        'metadata': metadata,
      };
}

/// The core logical validation boundary that ensures recommendations match nutritional policies,
/// active allergies, and user preference bounds.
class NutritionIntelligenceLayer {
  /// Validates a list of suggested food items against user allergy rules.
  List<RecommendationItem> applyNutritionalFiltering(
    List<RecommendationItem> items, {
    required List<String> userAllergies,
    required String dietType,
  }) {
    final cleanAllergies = userAllergies.map((a) => a.trim().toLowerCase()).toList();
    final lowerDietType = dietType.toLowerCase();

    return items.where((item) {
      final ingredients = (item.metadata['ingredients'] as List<String>? ?? [])
          .map((i) => i.toLowerCase())
          .toList();

      // 1. Allergies exclusion checks
      for (final allergy in cleanAllergies) {
        if (ingredients.contains(allergy) ||
            item.title.toLowerCase().contains(allergy) ||
            item.description.toLowerCase().contains(allergy)) {
          return false;
        }
      }

      // 2. Strict diet constraint compliance
      final isVeganItem = item.metadata['is_vegan'] as bool? ?? false;
      final isVegetarianItem = item.metadata['is_vegetarian'] as bool? ?? isVeganItem;

      if (lowerDietType == 'vegan' && !isVeganItem) {
        return false;
      }
      if (lowerDietType == 'vegetarian' && !isVegetarianItem) {
        return false;
      }
      return true;
    }).toList();
  }
}

/// Dynamic recommendation engine providing customized calorie guidance, food swaps, and hydration insights.
class RecommendationEngine {
  final BaseInferenceEngine _localInference;
  final NutritionIntelligenceLayer _nutritionLayer = NutritionIntelligenceLayer();

  // Simple in-memory cache to guarantee sub-millisecond execution times and zero UI blocking
  final Map<String, List<RecommendationItem>> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const _cacheValidityDuration = Duration(minutes: 5);

  RecommendationEngine(this._localInference);

  /// Resolves top recommendations, blending local inference with user macro logs and behavior weights.
  Future<List<RecommendationItem>> computeRecommendations({
    required double remainingCalories,
    required double proteinTargetGrams,
    required List<String> recentAllergies,
    required String dietType,
    required RecommendationWeights behaviorWeights,
  }) async {
    final cacheKey = '${remainingCalories.toStringAsFixed(1)}_${proteinTargetGrams.toStringAsFixed(1)}_${recentAllergies.join(",")}_$dietType';
    
    // Return cached results if within validity bounds
    if (_cache.containsKey(cacheKey) && _cacheTimestamps.containsKey(cacheKey)) {
      final elapsed = DateTime.now().difference(_cacheTimestamps[cacheKey]!);
      if (elapsed < _cacheValidityDuration) {
        return _cache[cacheKey]!;
      }
    }

    // 1. Invoke local ML thread to classify active macro requirements
    final mlResult = await _localInference.executeInference({
      'type': 'macro_score',
      'protein': proteinTargetGrams,
      'carbs': 150.0,
      'fat': 60.0,
    });

    final classification = mlResult['classification'] as String? ?? 'balanced';
    final List<RecommendationItem> candidates = [];

    // 2. Calorie deficit or surplus correction mapping
    if (remainingCalories > 500) {
      candidates.add(RecommendationItem(
        id: 'rec_calorie_deficit',
        title: 'High Protein Casein window open',
        category: 'calorie',
        description: 'You have ${remainingCalories.toInt()} kcal left today. Consider a dense protein snack to fuel recovery.',
        score: 0.95 * behaviorWeights.nutritionWeight,
        metadata: const {
          'ingredients': ['dairy', 'whey', 'yogurt'],
          'is_vegetarian': true,
          'is_vegan': false,
        },
      ));
    } else if (remainingCalories < 0) {
      candidates.add(RecommendationItem(
        id: 'rec_calorie_surplus',
        title: 'Calorie Limit Reached',
        category: 'calorie',
        description: 'Daily allowance exceeded. Shift focus to heavy hydration and fiber-rich snacks.',
        score: 0.90 * behaviorWeights.nutritionWeight,
        metadata: const {
          'ingredients': ['water', 'fiber', 'celery'],
          'is_vegetarian': true,
          'is_vegan': true,
        },
      ));
    }

    // 3. Macronutrient blending logic based on ML classification
    if (classification == 'high_protein') {
      candidates.add(RecommendationItem(
        id: 'rec_meal_greek_yogurt',
        title: 'Greek Yogurt & Blueberries',
        category: 'meal',
        description: 'Casein-rich snack providing sustained release amino acids during overnight recovery.',
        score: 0.88 * behaviorWeights.nutritionWeight,
        metadata: const {
          'ingredients': ['dairy', 'milk', 'yogurt', 'blueberries'],
          'is_vegetarian': true,
          'is_vegan': false,
        },
      ));

      candidates.add(RecommendationItem(
        id: 'rec_meal_tofu_stirfry',
        title: 'Edamame Tofu Stirfry',
        category: 'meal',
        description: 'A 100% plant-based high-protein option dense in plant minerals and fibers.',
        score: 0.85 * behaviorWeights.varietyWeight,
        metadata: const {
          'ingredients': ['tofu', 'soy', 'edamame', 'broccoli'],
          'is_vegetarian': true,
          'is_vegan': true,
        },
      ));
    }

    // 4. Healthy alternative swap items
    candidates.add(RecommendationItem(
      id: 'rec_alt_swap_dressing',
      title: 'Swap processed salt dressings',
      category: 'alternative',
      description: 'Exchange factory salad dressings with extra virgin olive oil and fresh lemon extraction.',
      score: 0.82 * behaviorWeights.varietyWeight,
      metadata: const {
        'ingredients': ['olive oil', 'lemon'],
        'is_vegetarian': true,
        'is_vegan': true,
      },
    ));

    // 5. Grocery replenishment cards
    candidates.add(RecommendationItem(
      id: 'rec_grocery_almonds',
      title: 'Replenish organic almonds',
      category: 'grocery',
      description: 'Excellent source of monounsaturated fats. Helps stabilize mid-day craving spikes.',
      score: 0.75 * behaviorWeights.streakWeight,
      metadata: const {
        'ingredients': ['nuts', 'almonds'],
        'is_vegetarian': true,
        'is_vegan': true,
      },
    ));

    // 6. Filter predictions using our NutritionIntelligenceLayer
    final filtered = _nutritionLayer.applyNutritionalFiltering(
      candidates,
      userAllergies: recentAllergies,
      dietType: dietType,
    );

    // 7. Sort descending by computed weight scores
    filtered.sort((a, b) => b.score.compareTo(a.score));

    // Commit to cache
    _cache[cacheKey] = filtered;
    _cacheTimestamps[cacheKey] = DateTime.now();

    return filtered;
  }

  /// Calculates dynamic hydration reminders based on daily objective percentages.
  List<RecommendationItem> generateHydrationPrompts(int currentMl, int targetMl) {
    if (currentMl >= targetMl) {
      return [
        const RecommendationItem(
          id: 'hyd_goal_met',
          title: 'Hydration Target Achieved!',
          category: 'hydration',
          description: 'Flawless execution! Optimal cellular hydration achieved for the day.',
          score: 1.0,
        )
      ];
    }

    final deficit = targetMl - currentMl;
    final score = (deficit / targetMl).clamp(0.2, 0.95);

    return [
      RecommendationItem(
        id: 'hyd_reminder_standard',
        title: 'Drink 250ml of Water',
        category: 'hydration',
        description: 'You are $deficit ml away from your daily baseline. Take a glass now to sustain cognitive clarity.',
        score: score,
      )
    ];
  }

  /// Clears in-memory suggestion cache to respect privacy purging guidelines.
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }
}
