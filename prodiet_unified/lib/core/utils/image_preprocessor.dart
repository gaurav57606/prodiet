import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImagePreprocessor {
  /// Prepares an image for OCR by resizing, grayscaling, and encoding to JPEG.
  static Future<Uint8List> prepareForOcr(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) throw Exception('Could not decode image');

    // 1. Resize: if longest side > 768px, resize maintaining aspect ratio
    if (image.width > 768 || image.height > 768) {
      if (image.width > image.height) {
        image = img.copyResize(image, width: 768);
      } else {
        image = img.copyResize(image, height: 768);
      }
    }

    // 2. Convert to grayscale
    image = img.grayscale(image);

    // 3. Encode as JPEG quality 85
    return Uint8List.fromList(img.encodeJpg(image, quality: 85));
  }

  /// Uploads preprocessed bytes to Supabase Storage and returns a public/signed URL.
  static Future<String> uploadToStorage(Uint8List bytes, String userId) async {
    final supabase = Supabase.instance.client;
    final uuid = const Uuid().v4();
    final fileName = 'ocr/$userId/$uuid.jpg';

    // Upload to 'ocr-temp' bucket
    await supabase.storage.from('ocr-temp').uploadBinary(
          fileName,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
        );

    // Return a signed URL with 10 min expiry
    final signedUrl = await supabase.storage.from('ocr-temp').createSignedUrl(fileName, 600);
    return signedUrl;
  }
}
