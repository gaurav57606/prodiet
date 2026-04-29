import 'package:freezed_annotation/freezed_annotation.dart';
import 'diet_plan.dart';

part 'diet_plan_state.freezed.dart';

@freezed
sealed class DietPlanState with _$DietPlanState {
  const factory DietPlanState.initial() = DietPlanInitial;
  const factory DietPlanState.loading() = DietPlanLoading;
  const factory DietPlanState.loaded(DietPlan plan) = DietPlanLoaded;
  const factory DietPlanState.error(String message) = DietPlanError;
}
