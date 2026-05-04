import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dietmate/shared/widgets/dm_card.dart';
import 'package:dietmate/core/theme/app_spacing.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('DmCard Widget Tests', () {
    testWidgets('renders child correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DmCard(
            child: Text('Test Child'),
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('uses default values', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DmCard(
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(container.padding, const EdgeInsets.all(AppSpacing.md));
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.boxShadow, isNull);

      // Default border side uses context.colorScheme.outline
      final theme = Theme.of(tester.element(containerFinder));
      expect(decoration.border, Border.fromBorderSide(BorderSide(color: theme.colorScheme.outline, width: 1)));
    });

    testWidgets('applies custom padding and borderRadius', (WidgetTester tester) async {
      const customPadding = 24.0;
      const customBorderRadius = 8.0;

      await tester.pumpWidget(
        buildTestableWidget(
          const DmCard(
            padding: customPadding,
            borderRadius: customBorderRadius,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(container.padding, const EdgeInsets.all(customPadding));
      expect(decoration.borderRadius, BorderRadius.circular(customBorderRadius));
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          DmCard(
            onTap: () => tapped = true,
            child: const Text('Tap Me'),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('applies custom color and borderSide', (WidgetTester tester) async {
      const customColor = Colors.red;
      const customBorderSide = BorderSide(color: Colors.blue, width: 2);

      await tester.pumpWidget(
        buildTestableWidget(
          const DmCard(
            color: customColor,
            borderSide: customBorderSide,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final decoration = tester.widget<Container>(find.byType(Container)).decoration as BoxDecoration;

      expect(decoration.color, customColor);
      expect(decoration.border, const Border.fromBorderSide(customBorderSide));
    });

    testWidgets('shows elevation when > 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const DmCard(
            elevation: 4,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      final decoration = tester.widget<Container>(find.byType(Container)).decoration as BoxDecoration;

      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, 1);
      expect(decoration.boxShadow![0].blurRadius, 8.0); // elevation * 2
      expect(decoration.boxShadow![0].offset, Offset(0, 4));
    });
  });
}
