import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/core/utils/date_utils.dart';

void main() {
  group('getTimeGreeting', () {
    test('should return Good Morning when hour is between 0 and 11', () {
      final morning = DateTime(2024, 1, 1, 9, 0); // 9 AM
      expect(getTimeGreeting(morning), 'Good Morning');
    });

    test('should return Good Afternoon when hour is between 12 and 16', () {
      final afternoon = DateTime(2024, 1, 1, 14, 0); // 2 PM
      expect(getTimeGreeting(afternoon), 'Good Afternoon');
    });

    test('should return Good Evening when hour is between 17 and 23', () {
      final evening = DateTime(2024, 1, 1, 19, 0); // 7 PM
      expect(getTimeGreeting(evening), 'Good Evening');
    });

    test('should return Good Morning at exactly 00:00', () {
      final midnight = DateTime(2024, 1, 1, 0, 0);
      expect(getTimeGreeting(midnight), 'Good Morning');
    });

    test('should return Good Afternoon at exactly 12:00', () {
      final noon = DateTime(2024, 1, 1, 12, 0);
      expect(getTimeGreeting(noon), 'Good Afternoon');
    });

    test('should return Good Evening at exactly 17:00', () {
      final fivePm = DateTime(2024, 1, 1, 17, 0);
      expect(getTimeGreeting(fivePm), 'Good Evening');
    });
  });
}
