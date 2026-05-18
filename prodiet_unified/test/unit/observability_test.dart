import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/core/observability/analytics/analytics_manager.dart';
import 'package:prodiet_unified/core/services/remote_config_service.dart';
import 'package:prodiet_unified/core/services/notification_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockFirebaseRemoteConfig extends Mock implements FirebaseRemoteConfig {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockNotificationService extends Mock implements NotificationService {}

class FakeRemoteConfigSettings extends Fake implements RemoteConfigSettings {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRemoteConfigSettings());
  });

  group('Analytics Taxonomy Tests', () {
    late MockFirebaseAnalytics mockAnalytics;
    late AnalyticsManager manager;

    setUp(() {
      mockAnalytics = MockFirebaseAnalytics();
      manager = AnalyticsManager(analytics: mockAnalytics);
      
      when(() => mockAnalytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
      )).thenAnswer((_) async {});
    });

    test('Structured events adhere to exact dot-based taxonomy', () {
      final event = AppAnalyticsEvent.authLoginSuccess('google');
      expect(event.name, equals('auth.login.success'));
      expect(event.parameters?['method'], equals('google'));

      final ocrEvent = AppAnalyticsEvent.mealScanSuccess(350.0, durationMs: 1200);
      expect(ocrEvent.name, equals('meal.scan.success'));
      expect(ocrEvent.parameters?['calories'], equals(350.0));
      expect(ocrEvent.parameters?['duration_ms'], equals(1200));
    });

    test('AnalyticsManager sanitizes dot formatting to underscores for Firebase compat', () async {
      final event = AppAnalyticsEvent.authLoginSuccess('email');
      await manager.logEvent(event);

      verify(() => mockAnalytics.logEvent(
        name: 'auth_login_success',
        parameters: any(named: 'parameters'),
      )).called(1);
    });
  });

  group('RemoteConfig Service Tests', () {
    late MockFirebaseRemoteConfig mockConfig;
    late RemoteConfigService service;

    setUp(() {
      mockConfig = MockFirebaseRemoteConfig();
      service = RemoteConfigService(remoteConfig: mockConfig);

      when(() => mockConfig.setConfigSettings(any())).thenAnswer((_) async {});
      when(() => mockConfig.setDefaults(any())).thenAnswer((_) async {});
      when(() => mockConfig.fetchAndActivate()).thenAnswer((_) async => true);
      when(() => mockConfig.onConfigUpdated).thenAnswer((_) => const Stream.empty());
    });

    test('Type-safe accessors return correct types and fallback defaults', () {
      when(() => mockConfig.getBool('feature_ocr_enabled')).thenReturn(true);
      when(() => mockConfig.getBool('feature_social_feed')).thenReturn(false);
      when(() => mockConfig.getInt('sync_interval_seconds')).thenReturn(30);
      when(() => mockConfig.getDouble('ocr_confidence_threshold')).thenReturn(0.85);

      expect(service.isOcrEnabled, isTrue);
      expect(service.isSocialFeedEnabled, isFalse);
      expect(service.syncIntervalSeconds, equals(30));
      expect(service.ocrConfidenceThreshold, equals(0.85));
    });
  });
}
