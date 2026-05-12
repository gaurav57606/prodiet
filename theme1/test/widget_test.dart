// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dietmate/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: DietMateApp()));
    
    // Wait for splash screen to navigate to onboarding
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that our onboarding screen is shown.
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Tap 'Skip' and trigger a frame.
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Verify that we are on the login screen.
    expect(find.text('Sign in'), findsOneWidget);
  });
}
