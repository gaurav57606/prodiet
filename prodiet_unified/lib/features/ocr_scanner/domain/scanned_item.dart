import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanned_item.freezed.dart';
part 'scanned_item.g.dart';

@freezed
class ScannedItem with _$ScannedItem {
  const factory ScannedItem({
    required String name,
    required double quantity,
    required String unit,
    required String category,
    @Default(true) bool isSelected,
  }) = _ScannedItem;

  factory ScannedItem.fromJson(Map<String, dynamic> json) =>
      _$ScannedItemFromJson(json);
}
