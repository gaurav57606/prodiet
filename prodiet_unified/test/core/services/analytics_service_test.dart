import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

/// Happy-path fake — returns empty list immediately.
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

/// Error-path fake — simulates Supabase being offline.
class FakePostgrestFilterBuilderThrows extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>>) onValue, {
    Function? onError,
  }) {
    return Future<U>.error(Exception('Supabase offline'));
  }
}

void main() {
  late AnalyticsService analyticsService;
  late MockSupabaseClient mockSupabase;
  late MockSupabaseQueryBuilder mockQueryBuilder;

  setUp(() {
    mockSupabase     = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    analyticsService = AnalyticsService(mockSupabase);

    registerFallbackValue(<String, dynamic>{});

    when(() => mockSupabase.from(any()))
        .thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.insert(any()))
        .thenAnswer((_) => FakePostgrestFilterBuilder());
    when(() => mockQueryBuilder.update(any()))
        .thenAnswer((_) => FakePostgrestFilterBuilder());
    when(() => mockQueryBuilder.upsert(
          any(),
          onConflict: any(named: 'onConflict'),
        )).thenAnswer((_) => FakePostgrestFilterBuilder());
    when(() => mockQueryBuilder.eq(any(), any()))
        .thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.order(
          any(),
          ascending: any(named: 'ascending'),
        )).thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.limit(any()))
        .thenAnswer((_) => mockQueryBuilder);
    when(() => mockQueryBuilder.maybeSingle())
        .thenAnswer((_) async => null);
  });

  // ─────────────────────────────────────────────────────────
  // logScreen
  // ─────────────────────────────────────────────────────────
  group('AnalyticsService — logScreen', () {
    test('inserts into screen_views table', () async {
      await analyticsService.logScreen('user_1', 'Home');
      verify(() => mockSupabase.from('screen_views')).called(1);
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });

    test('does not throw when Supabase returns error (silent analytics)', () async {
      when(() => mockQueryBuilder.insert(any()))
          .thenAnswer((_) => FakePostgrestFilterBuilderThrows());
      await expectLater(
        analyticsService.logScreen('user_1', 'Home'),
        completes,
      );
    });
  });

  // ─────────────────────────────────────────────────────────
  // logEvent
  // ─────────────────────────────────────────────────────────
  group('AnalyticsService — logEvent', () {
    test('inserts into feature_events table', () async {
      await analyticsService.logEvent('user_1', 'test_event');
      verify(() => mockSupabase.from('feature_events')).called(1);
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });

    test('does not throw when Supabase returns error', () async {
      when(() => mockQueryBuilder.insert(any()))
          .thenAnswer((_) => FakePostgrestFilterBuilderThrows());
      await expectLater(
        analyticsService.logEvent('user_1', 'button_tap'),
        completes,
      );
    });
  });

  // ─────────────────────────────────────────────────────────
  // startSession / endSession
  // ─────────────────────────────────────────────────────────
  group('AnalyticsService — startSession', () {
    test('inserts into sessions table', () async {
      await analyticsService.startSession('user_1');
      verify(() => mockSupabase.from('sessions')).called(1);
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });

    test('does not throw when Supabase returns error', () async {
      when(() => mockQueryBuilder.insert(any()))
          .thenAnswer((_) => FakePostgrestFilterBuilderThrows());
      await expectLater(
        analyticsService.startSession('user_1'),
        completes,
      );
    });
  });

  group('AnalyticsService — endSession', () {
    test('calls sessions table when ending active session', () async {
      // start first to seed a session
      await analyticsService.startSession('user_1');
      await analyticsService.endSession('user_1');
      // sessions table should be touched at least twice
      verify(() => mockSupabase.from('sessions'))
          .called(greaterThanOrEqualTo(2));
    });

    test('does not throw when no active session exists', () async {
      await expectLater(
        analyticsService.endSession('user_1'),
        completes,
      );
    });
  });
}
