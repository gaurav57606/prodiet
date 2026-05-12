import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodiet_unified/features/meal_planner/application/meal_providers.dart';
import 'package:prodiet_unified/features/meal_planner/domain/meal.dart';
import 'package:prodiet_unified/features/meal_planner/domain/daily_meal_summary.dart';
import 'package:prodiet_unified/features/meal_planner/presentation/t1/screens/meal_planner_screen.dart';

void main() {
  final testMeals = [
    Meal(
      id: 'm1',
      userId: 'u1',
      name: 'Oatmeal',
      calories: 300,
      proteinG: 10,
      carbsG: 50,
      fatG: 5,
      ingredients: ['Oats'],
      plannedDate: DateTime.now(),
      createdAt: DateTime.now(),
      mealType: MealType.breakfast,
      status: MealStatus.eaten,
    ),
  ];

  final testSummary = DailyMealSummary(
    meals: testMeals,
    totalCalories: 300,
    totalProteinG: 10,
    totalCarbsG: 50,
    totalFatG: 5,
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        weeklyMealsProvider.overrideWith((ref) => testMeals),
        todayMealsProvider.overrideWith((ref) => Stream.value(testSummary)),
      ],
      child: const MaterialApp(
        home: MealPlannerScreen(),
      ),
    );
  }

  group('MealPlannerScreen Widget Tests', () {
    testWidgets('renders weekly planner with meals', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Weekly Planner'), findsOneWidget);
      expect(find.text('1 meals scheduled'), findsOneWidget);
      expect(find.text('300 kcal total'), findsOneWidget);
    });

    testWidgets('shows empty state when no meals', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [
          weeklyMealsProvider.overrideWith((ref) => <Meal>[]),
          todayMealsProvider.overrideWith((ref) => Stream.value(const DailyMealSummary(meals: [], totalCalories: 0, totalProteinG: 0, totalCarbsG: 0, totalFatG: 0))),
        ],
        child: const MaterialApp(home: MealPlannerScreen()),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Nothing planned yet'), findsOneWidget);
    });
  });
}

