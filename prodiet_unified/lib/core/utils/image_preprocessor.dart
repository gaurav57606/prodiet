import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/painting.dart';

class ImagePreprocessor {
  /// Enforces cache bounds on the Flutter image cache to prevent memory pressure
  static void enforceCacheBounds({int maxMegabytes = 50}) {
    PaintingBinding.instance.imageCache.maximumSizeBytes = maxMegabytes * 1024 * 1024;
    PaintingBinding.instance.imageCache.maximumSize = 100; // max 100 images
  }
  /// Compresses and encodes image to Base64 in a background isolate if possible
  static Future<String> processForOcr(File file) async {
    return compute(_processImage, file.path);
  }

  static Future<String> _processImage(String path) async {
    final bytes = await File(path).readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) throw Exception('Could not decode image');

    // Resize if too large (Supabase functions have limits)
    img.Image processed = image;
    if (image.width > 1600) {
      processed = img.copyResize(image, width: 1600);
    }

    // Convert to grayscale to reduce payload and potentially improve OCR contrast
    processed = img.grayscale(processed);

    final compressedBytes = img.encodeJpg(processed, quality: 80);
    return base64Encode(compressedBytes);
  }
}
