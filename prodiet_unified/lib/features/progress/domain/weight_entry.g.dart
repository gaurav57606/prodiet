// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeightEntryImpl _$$WeightEntryImplFromJson(Map<String, dynamic> json) =>
    _$WeightEntryImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weightKg: (json['weightKg'] as num).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
    );

Map<String, dynamic> _$$WeightEntryImplToJson(_$WeightEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'weightKg': instance.weightKg,
      'loggedAt': instance.loggedAt.toIso8601String(),
    };
