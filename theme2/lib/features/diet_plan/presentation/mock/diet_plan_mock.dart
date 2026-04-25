class DietPlanMockData {
  static const String currentPlan = "High Protein Lean Cut";
  static const String planSubtitle = "By Dr. Meera Kapoor · 12-week programme";
  static const String weekProgress = "Week 3/12";

  static const List<Map<String, dynamic>> schedule = [
    {'time': '7:30', 'ap': 'AM', 'type': 'Breakfast', 'name': 'Oats + Banana Smoothie', 'cals': '320 kcal · 28g protein', 'status': 'done'},
    {'time': '10:00', 'ap': 'AM', 'type': 'Snack', 'name': 'Almonds + Fruit', 'cals': '180 kcal · 6g protein', 'status': 'miss'},
    {'time': '12:30', 'ap': 'PM', 'type': 'Lunch ⚡', 'name': 'Quinoa Bowl + Chicken', 'cals': '495 kcal · 53g protein', 'status': 'pend'},
    {'time': '4:00', 'ap': 'PM', 'type': 'Snack', 'name': 'Greek Yogurt + Honey', 'cals': '150 kcal · 15g protein', 'status': 'pend'},
    {'time': '7:30', 'ap': 'PM', 'type': 'Dinner', 'name': 'Grilled Salmon + Veggies', 'cals': '420 kcal · 42g protein', 'status': 'pend'},
  ];
}
