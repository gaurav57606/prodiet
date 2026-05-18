// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DietPlan _$DietPlanFromJson(Map<String, dynamic> json) => _DietPlan(
      id: json['id'] as String,
      userId: json['userId'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      days: (json['days'] as List<dynamic>)
          .map((e) => DietDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      summaryCalories: (json['summaryCalories'] as num).toDouble(),
      summaryProteinG: (json['summaryProteinG'] as num).toDouble(),
      summaryCarbsG: (json['summaryCarbsG'] as num).toDouble(),
      summaryFatG: (json['summaryFatG'] as num).toDouble(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$DietPlanToJson(_DietPlan instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'days': instance.days,
      'summaryCalories': instance.summaryCalories,
      'summaryProteinG': instance.summaryProteinG,
      'summaryCarbsG': instance.summaryCarbsG,
      'summaryFatG': instance.summaryFatG,
      'isActive': instance.isActive,
    };
