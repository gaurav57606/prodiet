class OcrResult {
  final List<OcrItem> items;
  final double confidence;
  final String source;
  final Map<String, dynamic>? rawData;

  OcrResult({
    required this.items,
    required this.confidence,
    required this.source,
    this.rawData,
  });

  List<OcrItem> get detectedItems => items;

  factory OcrResult.fromJson(Map<String, dynamic> json) {
    return OcrResult(
      items: (json['items'] as List? ?? [])
          .map((i) => OcrItem.fromJson(i))
          .toList(),
      confidence: (json['confidence'] as num? ?? 0).toDouble(),
      source: json['source'] ?? 'unknown',
      rawData: json,
    );
  }
}

class OcrItem {
  final String name;
  final double quantity;
  final String unit;
  final double price;
  final double confidence;

  OcrItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.price,
    this.confidence = 1.0,
  });

  factory OcrItem.fromJson(Map<String, dynamic> json) {
    return OcrItem(
      name: json['name'] ?? '',
      quantity: (json['qty'] as num? ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      confidence: (json['confidence'] as num? ?? 1.0).toDouble(),
    );
  }
}
