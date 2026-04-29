// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
      calories: (json['calories'] as num).toDouble(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: $enumDecode(_$MealStatusEnumMap, json['status']),
      plannedDate: DateTime.parse(json['plannedDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
      'ingredients': instance.ingredients,
      'status': _$MealStatusEnumMap[instance.status]!,
      'plannedDate': instance.plannedDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
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
