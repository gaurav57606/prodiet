enum MealStatus { done, missed, pending }

class DietPlanMockData {
  static const List<DietDay> weekDays = [
    DietDay(name: 'SAT', date: '22', isToday: true),
    DietDay(name: 'SUN', date: '23'),
    DietDay(name: 'MON', date: '24'),
    DietDay(name: 'TUE', date: '25'),
    DietDay(name: 'WED', date: '26'),
    DietDay(name: 'THU', date: '27'),
    DietDay(name: 'FRI', date: '28'),
  ];

  static const List<MealTimelineItemData> todayMeals = [
    MealTimelineItemData(
      time: '07:30',
      period: 'AM',
      type: 'BREAKFAST',
      name: 'Oats Banana Smoothie',
      calories: '320 kcal',
      status: MealStatus.done,
    ),
    MealTimelineItemData(
      time: '10:00',
      period: 'AM',
      type: 'SNACK',
      name: 'Almonds & Fruit Bowl',
      calories: '180 kcal',
      status: MealStatus.missed,
    ),
    MealTimelineItemData(
      time: '12:30',
      period: 'PM',
      type: 'LUNCH',
      name: 'Quinoa Bowl + Chicken',
      calories: '480 kcal',
      status: MealStatus.pending,
    ),
    MealTimelineItemData(
      time: '04:00',
      period: 'PM',
      type: 'SNACK',
      name: 'Greek Yogurt & Honey',
      calories: '150 kcal',
      status: MealStatus.pending,
    ),
    MealTimelineItemData(
      time: '07:30',
      period: 'PM',
      type: 'DINNER',
      name: 'Grilled Salmon + Veg',
      calories: '420 kcal',
      status: MealStatus.pending,
    ),
  ];
}

class DietDay {
  final String name;
  final String date;
  final bool isToday;

  const DietDay({
    required this.name,
    required this.date,
    this.isToday = false,
  });
}

class MealTimelineItemData {
  final String time;
  final String period;
  final String type;
  final String name;
  final String calories;
  final MealStatus status;

  const MealTimelineItemData({
    required this.time,
    required this.period,
    required this.type,
    required this.name,
    required this.calories,
    required this.status,
  });
}
