import 'dart:ui';

class DashboardMockData {
  static const String userName = 'Rohan';
  static const String userLastName = 'Sharma';
  static const String dateString = 'Saturday · 22 March';
  static const String planLabel = 'SHREDDING PLAN · WEEK 3';
  static const int calorieGoal = 2000;
  static const int caloriesConsumed = 1380;
  static const int caloriesRemaining = 620;
  static const int streakDays = 12;

  static const List<MacroData> macros = [
    MacroData(
      label: 'Protein',
      value: 87,
      goal: 150,
      unit: 'g',
      percentage: 0.58,
      gradientColors: [Color(0xFFFFB0D0), Color(0xFFFF60A0)],
    ),
    MacroData(
      label: 'Carbs',
      value: 200,
      goal: 250,
      unit: 'g',
      percentage: 0.80,
      gradientColors: [Color(0xFFFFD080), Color(0xFFFFA030)],
    ),
    MacroData(
      label: 'Fat',
      value: 28,
      goal: 70,
      unit: 'g',
      percentage: 0.40,
      gradientColors: [Color(0xFF40D8C0), Color(0xFF80EDD8)],
    ),
  ];

  static const HydrationData hydration = HydrationData(
    status: 'On track',
    timerValue: '18',
    timerUnit: 'm',
    subText: 'until your next drink',
    consumed: 1500,
    target: 2500,
    percentage: 0.60,
  );
}

class MacroData {
  final String label;
  final double value;
  final double goal;
  final String unit;
  final double percentage;
  final List<dynamic> gradientColors;

  const MacroData({
    required this.label,
    required this.value,
    required this.goal,
    required this.unit,
    required this.percentage,
    required this.gradientColors,
  });
}

class HydrationData {
  final String status;
  final String timerValue;
  final String timerUnit;
  final String subText;
  final double consumed;
  final double target;
  final double percentage;

  const HydrationData({
    required this.status,
    required this.timerValue,
    required this.timerUnit,
    required this.subText,
    required this.consumed,
    required this.target,
    required this.percentage,
  });
}
