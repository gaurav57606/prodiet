import 'package:freezed_annotation/freezed_annotation.dart';
import 'diet_meal.dart';

part 'diet_day.freezed.dart';
part 'diet_day.g.dart';

@freezed
abstract class DietDay with _$DietDay {
  const DietDay._();

  const factory DietDay({
    required int dayNumber,
    required List<DietMeal> breakfast,
    required List<DietMeal> lunch,
    required List<DietMeal> dinner,
    required List<DietMeal> snacks,
    required double totalCalories,
  }) = _DietDay;

  List<DietMeal> get meals => [...breakfast, ...lunch, ...dinner, ...snacks];

  factory DietDay.fromJson(Map<String, dynamic> json) => _$DietDayFromJson(json);
}
