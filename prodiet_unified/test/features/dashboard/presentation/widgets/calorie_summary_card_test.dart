import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/dashboard/t1/presentation/widgets/calorie_summary_card.dart';

class MockAppUser extends Mock implements AppUser {}

void main() {
  group('CalorieSummaryCard Widget Tests', () {
    testWidgets('renders correctly when caloriesGoal is zero (prevents NaN)', (tester) async {
      final mockUser = AppUser(
        id: 'u1',
        name: 'Test User',
        email: 'test@t.com',
        onboardingComplete: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(mockUser),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CalorieSummaryCard(
                caloriesConsumed: 100,
                caloriesGoal: 0,
                streakDays: 5,
              ),
            ),
          ),
        ),
      );

      // Verify no NaN is shown. We expect '0' as remaining today since goal is 0.
      expect(find.text('0'), findsWidgets);
      expect(find.textContaining('NaN'), findsNothing);
    });

    testWidgets('renders correctly with normal values', (tester) async {
      final mockUser = AppUser(
        id: 'u1',
        name: 'Test User',
        email: 'test@t.com',
        onboardingComplete: true,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWithValue(mockUser),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CalorieSummaryCard(
                caloriesConsumed: 500,
                caloriesGoal: 2000,
                streakDays: 3,
              ),
            ),
          ),
        ),
      );

      // Remaining = 2000 - 500 = 1500
      expect(find.text('1500'), findsOneWidget);
      expect(find.text('🔥 3 day streak'), findsOneWidget);
    });
  });
}
