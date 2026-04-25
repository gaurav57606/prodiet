class MealPlannerMockData {
  static const String currentDay = "SAT 21 MARCH";
  static const String progress = "4 / 5 done";
  
  static const Map<String, dynamic> nextMeal = {
    'type': 'LUNCH',
    'time': '12:30 PM',
    'countdown': 'In 2h 15m',
    'title': 'Quinoa Bowl\n+ Grilled Chicken',
    'subtitle': '480 kcal · High protein',
    'kcal': '480',
    'protein': '38g',
    'carbs': '45g',
    'fat': '12g',
    'fibre': '4g',
  };

  static const List<Map<String, dynamic>> ingredients = [
    {'name': 'Quinoa 80g', 'isDone': true},
    {'name': 'Chicken 150g', 'isDone': true},
    {'name': 'Cucumber ❌', 'isDone': false},
    {'name': 'Tomatoes', 'isDone': false},
    {'name': 'Olive Oil', 'isDone': false},
  ];
}
