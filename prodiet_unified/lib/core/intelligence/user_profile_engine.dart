/// Dynamic user consistency score model containing macro adherence, variety, timing, and log metrics.
class UserBehaviorScore {
  final double consistencyScore; // 0.0 to 1.0 (frequency of logging)
  final double goalAdherenceIndex; // 0.0 to 1.0 (macro precision variance)
  final double varietyIndex; // 0.0 to 1.0 (diverse diet indicator)
  final double timingConsistencyIndex; // 0.0 to 1.0 (regularity of eating hours)
  final double ocrSuccessIndex; // 0.0 to 1.0 (ocr scanner autonomy)
  final int currentStreak;
  final int longestStreak;

  const UserBehaviorScore({
    required this.consistencyScore,
    required this.goalAdherenceIndex,
    required this.varietyIndex,
    required this.timingConsistencyIndex,
    required this.ocrSuccessIndex,
    required this.currentStreak,
    required this.longestStreak,
  });

  /// Blends behavior parameters into an aggregate intelligence score.
  double get overallScore {
    return (consistencyScore * 0.3) +
        (goalAdherenceIndex * 0.3) +
        (varietyIndex * 0.15) +
        (timingConsistencyIndex * 0.15) +
        (ocrSuccessIndex * 0.1);
  }
}

/// Dynamic weighting criteria used by recommendation scoring routines.
class RecommendationWeights {
  final double nutritionWeight;
  final double varietyWeight;
  final double streakWeight;
  final double timingMatchWeight;

  const RecommendationWeights({
    required this.nutritionWeight,
    required this.varietyWeight,
    required this.streakWeight,
    required this.timingMatchWeight,
  });

  Map<String, double> toMap() => {
        'nutrition': nutritionWeight,
        'variety': varietyWeight,
        'streak': streakWeight,
        'timingMatch': timingMatchWeight,
      };
}

/// Comprehensive intelligence profile capturing user habits over a rolling temporal baseline.
class UserIntelligenceProfile {
  final List<String> dietaryPreferences;
  final Map<String, List<double>> mealTimingHabits; // e.g., {'breakfast': [8.0, 8.5, 9.2]} in decimal hours
  final Map<String, double> macroVariances; // e.g., {'protein': 12.5, 'carbs': 24.1}
  final int ocrTotalScans;
  final int ocrCorrectionCount;
  final Map<String, int> foodFrequency; // Food item name to count of logs
  final int currentStreak;
  final int longestStreak;
  final List<bool> lastFortnightLogs;

  const UserIntelligenceProfile({
    required this.dietaryPreferences,
    required this.mealTimingHabits,
    required this.macroVariances,
    required this.ocrTotalScans,
    required this.ocrCorrectionCount,
    required this.foodFrequency,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastFortnightLogs,
  });

  factory UserIntelligenceProfile.empty() {
    return const UserIntelligenceProfile(
      dietaryPreferences: [],
      mealTimingHabits: {},
      macroVariances: {},
      ocrTotalScans: 0,
      ocrCorrectionCount: 0,
      foodFrequency: {},
      currentStreak: 0,
      longestStreak: 0,
      lastFortnightLogs: [],
    );
  }
}

/// Adaptive engine learning user habits and scoring logging behavior.
class UserProfileEngine {
  /// Computes a comprehensive UserBehaviorScore by processing historical metrics.
  UserBehaviorScore computeBehaviorScore(UserIntelligenceProfile profile) {
    // 1. Calculate logging consistency ratio (rolling fortnight)
    double consistency = 0.0;
    if (profile.lastFortnightLogs.isNotEmpty) {
      final logsCount = profile.lastFortnightLogs.where((logged) => logged).length;
      consistency = logsCount / profile.lastFortnightLogs.length;
    }

    // 2. Goal adherence index (inverse of mean variance error, mapped to a 0-1 scale)
    double totalVariance = 0.0;
    int varianceCount = 0;
    profile.macroVariances.forEach((_, value) {
      totalVariance += value;
      varianceCount++;
    });
    final averageVariance = varianceCount > 0 ? (totalVariance / varianceCount) : 0.0;
    final adherence = (1.0 - (averageVariance / 100.0)).clamp(0.0, 1.0);

    // 3. Variety index: unique foods logged vs total logged count
    double variety = 1.0;
    int totalLoggedItems = 0;
    profile.foodFrequency.forEach((_, count) => totalLoggedItems += count);
    if (totalLoggedItems > 0 && profile.foodFrequency.isNotEmpty) {
      final uniqueCount = profile.foodFrequency.length;
      variety = (uniqueCount / totalLoggedItems).clamp(0.1, 1.0);
    }

    // 4. Timing consistency index: variance of meal hours
    double timingConsistency = 1.0;
    int totalMealTypesWithData = 0;
    double cumulativeTimingVariance = 0.0;

    profile.mealTimingHabits.forEach((mealType, hours) {
      if (hours.length >= 2) {
        totalMealTypesWithData++;
        final mean = hours.reduce((a, b) => a + b) / hours.length;
        final sumOfSquaredDiffs = hours.map((h) => (h - mean) * (h - mean)).reduce((a, b) => a + b);
        final variance = sumOfSquaredDiffs / hours.length;
        cumulativeTimingVariance += variance;
      }
    });

    if (totalMealTypesWithData > 0) {
      final averageTimingVariance = cumulativeTimingVariance / totalMealTypesWithData;
      // Map variance to score: variance > 3.0 hours squared drops timing index
      timingConsistency = (1.0 - (averageTimingVariance / 3.0)).clamp(0.1, 1.0);
    }

    // 5. OCR Scanner precision index
    double ocrPrecision = 1.0;
    if (profile.ocrTotalScans > 0) {
      ocrPrecision = (1.0 - (profile.ocrCorrectionCount / profile.ocrTotalScans)).clamp(0.0, 1.0);
    }

    return UserBehaviorScore(
      consistencyScore: consistency,
      goalAdherenceIndex: adherence,
      varietyIndex: variety,
      timingConsistencyIndex: timingConsistency,
      ocrSuccessIndex: ocrPrecision,
      currentStreak: profile.currentStreak,
      longestStreak: profile.longestStreak,
    );
  }

  /// Calculates adaptive weights based on a user's behavior score.
  /// If consistency or goal adherence is low, we prioritize high-nutrition safety nets.
  /// If behavior matches goals perfectly, we relax nutrition constraint in favor of diet variety.
  RecommendationWeights adjustWeights(UserBehaviorScore score) {
    if (score.consistencyScore < 0.5 || score.goalAdherenceIndex < 0.5) {
      // Prioritize primary nutritional stability & safety nets
      return const RecommendationWeights(
        nutritionWeight: 0.65,
        varietyWeight: 0.10,
        streakWeight: 0.10,
        timingMatchWeight: 0.15,
      );
    } else {
      // Shift toward rich menu exploration, variety, and timeline timing alignment
      return const RecommendationWeights(
        nutritionWeight: 0.35,
        varietyWeight: 0.35,
        streakWeight: 0.15,
        timingMatchWeight: 0.15,
      );
    }
  }
}
