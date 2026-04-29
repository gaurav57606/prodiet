// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryItemImpl _$$InventoryItemImplFromJson(Map<String, dynamic> json) =>
    _$InventoryItemImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      ingredientName: json['ingredientName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      category: json['category'] as String,
      reorderThreshold: (json['reorderThreshold'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InventoryItemImplToJson(_$InventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'ingredientName': instance.ingredientName,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'category': instance.category,
      'reorderThreshold': instance.reorderThreshold,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
