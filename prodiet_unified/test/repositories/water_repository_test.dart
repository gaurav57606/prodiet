import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockPostgrestQueryBuilder extends Mock implements PostgrestQueryBuilder<List<Map<String, dynamic>>> {}

void main() {


  group('WaterRepository Boundary Tests', () {
    test('logCustomAmount should handle 0 ml', () async {
      // Setup mock to catch insertion
      // ...
      // verify insert called with 0
    });

    test('logCustomAmount should handle extremely large values', () async {
      // 100 liters
      // verify insert called with 100000
    });
  });
}
