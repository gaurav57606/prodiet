import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/auth/domain/models/app_user.dart';
import 'package:prodiet_unified/features/auth/t2/presentation/screens/onboarding_screen.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';

class MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  MockAuthNotifier(AuthState state) : super(state);
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  late MockAuthNotifier mockAuthNotifier;
  final testUser = AppUser(
    id: 'u2',
    email: 't2@t.com',
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
      child: const MaterialApp(
        home: OnboardingScreen(),
      ),
    );
  }

  group('T2 OnboardingScreen Widget Tests', () {
    testWidgets('renders all sections correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('ALMOST THERE'), findsOneWidget);
      expect(find.text('PRIMARY GOAL'), findsOneWidget);
      expect(find.text('ACTIVITY LEVEL'), findsOneWidget);
      expect(find.text('YOUR MEASUREMENTS'), findsOneWidget);
    });

    testWidgets('calls completeOnboarding when form is valid', (tester) async {
      when(() => mockAuthNotifier.completeOnboarding(any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      // Fill in measurements
      final ageField = find.byType(TextFormField).at(0);
      final weightField = find.byType(TextFormField).at(1);
      
      await tester.ensureVisible(ageField);
      await tester.enterText(ageField, '28');
      await tester.enterText(weightField, '72');
      await tester.pump();
      
      // Tap "BUILD MUSCLE"
      final goal = find.text('BUILD MUSCLE');
      await tester.ensureVisible(goal);
      await tester.tap(goal);
      await tester.pumpAndSettle();

      // Tap "VERY ACTIVE"
      final activity = find.text('VERY ACTIVE');
      await tester.ensureVisible(activity);
      await tester.tap(activity);
      await tester.pumpAndSettle();

      // Submit
      final submitButton = find.byType(DmButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(() => mockAuthNotifier.completeOnboarding(any(), any())).called(1);
    });

    testWidgets('shows error when fields are empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final submitButton = find.byType(DmButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Please fill in age and weight'), findsOneWidget);
    });

    testWidgets('shows error when age is out of range', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).at(0), '5'); // Too young
      await tester.enterText(find.byType(TextFormField).at(1), '70');

      final submitButton = find.byType(DmButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Age must be between 13 and 120'), findsOneWidget);
    });

    testWidgets('shows error when weight is out of range', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextFormField).at(0), '25');
      await tester.enterText(find.byType(TextFormField).at(1), '501'); // Too heavy

      final submitButton = find.byType(DmButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Weight must be between 30 and 500 kg'), findsOneWidget);
    });
  });
}
