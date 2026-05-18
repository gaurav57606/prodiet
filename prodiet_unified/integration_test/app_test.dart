import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prodiet_unified/main.dart' as app;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/app/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  // Increase timeout for slow CI environments
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('ProDiet Real E2E Integration Test', () {
    
    tearDownAll(() async {
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {}
    });

    testWidgets('Full Journey: Login -> Dashboard -> App Loop', (tester) async {
      // 1. Boot the real app
      // Note: This relies on --dart-define-from-file=.env.json being passed to the test runner
      app.main();
      await tester.pumpAndSettle();

      // 2. Verify we are on Login screen (if not already logged in)
      // If we land on Dashboard directly (due to persistence), sign out first to test the flow
      if (find.text('DASHBOARD').evaluate().isNotEmpty) {
        // Sign out logic here if needed
      }

      // We expect 'WELCOME BACK' or 'ProDiet' title on T1 login
      expect(find.textContaining('Pro', findRichText: true), findsWidgets);

      // 3. Login with a test account
      // Use credentials that you expect to exist in your Supabase instance
      // Or better, create a temporary user if Supabase allows
      final emailField = find.byType(AppTextField).at(0);
      final passwordField = find.byType(AppTextField).at(1);
      final loginButton = find.byType(AppButton).first;

      await tester.enterText(emailField, 'test_e2e@prodiet.com');
      await tester.enterText(passwordField, 'password123');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      
      // Wait for navigation and state changes
      // This might take a while depending on network
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 4. Verify Destination
      // It could be Dashboard or Onboarding
      final isOnboarding = find.text('HEALTH GOALS').evaluate().isNotEmpty || 
                           find.text('TELL US ABOUT YOURSELF').evaluate().isNotEmpty;
      
      if (isOnboarding) {
        debugPrint('--- Landing on Onboarding ---');
        expect(find.textContaining('GOAL', findRichText: true), findsWidgets);
      } else {
        debugPrint('--- Landing on Dashboard ---');
        expect(find.text('KCAL REMAINING TODAY'), findsWidgets);
      }

      // 5. Verify persistence (Restart app simulation)
      // In integration tests, we can't easily "restart" the process, but we can re-pump the root
      // to see if it preserves session
      debugPrint('--- Verifying persistence ---');
      await tester.pumpWidget(const ProviderScope(child: ProDietApp()));
      await tester.pumpAndSettle();
      
      if (isOnboarding) {
        expect(find.textContaining('GOAL', findRichText: true), findsWidgets);
      } else {
        expect(find.text('KCAL REMAINING TODAY'), findsWidgets);
      }
    });
  });
}
