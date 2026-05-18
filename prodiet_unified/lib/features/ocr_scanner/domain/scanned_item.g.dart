// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScannedItem _$ScannedItemFromJson(Map<String, dynamic> json) => _ScannedItem(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      isSelected: json['isSelected'] as bool? ?? true,
    );

Map<String, dynamic> _$ScannedItemToJson(_ScannedItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'category': instance.category,
      'isSelected': instance.isSelected,
    };
