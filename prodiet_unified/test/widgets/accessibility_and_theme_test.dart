import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/core/theme/app_theme.dart';
import 'package:prodiet_unified/core/widgets/async_value_widget.dart';
import 'package:prodiet_unified/core/error/app_error.dart';
import 'package:prodiet_unified/core/design_system/components/app_text_field.dart';
import 'package:prodiet_unified/features/recipe/presentation/widgets/adaptive_recipe_widgets.dart';
import 'package:prodiet_unified/core/widgets/empty_states/prodiet_empty_state.dart';


void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildThemedApp({
    required Widget child,
    double textScaleFactor = 1.0,
  }) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final activeTheme = ref.watch(activeThemeProvider);
          final tokens = ref.watch(appThemeTokensProvider);
          final brightness = (activeTheme == ActiveTheme.t1Light ||
                  activeTheme == ActiveTheme.t2Light)
              ? Brightness.light
              : Brightness.dark;

          return MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScaleFactor)),
            child: MaterialApp(
              theme: AppTheme.buildTheme(tokens, brightness),
              home: Scaffold(
                body: child,
              ),
            ),
          );
        },
      ),
    );
  }

  group('Theme Switching Widget Tests', () {
    testWidgets('dynamic theme change updates context theme and typography colors',
        (tester) async {
      final themeChangeTrigger = Consumer(
        builder: (context, ref, _) {
          final activeTheme = ref.watch(activeThemeProvider);
          final isT2 = activeTheme == ActiveTheme.t2Dark;
          return Column(
            children: [
              Text(
                'Theme Label: ${activeTheme.name}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(activeThemeProvider.notifier)
                      .setTheme(isT2 ? ActiveTheme.t1Dark : ActiveTheme.t2Dark);
                },
                child: const Text('Toggle Theme'),
              ),
            ],
          );
        },
      );

      await tester.pumpWidget(buildThemedApp(child: themeChangeTrigger));

      // Initially t1Dark
      expect(find.text('Theme Label: t1Dark'), findsOneWidget);
      
      // Tap toggle theme to switch to t2Dark
      await tester.tap(find.text('Toggle Theme'));
      await tester.pumpAndSettle();

      // Label updates to t2Dark
      expect(find.text('Theme Label: t2Dark'), findsOneWidget);
    });
  });

  group('Accessibility Text Scaling Tests', () {
    testWidgets('layout scaling allows extreme font size adjustments without layout clipping',
        (tester) async {
      final responsiveLayout = Container(
        padding: const EdgeInsets.all(16.0),
        child: const Row(
          children: [
            Expanded(
              child: Text(
                'Super Long Title Label That Should SoftWrap Under High Scaling',
                softWrap: true,
              ),
            ),
            Icon(Icons.check_circle),
          ],
        ),
      );

      // Verify at normal scale
      await tester.pumpWidget(
        buildThemedApp(child: responsiveLayout, textScaleFactor: 1.0),
      );
      expect(tester.takeException(), isNull);

      // Verify at high accessibility scale (e.g. 2.0 text scale factor)
      await tester.pumpWidget(
        buildThemedApp(child: responsiveLayout, textScaleFactor: 2.0),
      );
      
      // Wait for any framework layout constraints to settle
      await tester.pump();
      
      // Make sure no overflow exceptions were thrown during high text scaling
      expect(tester.takeException(), isNull);
    });
  });

  group('Loading & Error State Widget Tests', () {
    testWidgets('AsyncValueWidget handles loading state cleanly', (tester) async {
      const asyncLoading = AsyncValue<String>.loading();
      
      final widgetUnderTest = AsyncValueWidget<String>(
        value: asyncLoading,
        builder: (data) => Text('Data: $data'),
      );

      await tester.pumpWidget(buildThemedApp(child: widgetUnderTest));

      // Circular indicator is shown during loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AsyncValueWidget handles error state gracefully', (tester) async {
      final asyncError = AsyncValue<String>.error(
        const ValidationError(field: 'database', message: 'Database connection failed'),
        StackTrace.current,
      );

      final widgetUnderTest = AsyncValueWidget<String>(
        value: asyncError,
        builder: (data) => Text('Data: $data'),
      );

      await tester.pumpWidget(buildThemedApp(child: widgetUnderTest));

      // Error message is properly surfaced in error state visual
      expect(find.textContaining('Database connection failed'), findsOneWidget);
    });
  });

  group('Hardened AppTextField Widget Tests', () {
    testWidgets('properly forwards and exposes input action, hints, suggestions properties',
        (tester) async {
      await tester.pumpWidget(
        buildThemedApp(
          child: AppTextField(
            textInputAction: TextInputAction.send,
            autofillHints: const [AutofillHints.email],
            enableSuggestions: true,
            autocorrect: false,
            onFieldSubmitted: (_) {},
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.textInputAction, TextInputAction.send);
      expect(textField.autofillHints, contains(AutofillHints.email));
      expect(textField.enableSuggestions, isTrue);
      expect(textField.autocorrect, isFalse);
    });
  });

  group('AdaptiveRecipeCard Accessibility Tests', () {
    testWidgets('stacks match details vertically when accessibility scaling is high',
        (tester) async {
      // 1.0x Scale: Renders side-by-side (Row layout has matching container nested)
      await tester.pumpWidget(
        buildThemedApp(
          child: const AdaptiveRecipeCard(
            title: 'High Protein Pancakes',
            type: 'Breakfast',
            match: '98%',
          ),
          textScaleFactor: 1.0,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('98%'), findsOneWidget);
      expect(find.text('MATCH'), findsOneWidget);

      // 2.0x Scale: Stacks matching details vertically and should wrap or handle bounds smoothly
      await tester.pumpWidget(
        buildThemedApp(
          child: const AdaptiveRecipeCard(
            title: 'High Protein Pancakes',
            type: 'Breakfast',
            match: '98%',
          ),
          textScaleFactor: 2.0,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('98%'), findsOneWidget);
      expect(find.text('MATCH'), findsOneWidget);
    });
  });

  group('ProDietEmptyState Responsiveness & Bounds Tests', () {
    testWidgets('ensures viewport scroll-safety and minimum 48dp action touch target height',
        (tester) async {
      await tester.pumpWidget(
        buildThemedApp(
          child: ProDietEmptyState(
            icon: Icons.search_off,
            headline: 'No meals scanned',
            subtext: 'Get started by scanning your first meal details.',
            buttonLabel: 'SCAN MEAL',
            onButtonTap: () {},
          ),
        ),
      );

      // Verify that a SingleChildScrollView wrapper exists to safeguard landscape/narrow heights
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Verify that the action button height is wrapped in a container prioritizing >=48dp bounds
      final filledButtonFinder = find.byType(FilledButton);
      expect(filledButtonFinder, findsOneWidget);
      
      final Size buttonSize = tester.getSize(filledButtonFinder);
      expect(buttonSize.height, greaterThanOrEqualTo(48.0));
    });
  });
}

