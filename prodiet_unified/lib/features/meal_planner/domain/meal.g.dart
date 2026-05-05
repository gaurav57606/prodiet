// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      mealType: $enumDecode(_$MealTypeEnumMap, json['meal_type']),
      calories: (json['calories'] as num).toDouble(),
      proteinG: (json['protein_g'] as num).toDouble(),
      carbsG: (json['carbs_g'] as num).toDouble(),
      fatG: (json['fat_g'] as num).toDouble(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: $enumDecode(_$MealStatusEnumMap, json['status']),
      plannedDate: DateTime.parse(json['planned_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'meal_type': _$MealTypeEnumMap[instance.mealType]!,
      'calories': instance.calories,
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
      'ingredients': instance.ingredients,
      'status': _$MealStatusEnumMap[instance.status]!,
      'planned_date': instance.plannedDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};

const _$MealStatusEnumMap = {
  MealStatus.pending: 'pending',
  MealStatus.eaten: 'eaten',
  MealStatus.skipped: 'skipped',
};
