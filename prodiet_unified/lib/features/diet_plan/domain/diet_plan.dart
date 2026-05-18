import 'package:freezed_annotation/freezed_annotation.dart';
import 'diet_day.dart';

part 'diet_plan.freezed.dart';
part 'diet_plan.g.dart';

@freezed
abstract class DietPlan with _$DietPlan {
  const factory DietPlan({
    required String id,
    required String userId,
    required DateTime generatedAt,
    required List<DietDay> days,
    required double summaryCalories,
    required double summaryProteinG,
    required double summaryCarbsG,
    required double summaryFatG,
    required bool isActive,
  }) = _DietPlan;

  factory DietPlan.fromJson(Map<String, dynamic> json) => _$DietPlanFromJson(json);
}
