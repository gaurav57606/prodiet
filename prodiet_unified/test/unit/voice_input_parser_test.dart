import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/voice/application/voice_input_parser.dart';

void main() {
  group('VoiceInputParser Unit Tests', () {
    test('Parse empty string returns empty list', () {
      final results = VoiceInputParser.parsePhrase('');
      expect(results, isEmpty);
    });

    test('Parse single item with quantity and unit', () {
      final results = VoiceInputParser.parsePhrase('3 slices of bread');
      expect(results.length, equals(1));
      expect(results[0].name, equals('Bread'));
      expect(results[0].quantity, equals(3.0));
      expect(results[0].unit, equals('slices'));
      expect(results[0].category, equals('Carbs'));
    });

    test('Parse single item without explicit unit', () {
      final results = VoiceInputParser.parsePhrase('2 apples');
      expect(results.length, equals(1));
      expect(results[0].name, equals('Apples'));
      expect(results[0].quantity, equals(2.0));
      expect(results[0].unit, equals('pcs'));
      expect(results[0].category, equals('Produce'));
    });

    test('Parse item name only without quantity or unit', () {
      final results = VoiceInputParser.parsePhrase('chicken breast');
      expect(results.length, equals(1));
      expect(results[0].name, equals('Chicken Breast'));
      expect(results[0].quantity, equals(1.0));
      expect(results[0].unit, equals('pcs'));
      expect(results[0].category, equals('Protein'));
    });

    test('Parse compound phrase with "and", "+", and commas', () {
      const phrase = '3 eggs and 2 slices of bread + 1 scoop of protein, 150g of chicken';
      final results = VoiceInputParser.parsePhrase(phrase);
      
      expect(results.length, equals(4));
      
      // Part 1: "3 eggs"
      expect(results[0].name, equals('Eggs'));
      expect(results[0].quantity, equals(3.0));
      expect(results[0].unit, equals('pcs'));
      expect(results[0].category, equals('Protein'));
      
      // Part 2: "2 slices of bread"
      expect(results[1].name, equals('Bread'));
      expect(results[1].quantity, equals(2.0));
      expect(results[1].unit, equals('slices'));
      expect(results[1].category, equals('Carbs'));

      // Part 3: "1 scoop of protein"
      expect(results[2].name, equals('Protein'));
      expect(results[2].quantity, equals(1.0));
      expect(results[2].unit, equals('scoops'));
      expect(results[2].category, equals('Protein'));

      // Part 4: "150g of chicken"
      expect(results[3].name, equals('Chicken'));
      expect(results[3].quantity, equals(150.0));
      expect(results[3].unit, equals('g'));
      expect(results[3].category, equals('Protein'));
    });

    test('Deduce categories correctly', () {
      expect(VoiceInputParser.parsePhrase('butter')[0].category, equals('Fats'));
      expect(VoiceInputParser.parsePhrase('avocado')[0].category, equals('Fats'));
      expect(VoiceInputParser.parsePhrase('milk')[0].category, equals('Dairy'));
      expect(VoiceInputParser.parsePhrase('spinach')[0].category, equals('Produce'));
      expect(VoiceInputParser.parsePhrase('rice')[0].category, equals('Carbs'));
      expect(VoiceInputParser.parsePhrase('whey')[0].category, equals('Protein'));
      expect(VoiceInputParser.parsePhrase('water')[0].category, equals('Other'));
    });
  });
}
