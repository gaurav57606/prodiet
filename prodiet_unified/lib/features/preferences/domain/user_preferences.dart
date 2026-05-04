class UserPreferences {
  final List<String> allergies;
  final String dietType;
  final int spiceLevel;
  final bool mealVariety;
  final bool onlineOrdering;
  final bool localVendors;
  final bool fitbandSync;
  final bool notifications;
  final List<String> cuisinePrefs;
  final int mealsPerDay;

  const UserPreferences({
    required this.allergies,
    required this.dietType,
    required this.spiceLevel,
    required this.mealVariety,
    required this.onlineOrdering,
    required this.localVendors,
    required this.fitbandSync,
    required this.notifications,
    required this.cuisinePrefs,
    required this.mealsPerDay,
  });

  UserPreferences copyWith({
    List<String>? allergies,
    String? dietType,
    int? spiceLevel,
    bool? mealVariety,
    bool? onlineOrdering,
    bool? localVendors,
    bool? fitbandSync,
    bool? notifications,
    List<String>? cuisinePrefs,
    int? mealsPerDay,
  }) {
    return UserPreferences(
      allergies: allergies ?? this.allergies,
      dietType: dietType ?? this.dietType,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      mealVariety: mealVariety ?? this.mealVariety,
      onlineOrdering: onlineOrdering ?? this.onlineOrdering,
      localVendors: localVendors ?? this.localVendors,
      fitbandSync: fitbandSync ?? this.fitbandSync,
      notifications: notifications ?? this.notifications,
      cuisinePrefs: cuisinePrefs ?? this.cuisinePrefs,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
    );
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      allergies: List<String>.from(map['allergies'] ?? []),
      dietType: map['dietary_preferences'] is List 
          ? (map['dietary_preferences'] as List).firstOrNull ?? "Non-Vegetarian"
          : map['dietary_preferences']?.toString() ?? "Non-Vegetarian",
      spiceLevel: map['spice_level'] as int? ?? 3,
      mealVariety: map['meal_variety'] as bool? ?? true,
      onlineOrdering: map['online_ordering'] as bool? ?? true,
      localVendors: map['local_vendors'] as bool? ?? false,
      fitbandSync: map['fitband_sync'] as bool? ?? true,
      notifications: map['notifications'] as bool? ?? true,
      cuisinePrefs: List<String>.from(map['cuisine_prefs'] ?? []),
      mealsPerDay: map['meals_per_day'] as int? ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allergies': allergies,
      'dietary_preferences': [dietType],
      'spice_level': spiceLevel,
      'meal_variety': mealVariety,
      'online_ordering': onlineOrdering,
      'local_vendors': localVendors,
      'fitband_sync': fitbandSync,
      'notifications': notifications,
      'cuisine_prefs': cuisinePrefs,
      'meals_per_day': mealsPerDay,
    };
  }

  static UserPreferences empty() => const UserPreferences(
        allergies: [],
        dietType: "Non-Vegetarian",
        spiceLevel: 3,
        mealVariety: true,
        onlineOrdering: true,
        localVendors: false,
        fitbandSync: true,
        notifications: true,
        cuisinePrefs: [],
        mealsPerDay: 5,
      );
}
