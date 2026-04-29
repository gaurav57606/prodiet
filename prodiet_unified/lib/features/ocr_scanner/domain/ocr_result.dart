import 'package:freezed_annotation/freezed_annotation.dart';
import 'scanned_item.dart';

part 'ocr_result.freezed.dart';
part 'ocr_result.g.dart';

@freezed
class OcrResult with _$OcrResult {
  const factory OcrResult({
    required List<ScannedItem> items,
    required String rawText,
    required DateTime scannedAt,
  }) = _OcrResult;

  const OcrResult._();

  int get itemCount => items.length;

  factory OcrResult.fromJson(Map<String, dynamic> json) => _$OcrResultFromJson(json);
}
