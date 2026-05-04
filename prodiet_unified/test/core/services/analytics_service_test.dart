import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class FakePostgrestFilterBuilder extends Fake 
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) {
    return Future.value(<Map<String, dynamic>>[]).then(onValue);
  }
}

void main() {
  late AnalyticsService analyticsService;
  late MockSupabaseClient mockSupabase;
  late MockSupabaseQueryBuilder mockQueryBuilder;

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();

    analyticsService = AnalyticsService(mockSupabase);

    registerFallbackValue(<String, dynamic>{});

    when(() => mockSupabase.from(any())).thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.insert(any())).thenAnswer((_) => FakePostgrestFilterBuilder());
    when(() => mockQueryBuilder.update(any())).thenAnswer((_) => FakePostgrestFilterBuilder());
    when(() => mockQueryBuilder.upsert(any(), onConflict: any(named: 'onConflict')))
        .thenAnswer((_) => FakePostgrestFilterBuilder());
  });

  group('AnalyticsService', () {
    test('logScreen calls correctly', () async {
      await analyticsService.logScreen('user_1', 'Home');
      verify(() => mockSupabase.from('screen_views')).called(1);
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });

    test('logEvent calls correctly', () async {
      await analyticsService.logEvent('user_1', 'test_event');
      verify(() => mockSupabase.from('feature_events')).called(1);
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });
  });
}
