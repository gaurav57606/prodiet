// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietDayImpl _$$DietDayImplFromJson(Map<String, dynamic> json) =>
    _$DietDayImpl(
      dayNumber: (json['dayNumber'] as num).toInt(),
      breakfast: json['breakfast'] as String,
      lunch: json['lunch'] as String,
      dinner: json['dinner'] as String,
      snacks: json['snacks'] as String,
    );

Map<String, dynamic> _$$DietDayImplToJson(_$DietDayImpl instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'snacks': instance.snacks,
    };
