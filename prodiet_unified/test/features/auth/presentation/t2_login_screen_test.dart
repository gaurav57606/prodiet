import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prodiet_unified/features/auth/application/auth_notifier.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/presentation/t2/screens/login_screen.dart';
import 'package:prodiet_unified/shared/t2/widgets/dm_button.dart';

class MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  MockAuthNotifier(super.state);
}

void main() {
  late MockAuthNotifier mockAuthNotifier;

  setUp(() {
    mockAuthNotifier = MockAuthNotifier(const AuthUnauthenticated());
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => mockAuthNotifier),
      ],
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }

  group('T2 LoginScreen Widget Tests', () {
    testWidgets('renders sign in tab by default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Sign in'), findsWidgets);
      expect(find.text('EMAIL ADDRESS'), findsOneWidget);
      expect(find.text('Sign In'), findsWidgets); // Button text
    });

    testWidgets('switches to create account tab', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Continue →'), findsOneWidget);
    });

    testWidgets('calls signIn when login button is pressed', (tester) async {
      when(() => mockAuthNotifier.signIn(any(), any()))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField).at(0), 'test@t.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      
      final submitButton = find.byType(DmButton);
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump();

      verify(() => mockAuthNotifier.signIn('test@t.com', 'password123')).called(1);
    });

    testWidgets('calls signInWithGoogle', (tester) async {
      when(() => mockAuthNotifier.signInWithGoogle())
          .thenAnswer((_) async {});

      await tester.pumpWidget(createWidgetUnderTest());

      final googleButton = find.text('Google');
      await tester.ensureVisible(googleButton);
      await tester.tap(googleButton);
      await tester.pump();

      verify(() => mockAuthNotifier.signInWithGoogle()).called(1);
    });
  });
}

