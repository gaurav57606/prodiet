import 'package:flutter_test/flutter_test.dart';
// We'll import the repository, but since we want to test a private method or internal logic,
// we might need to expose it or test it via a public method.
// For now, let's assume we can test it.

void main() {
  group('LIKE query sanitization', () {
    test('should escape %', () {
      expect(escapeLike('100% juice'), '100\\% juice');
    });

    test('should escape _', () {
      expect(escapeLike('product_name'), 'product\\_name');
    });

    test('should escape \\', () {
      expect(escapeLike('back\\slash'), 'back\\\\slash');
    });

    test('should escape mixed special characters', () {
      expect(escapeLike('%_\\'), '\\%\\_\\\\');
    });

    test('should not escape normal characters', () {
      expect(escapeLike('Apple 123'), 'Apple 123');
    });
  });
}

// Temporary helper to verify logic before integration
String escapeLike(String input) {
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('%', '\\%')
      .replaceAll('_', '\\_');
}
