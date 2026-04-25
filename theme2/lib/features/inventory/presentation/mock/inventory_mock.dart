import 'package:flutter/material.dart';

class InventoryMockData {
  static const List<Map<String, dynamic>> stats = [
    {'value': '32', 'label': 'Items tracked', 'color': Color(0xFFD4FF58)},
    {'value': '4', 'label': 'Need restock', 'color': Color(0xFFFF5C3A)},
    {'value': '₹2,840', 'label': 'Monthly', 'color': Color(0xFFFFB800)},
    {'value': '7d', 'label': 'Avg shelf life', 'color': Color(0xFF38BFFF)},
  ];

  static const List<Map<String, dynamic>> items = [
    {'ico': '🥛', 'bg': Color(0xFF1a140a), 'nm': 'Skimmed Milk', 'sb': 'Expires 3 days', 'qty': '500ml', 'isLow': false, 'w': 40.0},
    {'ico': '🥩', 'bg': Color(0xFF1a0d14), 'nm': 'Paneer', 'sb': 'Running low · Expires tmrw', 'qty': '100g', 'isLow': true, 'w': 14.0},
    {'ico': '🌿', 'bg': Color(0xFF0a1a0d), 'nm': 'Spinach', 'sb': 'Critical · 1 bunch left', 'qty': '1 bunch', 'isLow': true, 'w': 10.0},
    {'ico': '🌾', 'bg': Color(0xFF14140a), 'nm': 'Oats', 'sb': 'Good stock · 400g left', 'qty': '400g', 'isLow': false, 'w': 32.0},
    {'ico': '🫒', 'bg': Color(0xFF0a1014), 'nm': 'Olive Oil', 'sb': 'Well stocked · 450ml', 'qty': '450ml', 'isLow': false, 'w': 44.0},
    {'ico': '🥜', 'bg': Color(0xFF14080a), 'nm': 'Almonds', 'sb': 'Critical · Only 20g left', 'qty': '20g', 'isLow': true, 'w': 7.0},
  ];
}
