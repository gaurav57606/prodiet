import 'package:flutter/material.dart';

class EmptyStateConfigs {
  static const dashboard = (
    icon: Icons.wb_sunny_rounded,
    headline: 'Your day starts here',
    subtext: 'Log your first meal to wake up your dashboard.',
    buttonLabel: 'Log a Meal',
  );
  static const mealPlanner = (
    icon: Icons.restaurant_menu_rounded,
    headline: 'Nothing planned yet',
    subtext: 'Let AI build your first 7-day meal plan in seconds.',
    buttonLabel: 'Generate Plan',
  );
  static const inventory = (
    icon: Icons.shopping_basket_rounded,
    headline: 'Your pantry is empty',
    subtext: 'Scan a grocery bill or add items manually to get started.',
    buttonLabel: 'Scan a Bill',
  );
  static const water = (
    icon: Icons.water_drop_rounded,
    headline: 'Stay hydrated today',
    subtext: 'Log your first glass. Your goal is 8 glasses a day.',
    buttonLabel: 'Log a Glass',
  );
  static const progress = (
    icon: Icons.trending_up_rounded,
    headline: 'Your story is just beginning',
    subtext: 'Log your weight today. Your first data point unlocks your chart.',
    buttonLabel: 'Log Weight',
  );
  static const shoppingList = (
    icon: Icons.shopping_cart_rounded,
    headline: 'Nothing on your list',
    subtext: 'Low on something? Add it here and order from Blinkit in 1 tap.',
    buttonLabel: 'Add Item',
  );
  static const achievements = (
    icon: Icons.emoji_events_rounded,
    headline: 'Your first badge is waiting',
    subtext: 'Log meals for 3 days in a row to earn your first achievement.',
    buttonLabel: null,
  );
  static const dietPlan = (
    icon: Icons.restaurant_rounded,
    headline: 'No plan yet',
    subtext: 'Tell us your goals and let AI create a personalised diet plan.',
    buttonLabel: 'Create My Plan',
  );
  static const nutrition = (
    icon: Icons.science_rounded,
    headline: 'Search any food',
    subtext: 'Type a food name above to see full nutrition breakdown.',
    buttonLabel: null,
  );
  static const ocr = (
    icon: Icons.camera_alt_rounded,
    headline: 'Point at any grocery bill',
    subtext: 'Your camera will read the items and add them to your pantry automatically.',
    buttonLabel: null,
  );
}
