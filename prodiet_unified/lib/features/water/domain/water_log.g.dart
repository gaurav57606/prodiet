// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WaterLogImpl _$$WaterLogImplFromJson(Map<String, dynamic> json) =>
    _$WaterLogImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amountMl: (json['amount_ml'] as num).toInt(),
      loggedAt: DateTime.parse(json['logged_at'] as String),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$WaterLogImplToJson(_$WaterLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'amount_ml': instance.amountMl,
      'logged_at': instance.loggedAt.toIso8601String(),
      'date': instance.date.toIso8601String(),
    };
