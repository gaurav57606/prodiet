import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/auth/presentation/screens/health_goals_screen.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';

class MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  MockAuthNotifier(super.state);
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late MockAuthNotifier mockAuthNotifier;
  final testUser = AppUser(
    id: 'u1',
    email: 'test@t.com',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAuthNotifier = MockAuthNotifier(AuthNeedsOnboarding(testUser));
    when(() => mockAuthNotifier.currentUser).thenReturn(testUser);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => mockAuthNotifier),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          final tokens = ref.watch(appThemeTokensProvider);
          return MaterialApp(
            theme: AppTheme.buildTheme(tokens, Brightness.dark),
            home: const HealthGoalsScreen(),
          );
        },
      ),
    );
  }

  group('HealthGoalsScreen Widget Tests', () {
    testWidgets('renders goals and activity options', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('LOSE WEIGHT'), findsOneWidget);
      expect(find.text('SEDENTARY'), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(3)); // Age, Weight, Height
    });

    testWidgets('selection updates UI (goal and activity)', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Select 'BUILD MUSCLE'
      final goal = find.text('BUILD MUSCLE');
      await tester.ensureVisible(goal);
      await tester.tap(goal);
      await tester.pumpAndSettle();
      
      // Select 'VERY ACTIVE'
      final activity = find.text('VERY ACTIVE');
      await tester.ensureVisible(activity);
      await tester.tap(activity);
      await tester.pumpAndSettle();
    });

    testWidgets('shows error if fields are missing on complete', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final button = find.byType(AppButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Please fill in all health details'), findsOneWidget);
    });

    testWidgets('calls completeOnboarding when all data is provided', (tester) async {
      when(() => mockAuthNotifier.completeOnboarding(any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      // Fill in details using lowest level EditableText
      final ageField = find.byType(EditableText).at(0);
      final weightField = find.byType(EditableText).at(1);
      final heightField = find.byType(EditableText).at(2);

      await tester.ensureVisible(ageField);
      await tester.enterText(ageField, '30');
      await tester.enterText(weightField, '85');
      await tester.enterText(heightField, '180');
      await tester.pump();
      
      final button = find.byType(AppButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(() => mockAuthNotifier.completeOnboarding(any(), any())).called(1);
    });
  });
}
