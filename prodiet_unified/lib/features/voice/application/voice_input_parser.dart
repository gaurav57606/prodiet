class ParsedVoiceItem {
  final String name;
  final double quantity;
  final String unit;
  final String category;

  ParsedVoiceItem({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.category,
  });

  @override
  String toString() => '$quantity $unit $name ($category)';
}

class VoiceInputParser {
  /// Parses a natural spoken phrase into a list of structured ingredients.
  /// Handles multi-item conjunctions like "and", "+", "with", and commas.
  static List<ParsedVoiceItem> parsePhrase(String phrase) {
    if (phrase.trim().isEmpty) return [];

    // Standardize phrase (strip quotes, lowercase, trim)
    final cleanPhrase = phrase
        .replaceAll(RegExp(r'^["\x22\u201c\u201d]|["\x22\u201c\u201d]$'), '')
        .trim();

    // Split compound items (e.g. "3 eggs and 2 slices of bread" or "avocado, milk, protein")
    final parts = cleanPhrase.split(RegExp(r'\s+and\s+|\s*\+\s*|\s*,\s*|\s+with\s+', caseSensitive: false));
    final List<ParsedVoiceItem> items = [];

    for (var part in parts) {
      final trimmedPart = part.trim();
      if (trimmedPart.isEmpty) continue;

      final parsed = _parseSingleItem(trimmedPart);
      if (parsed != null) {
        items.add(parsed);
      }
    }

    return items;
  }

  static ParsedVoiceItem? _parseSingleItem(String itemStr) {
    // Regular expression to match:
    // 1. Quantity: Optional digits or decimals (e.g., "150", "1.5", "2")
    // 2. Unit: Optional measurements (e.g., "g", "ml", "pcs", "slices", "scoops", "carton", "cup", "handful")
    // 3. Name: The ingredient name (e.g., "chicken breast")
    final regex = RegExp(
      r'^(\d+(?:\.\d+)?)\s*(g|ml|pcs|pcs\b|slices|slice|scoops|scoop|pieces|piece|carton|handful|cups|cup)?\s*(?:of\s+)?(.*)$',
      caseSensitive: false,
    );

    double quantity = 1.0;
    String unit = 'pcs';
    String name = itemStr;

    final match = regex.firstMatch(itemStr);
    if (match != null) {
      final qtyStr = match.group(1);
      final unitStr = match.group(2);
      final nameStr = match.group(3);

      if (qtyStr != null) {
        quantity = double.tryParse(qtyStr) ?? 1.0;
      }
      if (unitStr != null) {
        unit = unitStr.toLowerCase();
      } else {
        // If there's a quantity but no unit, default unit is 'pcs' unless we can guess it
        unit = 'pcs';
      }
      if (nameStr != null && nameStr.trim().isNotEmpty) {
        name = nameStr.trim();
      }
    } else {
      // If it doesn't match the standard [Quantity] [Unit] [Name], check if it's just a name
      // e.g., "apple" or "chicken breast"
      // Remove starting descriptors like "a ", "an ", "some "
      final cleanName = itemStr.replaceFirst(RegExp(r'^(a|an|some)\s+', caseSensitive: false), '');
      return ParsedVoiceItem(
        name: _capitalizeWords(cleanName),
        quantity: 1.0,
        unit: 'pcs',
        category: _deduceCategory(cleanName),
      );
    }

    // Standardize units
    if (unit == 'slice') unit = 'slices';
    if (unit == 'scoop') unit = 'scoops';
    if (unit == 'piece') unit = 'pcs';
    if (unit == 'pieces') unit = 'pcs';
    if (unit == 'cup') unit = 'cups';

    return ParsedVoiceItem(
      name: _capitalizeWords(name),
      quantity: quantity,
      unit: unit,
      category: _deduceCategory(name),
    );
  }

  static String _capitalizeWords(String input) {
    if (input.isEmpty) return input;
    return input.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String _deduceCategory(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('egg') ||
        lower.contains('chicken') ||
        lower.contains('breast') ||
        lower.contains('fish') ||
        lower.contains('turkey') ||
        lower.contains('beef') ||
        lower.contains('whey') ||
        lower.contains('protein') ||
        lower.contains('tuna') ||
        lower.contains('salmon') ||
        lower.contains('pork') ||
        lower.contains('paneer') ||
        lower.contains('tofu')) {
      return 'Protein';
    }

    if (lower.contains('bread') ||
        lower.contains('rice') ||
        lower.contains('oats') ||
        lower.contains('quinoa') ||
        lower.contains('potato') ||
        lower.contains('cereal') ||
        lower.contains('flour') ||
        lower.contains('toast') ||
        lower.contains('pasta')) {
      return 'Carbs';
    }

    if (lower.contains('oil') ||
        lower.contains('butter') ||
        lower.contains('avocado') ||
        lower.contains('nuts') ||
        lower.contains('almond') ||
        lower.contains('peanut') ||
        lower.contains('seeds') ||
        lower.contains('ghee') ||
        lower.contains('cashew') ||
        lower.contains('walnut')) {
      return 'Fats';
    }

    if (lower.contains('milk') ||
        lower.contains('yogurt') ||
        lower.contains('cheese') ||
        lower.contains('curd') ||
        lower.contains('cream') ||
        lower.contains('dairy')) {
      return 'Dairy';
    }

    if (lower.contains('berry') ||
        lower.contains('blueberry') ||
        lower.contains('strawberry') ||
        lower.contains('apple') ||
        lower.contains('spinach') ||
        lower.contains('broccoli') ||
        lower.contains('tomato') ||
        lower.contains('onion') ||
        lower.contains('garlic') ||
        lower.contains('banana') ||
        lower.contains('orange') ||
        lower.contains('salad') ||
        lower.contains('vegetable') ||
        lower.contains('fruit')) {
      return 'Produce';
    }

    return 'Other';
  }
}
