import 'package:freezed_annotation/freezed_annotation.dart';

part 'diet_meal.freezed.dart';
part 'diet_meal.g.dart';

@freezed
class DietMeal with _$DietMeal {
  const factory DietMeal({
    required String name,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required List<String> ingredients,
  }) = _DietMeal;

  factory DietMeal.fromJson(Map<String, dynamic> json) =>
      _$DietMealFromJson(json);
}
