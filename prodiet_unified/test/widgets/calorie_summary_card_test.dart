import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/dashboard/presentation/widgets/unified_calorie_section.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';

void main() {
  group('UnifiedCalorieSection Widget Tests', () {
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
          child: Consumer(
            builder: (context, ref, child) {
              final tokens = ref.watch(appThemeTokensProvider);
              return MaterialApp(
                theme: AppTheme.buildTheme(tokens, Brightness.dark),
                home: const Scaffold(
                  body: UnifiedCalorieSection(
                    consumed: 100,
                    goal: 0,
                    burned: 50,
                    net: 50,
                    streak: 5,
                  ),
                ),
              );
            },
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
          child: Consumer(
            builder: (context, ref, child) {
              final tokens = ref.watch(appThemeTokensProvider);
              return MaterialApp(
                theme: AppTheme.buildTheme(tokens, Brightness.dark),
                home: const Scaffold(
                  body: UnifiedCalorieSection(
                    consumed: 500,
                    goal: 2000,
                    burned: 150,
                    net: 350,
                    streak: 3,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Remaining = 2000 - 500 = 1500
      expect(find.text('1500'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('DAY STREAK'), findsOneWidget);
    });
  });
}
