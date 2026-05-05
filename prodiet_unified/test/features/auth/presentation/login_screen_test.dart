import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';
import 'package:prodiet_unified/features/auth/t1/presentation/screens/login_screen.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_button.dart';
import 'package:prodiet_unified/shared/t1/widgets/dm_text_field.dart';
import 'package:prodiet_unified/core/services/analytics_providers.dart';
import 'package:prodiet_unified/core/services/analytics_service.dart';

class MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  MockAuthNotifier() : super(const AuthUnauthenticated());
}

class MockAnalytics extends Mock implements AnalyticsService {}

void main() {
  late MockAuthNotifier mockAuthNotifier;
  late MockAnalytics mockAnalytics;

  setUp(() {
    mockAuthNotifier = MockAuthNotifier();
    mockAnalytics = MockAnalytics();
    when(() => mockAnalytics.logScreen(any(), any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => mockAuthNotifier),
        analyticsServiceProvider.overrideWithValue(mockAnalytics),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all initial UI components', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Pro', findRichText: true), findsOneWidget);
      expect(find.textContaining('Diet', findRichText: true), findsOneWidget);
      expect(find.text('Sign in'), findsWidgets); // Tab and Button
      expect(find.byType(DmTextField), findsNWidgets(2));
      expect(find.byType(DmButton), findsWidgets);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(DmButton).first);
      await tester.pumpAndSettle();

      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('Min 6 characters'), findsOneWidget);
    });

    testWidgets('shows loading state when authState is AuthLoading', (tester) async {
      mockAuthNotifier.state = const AuthLoading();
      await tester.pumpWidget(createWidgetUnderTest());

      // DmButton should show loading indicator (CircularProgressIndicator)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls signIn on notifier when form is valid', (tester) async {
      when(() => mockAuthNotifier.signIn(any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(DmTextField).first, 'test@example.com');
      await tester.enterText(find.byType(DmTextField).last, 'password123');

      await tester.tap(find.byType(DmButton).first);
      await tester.pump();

      verify(() => mockAuthNotifier.signIn('test@example.com', 'password123')).called(1);
    });
  });
}
