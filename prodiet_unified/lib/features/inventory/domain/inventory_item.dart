import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

@freezed
abstract class InventoryItem with _$InventoryItem {
  const InventoryItem._();

  const factory InventoryItem({
    required String id,
    required String userId,
    required String ingredientName,
    required double quantity,
    required String unit,
    required String category,
    required double reorderThreshold,
    required DateTime updatedAt,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

  bool get isLowStock => quantity <= reorderThreshold;
  bool get isOutOfStock => quantity <= 0;
}
