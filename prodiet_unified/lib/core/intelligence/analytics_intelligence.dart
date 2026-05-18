/// Models a dynamic card structure streamed to the dashboard UI.
class DynamicInsightCard {
  final String id;
  final String title;
  final String description;
  final String type; // 'anomaly', 'habit', 'progress', 'tip'
  final String badgeText;
  final String severity; // 'low', 'medium', 'high'

  const DynamicInsightCard({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.badgeText,
    required this.severity,
  });
}

/// Dynamic nutrition anomaly model representing specific micro-nutrient spikes.
class NutritionAnomaly {
  final String nutrient; // 'sodium', 'sugar', 'cholesterol', 'saturated_fat'
  final double loggedValue;
  final double recommendedLimit;
  final DateTime date;

  const NutritionAnomaly({
    required this.nutrient,
    required this.loggedValue,
    required this.recommendedLimit,
    required this.date,
  });
}

/// Deep behavior intelligence engine identifying trends and anomalies.
class AnalyticsIntelligence {
  /// Baseline dietary limits mapping to daily nutritional bounds
  static const double limitSodium = 2300.0; // mg
  static const double limitSugar = 50.0; // grams
  static const double limitCholesterol = 300.0; // mg
  static const double limitSaturatedFat = 20.0; // grams

  /// Detects nutritional micro-anomalies across logs.
  List<NutritionAnomaly> detectAnomalies(List<Map<String, dynamic>> dailyMacroLogs) {
    final List<NutritionAnomaly> anomalies = [];

    for (final log in dailyMacroLogs) {
      final date = log['date'] as DateTime? ?? DateTime.now();

      // 1. Sodium excess scan
      final sodium = (log['sodium'] as num?)?.toDouble() ?? 0.0;
      if (sodium > limitSodium) {
        anomalies.add(NutritionAnomaly(
          nutrient: 'sodium',
          loggedValue: sodium,
          recommendedLimit: limitSodium,
          date: date,
        ));
      }

      // 2. Sugar excess scan
      final sugar = (log['sugar'] as num?)?.toDouble() ?? 0.0;
      if (sugar > limitSugar) {
        anomalies.add(NutritionAnomaly(
          nutrient: 'sugar',
          loggedValue: sugar,
          recommendedLimit: limitSugar,
          date: date,
        ));
      }

      // 3. Cholesterol excess scan
      final cholesterol = (log['cholesterol'] as num?)?.toDouble() ?? 0.0;
      if (cholesterol > limitCholesterol) {
        anomalies.add(NutritionAnomaly(
          nutrient: 'cholesterol',
          loggedValue: cholesterol,
          recommendedLimit: limitCholesterol,
          date: date,
        ));
      }

      // 4. Saturated fat excess scan
      final satFat = (log['saturated_fat'] as num?)?.toDouble() ?? 0.0;
      if (satFat > limitSaturatedFat) {
        anomalies.add(NutritionAnomaly(
          nutrient: 'saturated_fat',
          loggedValue: satFat,
          recommendedLimit: limitSaturatedFat,
          date: date,
        ));
      }
    }

    return anomalies;
  }

  /// Evaluates historical meals and anomalies to extract actionable behavioral insights.
  List<DynamicInsightCard> generateInsights({
    required List<Map<String, dynamic>> mealHistory,
    required List<NutritionAnomaly> activeAnomalies,
  }) {
    final List<DynamicInsightCard> cards = [];

    // 1. Process Anomalies
    if (activeAnomalies.isNotEmpty) {
      final Map<String, int> counts = {};
      for (final a in activeAnomalies) {
        counts[a.nutrient] = (counts[a.nutrient] ?? 0) + 1;
      }

      counts.forEach((nutrient, count) {
        if (count >= 2) {
          cards.add(DynamicInsightCard(
            id: 'ins_anomaly_spike_$nutrient',
            title: '${nutrient.toUpperCase().replaceAll('_', ' ')} Limit Surge',
            description: 'Your logged $nutrient exceeded optimal baseline levels on $count days. Swap in whole-grain options to offset spikes.',
            type: 'anomaly',
            badgeText: 'ANOMALY DETECTED',
            severity: 'medium',
          ));
        }
      });
    }

    // 2. Behavioral Habit Classifiers (Rolling Window Evaluation)
    int daysEvaluated = 0;
    int breakfastSkips = 0;
    int lateSnacks = 0;
    int weekendCalorieSpikes = 0;

    for (final meal in mealHistory) {
      final hour = (meal['hour'] as num?)?.toInt() ?? 12;
      final mealType = meal['meal_type'] as String? ?? 'lunch';
      final date = meal['date'] as DateTime? ?? DateTime.now();
      final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      final calories = (meal['calories'] as num?)?.toDouble() ?? 0.0;

      // 2a. Breakfast Skipper Classifier
      if (mealType == 'breakfast') {
        daysEvaluated++;
        if (hour >= 11) {
          breakfastSkips++;
        }
      }

      // 2b. Late Snacking Classifier (High carbs logged past 10:00 PM)
      if (mealType == 'snack' && hour >= 22) {
        lateSnacks++;
      }

      // 2c. Weekend Calorie Spiker Classifier
      if (isWeekend && calories > 1200.0) {
        weekendCalorieSpikes++;
      }
    }

    // Evaluate Breakfast Skips (Trigger if skip rate > 50%)
    if (daysEvaluated >= 3 && (breakfastSkips / daysEvaluated) > 0.5) {
      cards.add(const DynamicInsightCard(
        id: 'ins_habit_breakfast_skipper',
        title: 'Frequent Breakfast Skipper',
        description: 'You skip or delay breakfast past 11:00 AM on 50%+ of tracked days. Eating breakfast early improves sustained energy focus.',
        type: 'habit',
        badgeText: 'HABIT CLASSIFIED',
        severity: 'low',
      ));
    }

    // Evaluate Late Snacking (Trigger if late snacks count exceeds 2)
    if (lateSnacks >= 2) {
      cards.add(const DynamicInsightCard(
        id: 'ins_habit_late_snacking',
        title: 'Late Night Snacking Trend',
        description: 'Multiple snacks logged past 10:00 PM. Late-night digestion cycles can cause micro-disruptions in deep REM sleep.',
        type: 'habit',
        badgeText: 'HABIT CLASSIFIED',
        severity: 'low',
      ));
    }

    // Evaluate Weekend Calorie Spikes
    if (weekendCalorieSpikes >= 2) {
      cards.add(const DynamicInsightCard(
        id: 'ins_habit_weekend_spiker',
        title: 'Weekend Calorie Spikes',
        description: 'Substantial calorie spikes detected during the weekend. Establish a balanced target cheat window to lock in weight goals.',
        type: 'habit',
        badgeText: 'WEEKEND ANOMALY',
        severity: 'medium',
      ));
    }

    // 3. Safe Fallback card to promote positive progression
    if (cards.isEmpty) {
      cards.add(const DynamicInsightCard(
        id: 'ins_perfect_score',
        title: 'Outstanding Macro Discipline',
        description: 'Your logged profile reports zero anomalies or delayed timings. Maintain this high-adherence streak!',
        type: 'progress',
        badgeText: 'ON TRACK',
        severity: 'low',
      ));
    }

    return cards;
  }
}
