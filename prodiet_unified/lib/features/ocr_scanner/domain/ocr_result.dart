import 'scanned_item.dart';

class OcrResult {
  final List<ScannedItem> items;
  final String rawText;

  OcrResult({
    required this.items,
    required this.rawText,
  });

  int get itemCount => items.length;

  int get selectedCount => items.where((i) => i.isSelected).length;

  List<ScannedItem> get selectedItems =>
      items.where((i) => i.isSelected).toList();
}
