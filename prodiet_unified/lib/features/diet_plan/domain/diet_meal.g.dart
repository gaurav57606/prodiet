// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietMealImpl _$$DietMealImplFromJson(Map<String, dynamic> json) =>
    _$DietMealImpl(
      name: json['name'] as String,
      calories: (json['calories'] as num).toDouble(),
      proteinG: (json['proteinG'] as num).toDouble(),
      carbsG: (json['carbsG'] as num).toDouble(),
      fatG: (json['fatG'] as num).toDouble(),
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$DietMealImplToJson(_$DietMealImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
      'ingredients': instance.ingredients,
    };
