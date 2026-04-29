import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/scanned_item.dart';
import '../domain/ocr_result.dart';

class OcrRepository {
  final SupabaseClient _supabase;

  OcrRepository(this._supabase);

  Future<OcrResult> scanBill(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64String = base64Encode(bytes);
    
    // Detect mimeType
    final extension = imageFile.path.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

    final response = await _supabase.functions.invoke(
      'ocr-pipeline',
      body: {
        'imageBase64': base64String,
        'mimeType': mimeType,
      },
    );

    if (response.status != 200) {
      throw Exception('Failed to scan bill: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    final rawText = data['rawText'] as String;
    final items = (data['items'] as List)
        .map((i) => ScannedItem.fromJson(i).copyWith(isSelected: true))
        .toList();

    return OcrResult(
      items: items,
      rawText: rawText,
      scannedAt: DateTime.now(),
    );
  }
}
