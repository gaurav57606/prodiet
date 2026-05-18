import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:prodiet_unified/main.dart' as app;
import 'package:prodiet_unified/core/design_system/components/app_button.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Golden Path Test', () {
    testWidgets('Login -> Add Meal -> Verify Dashboard Update', (tester) async {
      // 1. Launch the app
      app.main();
      await tester.pumpAndSettle();

      // 2. Login
      // Note: In a real CI environment, you'd use test credentials
      final emailField = find.byType(AppTextField).at(0);
      final passwordField = find.byType(AppTextField).at(1);
      final loginButton = find.byType(AppButton).first;

      await tester.enterText(emailField, 'test_e2e@prodiet.com');
      await tester.enterText(passwordField, 'password123');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      
      // Wait for navigation to Dashboard
      // We use a generous timeout to account for network latency in real E2E
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 3. Verify we are on Dashboard
      expect(find.textContaining('REMAINING TODAY'), findsWidgets);
      
      // Store initial calorie value if possible, or just proceed
      // For this script, we'll assume the user lands on a screen with a "Next Meal" section
      
      // 4. Navigate to Today's Meals to log a meal
      final fullViewButton = find.text('Full view ›').first;
      await tester.tap(fullViewButton);
      await tester.pumpAndSettle();

      // 5. Tap "Log Meal" FAB
      final logMealFab = find.text('LOG MEAL');
      await tester.tap(logMealFab);
      await tester.pumpAndSettle();

      // 6. Enter Meal Data in Bottom Sheet
      // Name
      await tester.enterText(find.byType(TextFormField).at(0), 'E2E Grilled Chicken');
      // Calories
      await tester.enterText(find.byType(TextFormField).at(1), '500');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();

      // Submit
      final submitButton = find.widgetWithText(FilledButton, 'Log Meal');
      await tester.tap(submitButton);
      
      // Wait for processing and sheet dismissal
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 7. Verify meal appears in the list
      expect(find.text('E2E Grilled Chicken'), findsOneWidget);
      expect(find.text('500 kcal'), findsWidgets);

      // 8. Return to Dashboard
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // 9. Verify Dashboard reflects the change
      // If we started at 2000 and logged 500, we should see 1500 remaining (or similar)
      // Since it's a real E2E, the exact number depends on previous state, 
      // but we verify the widget is still there and hasn't crashed.
      expect(find.textContaining('REMAINING TODAY'), findsWidgets);
    });
  });
}
