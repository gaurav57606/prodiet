// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaterLogImpl _$$WaterLogImplFromJson(Map<String, dynamic> json) =>
    _$WaterLogImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amountMl: (json['amountMl'] as num).toInt(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$WaterLogImplToJson(_$WaterLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'amountMl': instance.amountMl,
      'loggedAt': instance.loggedAt.toIso8601String(),
      'date': instance.date.toIso8601String(),
    };
