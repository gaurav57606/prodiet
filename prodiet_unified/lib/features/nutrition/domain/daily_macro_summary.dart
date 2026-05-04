class DailyMacroSummary {
  final String date;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const DailyMacroSummary({
    required this.date,
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });

  DailyMacroSummary copyWith({
    String? date,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
  }) {
    return DailyMacroSummary(
      date: date ?? this.date,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }
}
