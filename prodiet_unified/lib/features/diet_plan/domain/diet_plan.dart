import 'package:freezed_annotation/freezed_annotation.dart';
import 'diet_day.dart';

part 'diet_plan.freezed.dart';
part 'diet_plan.g.dart';

@freezed
class DietPlan with _$DietPlan {
  const factory DietPlan({
    required String id,
    required String userId,
    required List<DietDay> days,
    required int summaryCalories,
    required int summaryProteinG,
    required int summaryCarbsG,
    required int summaryFatG,
    required String fitnessGoal,
    required String activityLevel,
    required DateTime generatedAt,
    @Default(false) bool isFavorited,
  }) = _DietPlan;

  factory DietPlan.fromJson(Map<String, dynamic> json) => _$DietPlanFromJson(json);
}
