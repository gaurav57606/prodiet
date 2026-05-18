import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/core/intelligence/inference_abstraction.dart';
import 'package:prodiet_unified/core/intelligence/user_profile_engine.dart';
import 'package:prodiet_unified/core/intelligence/recommendation_engine.dart';
import 'package:prodiet_unified/core/intelligence/ocr_learning_system.dart';
import 'package:prodiet_unified/core/intelligence/analytics_intelligence.dart';
import 'package:prodiet_unified/core/intelligence/privacy_ethics_manager.dart';

void main() {
  group('Advanced Intelligence Layer Unit Tests', () {
    // 1. INFERENCE ABSTRACTION TESTS
    group('Inference Abstraction Layer', () {
      test('LocalMlEngine classifies high protein macro balance correctly', () async {
        final engine = LocalMlEngine();
        final result = await engine.executeInference({
          'type': 'macro_score',
          'protein': 80.0,
          'carbs': 30.0,
          'fat': 10.0,
        });

        expect(result['classification'], equals('high_protein'));
        expect(result['score'], equals(0.95));
      });

      test('LocalMlEngine classifies high carb macro balance correctly', () async {
        final engine = LocalMlEngine();
        final result = await engine.executeInference({
          'type': 'macro_score',
          'protein': 10.0,
          'carbs': 100.0,
          'fat': 10.0,
        });

        expect(result['classification'], equals('high_carb'));
        expect(result['score'], equals(0.8));
      });

      test('LocalMlEngine handles empty inputs gracefully', () async {
        final engine = LocalMlEngine();
        final result = await engine.executeInference({'type': 'macro_score'});

        expect(result['classification'], equals('balanced'));
        expect(result['score'], equals(1.0));
      });
    });

    // 2. USER PROFILE ENGINE TESTS
    group('UserProfileEngine', () {
      final engine = UserProfileEngine();

      test('Calculates behavior score correctly from profile properties', () {
        final profile = UserIntelligenceProfile(
          dietaryPreferences: const ['high-protein'],
          mealTimingHabits: const {
            'breakfast': [8.0, 8.2, 8.1]
          },
          macroVariances: const {'protein': 5.0},
          ocrTotalScans: 10,
          ocrCorrectionCount: 1,
          foodFrequency: const {'Apple': 5, 'Chicken': 10},
          currentStreak: 14,
          longestStreak: 20,
          lastFortnightLogs: List.filled(14, true),
        );

        final score = engine.computeBehaviorScore(profile);

        expect(score.consistencyScore, equals(1.0));
        expect(score.goalAdherenceIndex, equals(0.95));
        expect(score.ocrSuccessIndex, equals(0.9));
        expect(score.currentStreak, equals(14));
        expect(score.longestStreak, equals(20));
        expect(score.overallScore, isNotNull);
      });

      test('Adjusts recommendation weights dynamically based on profile score', () {
        const scoreLow = UserBehaviorScore(
          consistencyScore: 0.3,
          goalAdherenceIndex: 0.4,
          varietyIndex: 0.5,
          timingConsistencyIndex: 0.6,
          ocrSuccessIndex: 0.5,
          currentStreak: 1,
          longestStreak: 2,
        );
        final weightsLow = engine.adjustWeights(scoreLow);
        expect(weightsLow.nutritionWeight, equals(0.65));
        expect(weightsLow.varietyWeight, equals(0.1));

        const scoreHigh = UserBehaviorScore(
          consistencyScore: 0.9,
          goalAdherenceIndex: 0.95,
          varietyIndex: 0.8,
          timingConsistencyIndex: 0.9,
          ocrSuccessIndex: 0.95,
          currentStreak: 12,
          longestStreak: 20,
        );
        final weightsHigh = engine.adjustWeights(scoreHigh);
        expect(weightsHigh.nutritionWeight, equals(0.35));
        expect(weightsHigh.varietyWeight, equals(0.35));
      });
    });

    // 3. RECOMMENDATION ENGINE TESTS
    group('RecommendationEngine', () {
      final localMl = LocalMlEngine();
      final engine = RecommendationEngine(localMl);

      test('Generates high calorie open window advice', () async {
        const behaviorWeights = RecommendationWeights(
          nutritionWeight: 1.0,
          varietyWeight: 1.0,
          streakWeight: 1.0,
          timingMatchWeight: 1.0,
        );

        final recs = await engine.computeRecommendations(
          remainingCalories: 600.0,
          proteinTargetGrams: 90.0,
          recentAllergies: [],
          dietType: 'Non-Vegetarian',
          behaviorWeights: behaviorWeights,
        );

        expect(recs, isNotEmpty);
        final calorieRec = recs.firstWhere((r) => r.category == 'calorie');
        expect(calorieRec.id, equals('rec_calorie_deficit'));
        expect(calorieRec.score, equals(0.95));
      });

      test('Generates customized hydration prompts based on remaining targets', () {
        final prompts = engine.generateHydrationPrompts(1000, 2000);
        expect(prompts.length, equals(1));
        expect(prompts[0].id, equals('hyd_reminder_standard'));
        expect(prompts[0].score, equals(0.5));
      });
    });

    // 4. OCR LEARNING SYSTEM TESTS
    group('OcrLearningSystem', () {
      test('Learns correction map and fuzzy cleans typos using Levenshtein distance', () {
        final system = OcrLearningSystem();
        system.learnCorrection('Bannana', 'Banana');
        system.learnCorrection('Chiken', 'Chicken');

        // Test learned prediction
        expect(system.predictCorrection('Bannana'), equals('Banana'));

        // Test fuzzy prediction matching
        expect(system.predictCorrection('chikn'), equals('Chicken'));
      });

      test('Clear memory purges spelling adjustments correctly', () {
        final system = OcrLearningSystem();
        system.learnCorrection('Bannana', 'Banana');
        expect(system.predictCorrection('Bannana'), equals('Banana'));

        system.clearMemory();
        expect(system.predictCorrection('Bannana'), equals('Bannana'));
      });
    });

    // 5. ANALYTICS INTELLIGENCE TESTS
    group('AnalyticsIntelligence', () {
      final analytics = AnalyticsIntelligence();

      test('Detects sodium level spikes correctly', () {
        final logs = [
          {'sodium': 2400.0, 'date': DateTime.now()},
          {'sodium': 1200.0, 'date': DateTime.now()}
        ];
        final anomalies = analytics.detectAnomalies(logs);

        expect(anomalies.length, equals(1));
        expect(anomalies[0].nutrient, equals('sodium'));
        expect(anomalies[0].loggedValue, equals(2400.0));
      });

      test('Detects skips breakfast habit correctly', () {
        final history = [
          {'hour': 12, 'meal_type': 'breakfast', 'calories': 300.0, 'date': DateTime.now()},
          {'hour': 13, 'meal_type': 'breakfast', 'calories': 300.0, 'date': DateTime.now()},
          {'hour': 12, 'meal_type': 'breakfast', 'calories': 300.0, 'date': DateTime.now()},
        ];
        final insights = analytics.generateInsights(
          mealHistory: history,
          activeAnomalies: [],
        );

        expect(insights, isNotEmpty);
        final habitInsight = insights.firstWhere((i) => i.id == 'ins_habit_breakfast_skipper');
        expect(habitInsight.type, equals('habit'));
      });
    });

    // 6. PRIVACY & ETHICS MANAGER TESTS
    group('PrivacyEthicsManager', () {
      test('Erases learned OCR records structurally when personalization is toggled off', () {
        final ocr = OcrLearningSystem();
        final localMl = LocalMlEngine();
        final recs = RecommendationEngine(localMl);
        final privacy = PrivacyEthicsManager(ocr, recs);

        ocr.learnCorrection('Bannana', 'Banana');
        expect(ocr.predictCorrection('Bannana'), equals('Banana'));

        expect(privacy.isPersonalizationEnabled, isTrue);

        // Turn personalization off
        privacy.setPersonalizationPreference(false);
        expect(privacy.isPersonalizationEnabled, isFalse);

        // Verify spelling memory is deleted
        expect(ocr.predictCorrection('Bannana'), equals('Bannana'));
      });
    });
  });
}
