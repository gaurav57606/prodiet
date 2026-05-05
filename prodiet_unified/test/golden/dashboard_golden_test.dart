import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/dashboard/application/dashboard_providers.dart';
import 'package:prodiet_unified/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/dashboard_screen.dart' as t1;
import 'package:prodiet_unified/features/dashboard/t2/presentation/screens/dashboard_screen.dart' as t2;

class FakeActiveThemeNotifier extends ActiveThemeNotifier {
  final ActiveTheme _mockState;
  FakeActiveThemeNotifier(this._mockState);
  @override
  ActiveTheme build() => _mockState;
}

class MockAuthNotifier extends Mock implements AuthNotifier {}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    registerFallbackValue(const AuthLoading());
  });

  group('Dashboard Golden Tests', () {
    final summary = DashboardSummary(
      userName: 'Alex',
      caloriesGoal: 2000,
      caloriesConsumed: 1200,
      proteinGoal: 150,
      proteinConsumed: 80,
      carbsGoal: 200,
      carbsConsumed: 150,
      fatGoal: 60,
      fatConsumed: 40,
      waterGoalMl: 2500,
      waterMl: 1500,
      mealsToday: 2,
      mealsScheduled: 4,
      streakDays: 5,
      stepsToday: 8420,
      caloriesBurned: 312,
    );

    final testUser = AppUser(
      id: 'test-123',
      email: 'test@example.com',
      name: 'Alex',
      createdAt: DateTime.now(),
    );

    final authState = AuthAuthenticated(testUser);

    testWidgets('T1 Light Theme Dashboard Golden', (tester) async {
      // Set size directly on the view
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockAuth = MockAuthNotifier();
      when(() => mockAuth.state).thenReturn(authState);
      when(() => mockAuth.currentUser).thenReturn(testUser);
      when(() => mockAuth.addListener(any())).thenReturn(() {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t1Light)),
            authProvider.overrideWith((ref) => mockAuth),
            dashboardProvider.overrideWith((ref) => summary),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: t1.DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(t1.DashboardScreen), matchesGoldenFile('goldens/dashboard_t1_light.png'));
    });

    testWidgets('T2 Dark Theme Dashboard Golden', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockAuth = MockAuthNotifier();
      when(() => mockAuth.state).thenReturn(authState);
      when(() => mockAuth.currentUser).thenReturn(testUser);
      when(() => mockAuth.addListener(any())).thenReturn(() {});

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            activeThemeProvider.overrideWith(() => FakeActiveThemeNotifier(ActiveTheme.t2Dark)),
            authProvider.overrideWith((ref) => mockAuth),
            dashboardProvider.overrideWith((ref) => summary),
          ],
          child: const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: t2.DashboardScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(find.byType(t2.DashboardScreen), matchesGoldenFile('goldens/dashboard_t2_dark.png'));
    });
  });
}
