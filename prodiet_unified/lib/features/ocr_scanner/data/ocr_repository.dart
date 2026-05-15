import 'dart:io';
import 'package:prodiet_unified/core/services/ocr_service.dart';
import 'package:prodiet_unified/core/utils/image_preprocessor.dart';
import '../domain/scanned_item.dart';
import '../domain/ocr_result.dart';

class OcrRepository {
  final OcrService _ocrService;

  OcrRepository(this._ocrService);

  Future<OcrResult> scanImage(File imageFile) async {
    try {
      // 1. Pre-process image in isolate
      final base64Image = await ImagePreprocessor.processForOcr(imageFile);
      
      // 2. Call OCR Service (AI Pipeline)
      final data = await _ocrService.scanBill(base64Image);

      // 3. Map to Domain
      final rawText = data['raw_text'] as String? ?? '';
      final items = (data['items'] as List? ?? [])
          .map((i) => ScannedItem.fromJson(i))
          .toList();

      return OcrResult(
        items: items,
        rawText: rawText,
      );
    } catch (e) {
      // Hardened: Detailed error handling for AI pipeline failures
      throw Exception('OCR Analysis failed: $e');
    }
  }
}
