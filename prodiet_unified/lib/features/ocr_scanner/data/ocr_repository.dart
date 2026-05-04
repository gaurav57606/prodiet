import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/scanned_item.dart';
import '../domain/ocr_result.dart';

class OcrRepository {
  final SupabaseClient _supabase;

  OcrRepository(this._supabase);

  Future<OcrResult> scanImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _supabase.functions.invoke(
        'ocr-pipeline',
        body: {'image': base64Image},
      );

      if (response.status != 200) {
        throw Exception('Failed to scan bill: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;
      final rawText = data['raw_text'] as String? ?? '';
      final items = (data['items'] as List? ?? [])
          .map((i) => ScannedItem.fromJson(i))
          .toList();

      return OcrResult(
        items: items,
        rawText: rawText,
      );
    } catch (e) {
      // Mock fallback
      return OcrResult(
        items: [
          const ScannedItem(
              name: 'Rice',
              quantity: 500,
              unit: 'g',
              category: 'Grains',
              isSelected: true),
          const ScannedItem(
              name: 'Chicken',
              quantity: 200,
              unit: 'g',
              category: 'Protein',
              isSelected: true),
          const ScannedItem(
              name: 'Milk',
              quantity: 1,
              unit: 'L',
              category: 'Dairy',
              isSelected: true),
        ],
        rawText: 'MOCK OCR OUTPUT (Function not deployed)',
      );
    }
  }
}
