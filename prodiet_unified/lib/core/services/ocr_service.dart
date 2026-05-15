import 'package:prodiet_unified/core/services/supabase_service.dart';

class OcrService {
  final SupabaseService _supabase;

  OcrService(this._supabase);

  Future<Map<String, dynamic>> scanBill(String base64Image) async {
    final response = await _supabase.perform(
      (client) => client.functions.invoke(
        'ocr-pipeline',
        body: {'image': base64Image},
      ),
      context: 'OCR_PIPELINE',
    );

    if (response.status != 200) {
      throw Exception('OCR processing failed with status ${response.status}');
    }

    return response.data as Map<String, dynamic>;
  }
}
