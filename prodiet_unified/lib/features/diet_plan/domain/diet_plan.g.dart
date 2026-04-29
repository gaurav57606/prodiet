// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DietPlanImpl _$$DietPlanImplFromJson(Map<String, dynamic> json) =>
    _$DietPlanImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      days: (json['days'] as List<dynamic>)
          .map((e) => DietDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      summaryCalories: (json['summaryCalories'] as num).toInt(),
      summaryProteinG: (json['summaryProteinG'] as num).toInt(),
      summaryCarbsG: (json['summaryCarbsG'] as num).toInt(),
      summaryFatG: (json['summaryFatG'] as num).toInt(),
      fitnessGoal: json['fitnessGoal'] as String,
      activityLevel: json['activityLevel'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      isFavorited: json['isFavorited'] as bool? ?? false,
    );

Map<String, dynamic> _$$DietPlanImplToJson(_$DietPlanImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'days': instance.days,
      'summaryCalories': instance.summaryCalories,
      'summaryProteinG': instance.summaryProteinG,
      'summaryCarbsG': instance.summaryCarbsG,
      'summaryFatG': instance.summaryFatG,
      'fitnessGoal': instance.fitnessGoal,
      'activityLevel': instance.activityLevel,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'isFavorited': instance.isFavorited,
    };
