// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OcrResultImpl _$$OcrResultImplFromJson(Map<String, dynamic> json) =>
    _$OcrResultImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => ScannedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      rawText: json['rawText'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );

Map<String, dynamic> _$$OcrResultImplToJson(_$OcrResultImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'rawText': instance.rawText,
      'scannedAt': instance.scannedAt.toIso8601String(),
    };
