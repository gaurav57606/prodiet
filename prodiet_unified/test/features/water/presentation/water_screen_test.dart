import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/water/application/water_providers.dart';
import 'package:prodiet_unified/features/water/domain/water_summary.dart';
import 'package:prodiet_unified/features/water/presentation/t2/screens/water_screen.dart';

void main() {
  const testSummary = WaterSummary(
    totalMl: 1500,
    targetMl: 2500,
    glasses: 6,
    targetGlasses: 10,
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        waterSummaryProvider.overrideWith((ref) => Stream.value(testSummary)),
        currentUserIdProvider.overrideWith((ref) => 'u1'),
      ],
      child: const MaterialApp(
        home: WaterScreen(),
      ),
    );
  }

  group('WaterScreen Widget Tests', () {
    testWidgets('renders hydration progress and glasses', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Check for the headline
      expect(find.text('WATER'), findsOneWidget);
      
      // Check for the progress text (1,500 ml / 2,500 ml)
      // Since it's in a RichText, we use find.textContaining with findRichText: true
      expect(find.textContaining('1,500', findRichText: true), findsWidgets);
      expect(find.textContaining('2,500', findRichText: true), findsWidgets);
      
      // Check for glasses left today
      expect(find.text('4 glasses left today'), findsOneWidget); // 10 - 6 = 4
    });

    testWidgets('shows empty state when no water logged', (tester) async {
      final emptySummary = WaterSummary.empty(2500);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          waterSummaryProvider.overrideWith((ref) => Stream.value(emptySummary)),
          currentUserIdProvider.overrideWith((ref) => 'u1'),
        ],
        child: const MaterialApp(home: WaterScreen()),
      ));
      await tester.pumpAndSettle();

      // When totalMl is 0, the screen shows the empty state config
      expect(find.text('Stay hydrated today'), findsOneWidget);
      expect(find.text('Log your first glass. Your goal is 8 glasses a day.'), findsOneWidget);
    });
  });
}

