import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

enum MealType { breakfast, lunch, dinner, snack }
enum MealStatus { pending, eaten, skipped }

@freezed
class Meal with _$Meal {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Meal({
    required String id,
    required String userId,
    required String name,
    required MealType mealType,
    required double calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
    required List<String> ingredients,
    required MealStatus status,
    required DateTime plannedDate,
    required DateTime createdAt,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
