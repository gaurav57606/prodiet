class DietPlan {
  final String id;
  final String userId;
  final String planName;
  final String? description;
  final String? nutritionistNotes;
  final String startDate;
  final String endDate;
  final int dailyCalories;
  final int dailyProteinG;
  final int dailyCarbsG;
  final int dailyFatG;

  const DietPlan({
    required this.id,
    required this.userId,
    required this.planName,
    this.description,
    this.nutritionistNotes,
    required this.startDate,
    required this.endDate,
    required this.dailyCalories,
    required this.dailyProteinG,
    required this.dailyCarbsG,
    required this.dailyFatG,
  });

  bool get isActive {
    final now = DateTime.now();
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return now.isAfter(start.subtract(const Duration(seconds: 1))) &&
        now.isBefore(end.add(const Duration(days: 1)));
  }

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      id: json['id'],
      userId: json['user_id'],
      planName: json['plan_name'],
      description: json['description'],
      nutritionistNotes: json['nutritionist_notes'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      dailyCalories: (json['daily_calories'] as num? ?? 0).toInt(),
      dailyProteinG: (json['daily_protein_g'] as num? ?? 0).toInt(),
      dailyCarbsG: (json['daily_carbs_g'] as num? ?? 0).toInt(),
      dailyFatG: (json['daily_fat_g'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'plan_name': planName,
      'description': description,
      'nutritionist_notes': nutritionistNotes,
      'start_date': startDate,
      'end_date': endDate,
      'daily_calories': dailyCalories,
      'daily_protein_g': dailyProteinG,
      'daily_carbs_g': dailyCarbsG,
      'daily_fat_g': dailyFatG,
    };
  }
}
