import 'package:prodiet_unified/features/recipe/domain/recipe.dart';

class RecipeBook {
  static final List<Recipe> recipes = [
    Recipe(
      id: 'r1',
      name: 'High-Protein Scrambled Eggs',
      type: 'Breakfast',
      requiredIngredients: [
        RecipeIngredient(name: 'Eggs', quantity: 3, unit: 'pcs'),
        RecipeIngredient(name: 'Milk', quantity: 50, unit: 'ml'),
        RecipeIngredient(name: 'Butter', quantity: 10, unit: 'g'),
      ],
      steps: [
        'Crack eggs into a clean bowl, add milk, and whisk vigorously until smooth.',
        'Melt butter in a non-stick skillet over medium-low heat.',
        'Pour in the whisked eggs and let sit for 10 seconds without stirring.',
        'Gently push the eggs from outer edges to center, creating large soft curds.',
        'Remove from heat while slightly runny (they will cook more on the plate) and serve immediately.'
      ],
      calories: 312,
      protein: 22,
      carbs: 2,
      fats: 24,
      allergens: ['dairy'],
    ),
    Recipe(
      id: 'r2',
      name: 'Chicken Quinoa Power Bowl',
      type: 'Lunch',
      requiredIngredients: [
        RecipeIngredient(name: 'Chicken Breast', quantity: 150, unit: 'g'),
        RecipeIngredient(name: 'Quinoa', quantity: 100, unit: 'g'),
        RecipeIngredient(name: 'Olive Oil', quantity: 15, unit: 'ml'),
      ],
      steps: [
        'Rinse quinoa thoroughly, then boil with water (1:2 ratio) for 15 minutes or until fluffy.',
        'Season chicken breast with salt, pepper, and garlic powder.',
        'Heat olive oil in a skillet and cook chicken for 6-8 minutes on each side until golden and cooked through.',
        'Slice chicken breast into strips.',
        'Assemble the power bowl by placing quinoa as the base and layering the chicken on top. Drizzle with pan drippings.'
      ],
      calories: 495,
      protein: 48,
      carbs: 32,
      fats: 18,
      allergens: [],
    ),
    Recipe(
      id: 'r3',
      name: 'Keto Paneer Bowl',
      type: 'Lunch',
      requiredIngredients: [
        RecipeIngredient(name: 'Paneer', quantity: 150, unit: 'g'),
        RecipeIngredient(name: 'Avocado', quantity: 1, unit: 'pcs'),
        RecipeIngredient(name: 'Olive Oil', quantity: 10, unit: 'ml'),
      ],
      steps: [
        'Cut paneer cheese into bite-sized cubes.',
        'Heat olive oil in a grill pan or skillet and pan-fry the paneer cubes until golden brown on all sides.',
        'Slice the fresh avocado in half, remove the pit, and cut into neat slices.',
        'Arrange grilled paneer and sliced avocado beautifully in a bowl.',
        'Garnish with dry herbs and sea salt. Enjoy warm!'
      ],
      calories: 520,
      protein: 28,
      carbs: 6,
      fats: 42,
      allergens: ['dairy'],
    ),
    Recipe(
      id: 'r4',
      name: 'Oatmeal with Blueberries',
      type: 'Breakfast',
      requiredIngredients: [
        RecipeIngredient(name: 'Oats', quantity: 50, unit: 'g'),
        RecipeIngredient(name: 'Milk', quantity: 200, unit: 'ml'),
        RecipeIngredient(name: 'Blueberries', quantity: 50, unit: 'g'),
      ],
      steps: [
        'In a small saucepan, combine oats and milk over medium heat.',
        'Bring to a gentle simmer, stirring constantly to prevent sticking.',
        'Cook for 5-7 minutes until the oats have absorbed the milk and turned creamy.',
        'Pour oatmeal into a warm serving bowl.',
        'Top with fresh blueberries and optional honey or cinnamon.'
      ],
      calories: 290,
      protein: 11,
      carbs: 45,
      fats: 7,
      allergens: ['dairy', 'gluten'],
    ),
    Recipe(
      id: 'r5',
      name: 'Protein Greek Yogurt Cup',
      type: 'Breakfast',
      requiredIngredients: [
        RecipeIngredient(name: 'Greek Yogurt', quantity: 200, unit: 'g'),
        RecipeIngredient(name: 'Blueberries', quantity: 50, unit: 'g'),
        RecipeIngredient(name: 'Almonds', quantity: 15, unit: 'g'),
      ],
      steps: [
        'Spoon rich, cold Greek yogurt into a transparent glass or breakfast cup.',
        'Rinse blueberries and layer them on top of the yogurt.',
        'Chop almonds coarsely and scatter over the berries to add a satisfying crunch.',
        'Serve instantly as a high-protein breakfast or refreshing snack!'
      ],
      calories: 275,
      protein: 24,
      carbs: 18,
      fats: 12,
      allergens: ['dairy', 'nuts'],
    ),
  ];
}
