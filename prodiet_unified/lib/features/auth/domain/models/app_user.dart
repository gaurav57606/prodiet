class AppUser {
  final String id;
  final String email;
  final String? name;
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final List<String> allergies;
  final List<String> dietaryPreferences;
  final String? fitnessGoal;
  // Valid values: 'lose_weight' | 'gain_muscle' | 'maintain' | 'eat_healthy'
  final String? activityLevel;
  // Valid values: 'sedentary' | 'light' | 'moderate' | 'very_active'
  final bool onboardingComplete;
  final int dailyWaterGoalMl;
  final int? dailyCalorieGoal;
  final String? fcmToken;
  final String varietyPreference;
  // Valid values: 'same' | 'balanced' | 'variety'
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.weightKg,
    this.heightCm,
    this.allergies = const [],
    this.dietaryPreferences = const [],
    this.fitnessGoal,
    this.activityLevel,
    this.onboardingComplete = false,
    this.dailyWaterGoalMl = 2000,
    this.dailyCalorieGoal,
    this.fcmToken,
    this.varietyPreference = 'balanced',
    required this.createdAt,
    this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      age: json['age'] as int?,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      dietaryPreferences: (json['dietary_preferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      fitnessGoal: json['fitness_goal'] as String?,
      activityLevel: json['activity_level'] as String?,
      onboardingComplete: json['onboarding_complete'] as bool? ?? false,
      dailyWaterGoalMl: json['daily_water_goal_ml'] as int? ?? 2000,
      dailyCalorieGoal: json['daily_calorie_goal'] as int?,
      fcmToken: json['fcm_token'] as String?,
      varietyPreference: json['variety_preference'] as String? ?? 'balanced',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'email': email,
      'onboarding_complete': onboardingComplete,
      'daily_water_goal_ml': dailyWaterGoalMl,
      'variety_preference': varietyPreference,
      'created_at': createdAt.toIso8601String(),
    };

    if (name != null) map['name'] = name;
    if (age != null) map['age'] = age;
    if (weightKg != null) map['weight_kg'] = weightKg;
    if (heightCm != null) map['height_cm'] = heightCm;
    if (allergies.isNotEmpty) map['allergies'] = allergies;
    if (dietaryPreferences.isNotEmpty) {
      map['dietary_preferences'] = dietaryPreferences;
    }
    if (fitnessGoal != null) map['fitness_goal'] = fitnessGoal;
    if (activityLevel != null) map['activity_level'] = activityLevel;
    if (dailyCalorieGoal != null) map['daily_calorie_goal'] = dailyCalorieGoal;
    if (fcmToken != null) map['fcm_token'] = fcmToken;
    if (updatedAt != null) map['updated_at'] = updatedAt!.toIso8601String();

    return map;
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    int? age,
    double? weightKg,
    double? heightCm,
    List<String>? allergies,
    List<String>? dietaryPreferences,
    String? fitnessGoal,
    String? activityLevel,
    bool? onboardingComplete,
    int? dailyWaterGoalMl,
    int? dailyCalorieGoal,
    String? fcmToken,
    String? varietyPreference,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      allergies: allergies ?? this.allergies,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      activityLevel: activityLevel ?? this.activityLevel,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      dailyWaterGoalMl: dailyWaterGoalMl ?? this.dailyWaterGoalMl,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      fcmToken: fcmToken ?? this.fcmToken,
      varietyPreference: varietyPreference ?? this.varietyPreference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed helpers used across the app
  double? get bmi {
    if (weightKg == null || heightCm == null) return null;
    final h = heightCm! / 100;
    return weightKg! / (h * h);
  }

  String get bmiCategory {
    final b = bmi;
    if (b == null) return 'Unknown';
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  bool get hasCompletedHealthGoals =>
      fitnessGoal != null &&
      activityLevel != null &&
      weightKg != null &&
      heightCm != null;
}
