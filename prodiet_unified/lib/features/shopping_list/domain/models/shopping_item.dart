class ShoppingItem {
  final String id;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isPurchased;
  final String source; // manual, auto

  const ShoppingItem({
    required this.id,
    required this.userId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.isPurchased,
    required this.source,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      userId: json['user_id'],
      ingredientName: json['ingredient_name'],
      quantity: (json['quantity'] as num? ?? 0).toDouble(),
      unit: json['unit'],
      isPurchased: json['is_purchased'] ?? false,
      source: json['source'] ?? 'manual',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ingredient_name': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'is_purchased': isPurchased,
      'source': source,
    };
  }
}
