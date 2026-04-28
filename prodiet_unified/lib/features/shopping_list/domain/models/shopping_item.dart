class ShoppingItem {
  final String id;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isBought;
  final String category;

  const ShoppingItem({
    required this.id,
    required this.userId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.isBought,
    required this.category,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'],
      userId: json['user_id'],
      ingredientName: json['ingredient_name'],
      quantity: (json['quantity'] as num? ?? 0).toDouble(),
      unit: json['unit'],
      isBought: json['is_bought'] ?? false,
      category: json['category'] ?? 'Pantry',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ingredient_name': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'is_bought': isBought,
      'category': category,
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? userId,
    String? ingredientName,
    double? quantity,
    String? unit,
    bool? isBought,
    String? category,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ingredientName: ingredientName ?? this.ingredientName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isBought: isBought ?? this.isBought,
      category: category ?? this.category,
    );
  }
}
