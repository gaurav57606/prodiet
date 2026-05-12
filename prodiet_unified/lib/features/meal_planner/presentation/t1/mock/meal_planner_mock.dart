class MealPlannerMockData {
  static const List<RecipeData> suggestions = [
    RecipeData(
      type: 'Classic · Indian',
      name: 'Dal Makhani\nProtein Bowl',
      isExotic: false,
      calories: '420',
      protein: '32g',
      carbs: '48g',
      fat: '10g',
      match: '94%',
      tags: ['High fibre', 'Gut friendly', '30 mins', 'Easy'],
    ),
    RecipeData(
      type: 'Experimental · Fusion',
      name: 'Turmeric Chicken\nQuinoa Risotto',
      isExotic: true,
      calories: '460',
      protein: '38g',
      carbs: '42g',
      fat: '14g',
      match: '89%',
      tags: ['Anti-inflammatory', 'Novel', '45 mins', 'Medium'],
    ),
    RecipeData(
      type: 'Classic · Mediterranean',
      name: 'Greek Chicken\nBowl',
      isExotic: false,
      calories: '390',
      protein: '41g',
      carbs: '18g',
      fat: '16g',
      match: '96%',
      tags: ['Keto-friendly', 'Light', '20 mins', 'Easy'],
    ),
  ];
}

class RecipeData {
  final String type;
  final String name;
  final bool isExotic;
  final String calories;
  final String protein;
  final String carbs;
  final String fat;
  final String match;
  final List<String> tags;

  const RecipeData({
    required this.type,
    required this.name,
    required this.isExotic,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.match,
    required this.tags,
  });
}
