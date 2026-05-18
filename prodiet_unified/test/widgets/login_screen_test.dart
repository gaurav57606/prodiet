import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/presentation/screens/login_screen.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';
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
    when(() => mockAnalytics.logScreen(any())).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => mockAuthNotifier),
        analyticsServiceProvider.overrideWithValue(mockAnalytics),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          final tokens = ref.watch(appThemeTokensProvider);
          return MaterialApp(
            theme: AppTheme.buildTheme(tokens, Brightness.dark),
            home: const LoginScreen(),
          );
        },
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('renders all initial UI components', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Pro', findRichText: true), findsOneWidget);
      expect(find.textContaining('Diet', findRichText: true), findsOneWidget);
      expect(find.text('Sign in'), findsWidgets); // Tab and Button
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(AppButton), findsWidgets);
    });

    testWidgets('shows validation errors when fields are empty', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byType(AppButton).first);
      await tester.pumpAndSettle();

      expect(find.text('Email required'), findsOneWidget);
      expect(find.text('Min 6 characters'), findsOneWidget);
    });

    testWidgets('shows loading state when authState is AuthLoading', (tester) async {
      mockAuthNotifier.state = const AuthLoading();
      await tester.pumpWidget(createWidgetUnderTest());

      // AppButton should show loading indicator (CircularProgressIndicator)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls signIn on notifier when form is valid', (tester) async {
      when(() => mockAuthNotifier.signIn(any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      // Find the TextFormField inside each AppTextField
      final fields = find.descendant(
        of: find.byType(AppTextField),
        matching: find.byType(TextFormField),
      );

      await tester.enterText(fields.at(0), 'test@example.com');
      await tester.enterText(fields.at(1), 'password123');
      await tester.pump();

      await tester.tap(find.byType(AppButton).first);
      await tester.pump();

      verify(() => mockAuthNotifier.signIn('test@example.com', 'password123')).called(1);
    });
  });
}
