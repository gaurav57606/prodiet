import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:prodiet_unified/core/observability/analytics/analytics_manager.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late AnalyticsService analyticsService;
  late MockFirebaseAnalytics mockAnalytics;
  late AnalyticsManager analyticsManager;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    analyticsManager = AnalyticsManager(analytics: mockAnalytics);
    analyticsService = AnalyticsService(manager: analyticsManager);

    registerFallbackValue(<String, Object>{});

    // Stub FirebaseAnalytics methods to complete successfully
    when(() => mockAnalytics.logEvent(
          name: any(named: 'name'),
          parameters: any(named: 'parameters'),
        )).thenAnswer((_) => Future.value());

    when(() => mockAnalytics.logScreenView(
          screenName: any(named: 'screenName'),
          screenClass: any(named: 'screenClass'),
        )).thenAnswer((_) => Future.value());

    when(() => mockAnalytics.setUserId(
          id: any(named: 'id'),
        )).thenAnswer((_) => Future.value());

    when(() => mockAnalytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        )).thenAnswer((_) => Future.value());
  });

  group('AnalyticsService Tests', () {
    test('logEvent calls FirebaseAnalytics.logEvent', () async {
      await analyticsService.logEvent('test_event', parameters: {'param1': 'val1'});

      verify(() => mockAnalytics.logEvent(
            name: 'test_event',
            parameters: {'param1': 'val1'},
          )).called(1);
    });

    test('logScreen calls FirebaseAnalytics.logScreenView', () async {
      await analyticsService.logScreen('Home');

      verify(() => mockAnalytics.logScreenView(screenName: 'Home')).called(1);
    });

    test('setUserId calls FirebaseAnalytics.setUserId', () async {
      await analyticsService.setUserId('user_123');

      verify(() => mockAnalytics.setUserId(id: 'user_123')).called(1);
    });

    test('setUserProperty calls FirebaseAnalytics.setUserProperty', () async {
      await analyticsService.setUserProperty('theme', 'dark');

      verify(() => mockAnalytics.setUserProperty(name: 'theme', value: 'dark')).called(1);
    });

    test('startSession registers user properties and logs auth_login_success', () async {
      await analyticsService.startSession(
        'user_123',
        deviceModel: 'Pixel 6',
        osVersion: 'Android 12',
        appVersion: '2.1.0',
      );

      verify(() => mockAnalytics.setUserId(id: 'user_123')).called(1);
      verify(() => mockAnalytics.setUserProperty(name: 'device_model', value: 'Pixel 6')).called(1);
      verify(() => mockAnalytics.setUserProperty(name: 'os_version', value: 'Android 12')).called(1);
      verify(() => mockAnalytics.setUserProperty(name: 'app_version', value: '2.1.0')).called(1);
      verify(() => mockAnalytics.logEvent(
        name: 'auth_login_success',
        parameters: any(named: 'parameters'),
      )).called(1);
    });

    test('endSession logs auth_logout', () async {
      await analyticsService.endSession('user_123');

      verify(() => mockAnalytics.logEvent(
        name: 'auth_logout',
        parameters: any(named: 'parameters'),
      )).called(1);
    });
  });
}
