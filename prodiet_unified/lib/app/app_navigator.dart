import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/app/app_routes.dart';

/// Provides a strongly-typed static interface for all navigation actions
/// in the app, preventing hardcoded string usage and typos in the UI.
class AppNavigator {
  AppNavigator._();

  // ─── AUTH ──────────────────────────────────────────────────────────────────

  static void toLogin(BuildContext context) => context.go(AppRoutes.t1Login);
  static void toSignup(BuildContext context) => context.go(AppRoutes.t1Signup);
  static void toOnboarding(BuildContext context) => context.go(AppRoutes.t1Onboarding);
  static void toForgotPassword(BuildContext context) => context.push(AppRoutes.t1ForgotPassword);
  static void toVerifyPhone(BuildContext context) => context.push(AppRoutes.t1VerifyPhone);
  static void toVerifyEmail(BuildContext context, String email) => context.push(AppRoutes.t1VerifyEmail, extra: email);
  static void toHealthGoals(BuildContext context) => context.go(AppRoutes.t1HealthGoals);

  // ─── MAIN (T1) ─────────────────────────────────────────────────────────────

  static void toDashboard(BuildContext context) => context.go(AppRoutes.t1Dashboard);
  static void toDietPlan(BuildContext context) => context.go(AppRoutes.t1DietPlan);
  static void toInventory(BuildContext context) => context.go(AppRoutes.t1Inventory);
  static void toMealPlanner(BuildContext context) => context.go(AppRoutes.t1MealPlanner);
  static void toShopping(BuildContext context) => context.go(AppRoutes.t1Shopping);
  static void toTodayMeals(BuildContext context, {DateTime? date}) => context.push(AppRoutes.t1TodayMeals, extra: date);

  // ─── FEATURES (T1) ─────────────────────────────────────────────────────────

  static void toDietPlanDetail(BuildContext context, DietMeal meal) => 
      context.push(AppRoutes.t1DietPlanDetail, extra: meal);
  static void toHydration(BuildContext context) => context.push(AppRoutes.t1Hydration);
  static void toOcr(BuildContext context) => context.push(AppRoutes.t1Ocr);
  static void toActivitySync(BuildContext context) => context.push(AppRoutes.t1ActivitySync);
  static void toProfile(BuildContext context) => context.push(AppRoutes.t1Profile);
  static void toRecipe(BuildContext context) => context.push(AppRoutes.t1Recipe);
  static void toAchievements(BuildContext context) => context.push(AppRoutes.t1Achievements);

  // ─── T2 NAVIGATION ─────────────────────────────────────────────────────────

  static void toT2Dashboard(BuildContext context) => context.go(AppRoutes.t2Dashboard);
  static void toT2Meals(BuildContext context) => context.go(AppRoutes.t2Meals);
  static void toT2Inventory(BuildContext context) => context.go(AppRoutes.t2Inventory);
  static void toT2Voice(BuildContext context) => context.go(AppRoutes.t2Voice);
  static void toT2DietPlanDetail(BuildContext context, DietPlan plan, DietDay day) =>
      context.push(AppRoutes.t2DietPlanDetail, extra: {'plan': plan, 'day': day});

  // ─── COMMON ────────────────────────────────────────────────────────────────

  static void toPrivacyPolicy(BuildContext context, {bool isT2 = false}) => 
      context.push(isT2 ? AppRoutes.t2PrivacyPolicy : AppRoutes.t1PrivacyPolicy);
  static void toTerms(BuildContext context, {bool isT2 = false}) => 
      context.push(isT2 ? AppRoutes.t2TermsOfService : AppRoutes.t1Terms);

  /// Back navigation helper
  static void back(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else if (context.canPop()) {
      context.pop();
    }
  }
}
