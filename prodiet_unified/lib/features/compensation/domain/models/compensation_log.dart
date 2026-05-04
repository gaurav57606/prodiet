class CompensationLog {
  final String id;
  final String userId;
  final String originalMealId;
  final int missedCalories;
  final int missedProteinG;
  final String compensationType; // e.g., 'skipped', 'late'
  final String appliedToDate;
  final Map<String, dynamic>? aiAdjustmentJson;
  final DateTime createdAt;

  const CompensationLog({
    required this.id,
    required this.userId,
    required this.originalMealId,
    required this.missedCalories,
    required this.missedProteinG,
    required this.compensationType,
    required this.appliedToDate,
    this.aiAdjustmentJson,
    required this.createdAt,
  });

  factory CompensationLog.fromJson(Map<String, dynamic> json) {
    return CompensationLog(
      id: json['id'],
      userId: json['user_id'],
      originalMealId: json['original_meal_id'],
      missedCalories: (json['missed_calories'] as num? ?? 0).toInt(),
      missedProteinG: (json['missed_protein_g'] as num? ?? 0).toInt(),
      compensationType: json['compensation_type'] ?? 'skipped',
      appliedToDate: json['applied_to_date'],
      aiAdjustmentJson: json['ai_adjustment_json'],
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'original_meal_id': originalMealId,
      'missed_calories': missedCalories,
      'missed_protein_g': missedProteinG,
      'compensation_type': compensationType,
      'applied_to_date': appliedToDate,
      'ai_adjustment_json': aiAdjustmentJson,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get reason => compensationType;
  Map<String, dynamic> get planAdjustments => aiAdjustmentJson ?? {};
}
