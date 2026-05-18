// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeightEntry _$WeightEntryFromJson(Map<String, dynamic> json) => _WeightEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
    );

Map<String, dynamic> _$WeightEntryToJson(_WeightEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'weightKg': instance.weightKg,
      'loggedAt': instance.loggedAt.toIso8601String(),
    };
