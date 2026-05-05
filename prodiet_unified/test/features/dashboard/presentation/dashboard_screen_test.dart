import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';

import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/dashboard_screen.dart';

class MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  MockAuthNotifier(super.state);
}

class MockAnalyticsService extends Mock implements AnalyticsService {}

void main() {
  late MockAuthNotifier mockAuthNotifier;
  late MockAnalyticsService mockAnalytics;
  final testUser = AppUser(
    id: 'u1',
    name: 'Test User',
    email: 'test@t.com',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAuthNotifier = MockAuthNotifier(AuthAuthenticated(testUser));
    mockAnalytics = MockAnalyticsService();
    when(() => mockAuthNotifier.currentUser).thenReturn(testUser);
    when(() => mockAnalytics.logScreen(any(), any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest(DashboardSummary summary) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => mockAuthNotifier),
        currentUserProvider.overrideWithValue(testUser),
        dashboardProvider.overrideWith((ref) => Future.value(summary)),
        analyticsServiceProvider.overrideWithValue(mockAnalytics),
      ],
      child: const MaterialApp(
        home: DashboardScreen(),
      ),
    );
  }

  group('DashboardScreen Widget Tests', () {
    testWidgets('renders calorie summary and hydration card', (tester) async {
      const summary = DashboardSummary(
        userName: 'Test User',
        caloriesConsumed: 1000,
        caloriesGoal: 2000,
        waterMl: 1000,
        waterGoalMl: 2500,
        proteinConsumed: 50,
        carbsConsumed: 100,
        fatConsumed: 30,
        proteinGoal: 100,
        carbsGoal: 200,
        fatGoal: 60,
        mealsToday: 2,
        mealsScheduled: 4,
        streakDays: 5,
        stepsToday: 5000,
        caloriesBurned: 300,
      );

      await tester.pumpWidget(createWidgetUnderTest(summary));
      await tester.pumpAndSettle();

      // Check User Name
      expect(find.textContaining('Test'), findsWidgets);

      // Check remaining calories (2000 - 1000 = 1000)
      expect(find.text('1000'), findsWidgets);
      expect(find.textContaining('REMAINING'), findsWidgets);

      // Check hydration
      expect(find.textContaining('1000', findRichText: true), findsWidgets);
    });

    testWidgets('shows empty state when no data', (tester) async {
      final summary = DashboardSummary.empty(caloriesGoal: 0);

      await tester.pumpWidget(createWidgetUnderTest(summary));
      await tester.pumpAndSettle();

      expect(find.text('Your day starts here'), findsWidgets);
      // Ensure no crash from division by zero in progress calculation
    });
  });
}
