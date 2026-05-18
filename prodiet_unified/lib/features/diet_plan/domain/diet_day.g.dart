// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DietDay _$DietDayFromJson(Map<String, dynamic> json) => _DietDay(
      dayNumber: (json['dayNumber'] as num).toInt(),
      breakfast: (json['breakfast'] as List<dynamic>)
          .map((e) => DietMeal.fromJson(e as Map<String, dynamic>))
          .toList(),
      lunch: (json['lunch'] as List<dynamic>)
          .map((e) => DietMeal.fromJson(e as Map<String, dynamic>))
          .toList(),
      dinner: (json['dinner'] as List<dynamic>)
          .map((e) => DietMeal.fromJson(e as Map<String, dynamic>))
          .toList(),
      snacks: (json['snacks'] as List<dynamic>)
          .map((e) => DietMeal.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
    );

Map<String, dynamic> _$DietDayToJson(_DietDay instance) => <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'snacks': instance.snacks,
      'totalCalories': instance.totalCalories,
    };
