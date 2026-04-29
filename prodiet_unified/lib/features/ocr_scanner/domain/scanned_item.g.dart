// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scanned_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScannedItemImpl _$$ScannedItemImplFromJson(Map<String, dynamic> json) =>
    _$ScannedItemImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      isSelected: json['isSelected'] as bool? ?? true,
    );

Map<String, dynamic> _$$ScannedItemImplToJson(_$ScannedItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'category': instance.category,
      'isSelected': instance.isSelected,
    };
