import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/diet_plan/presentation/screens/diet_plan_screen.dart';
import '../../features/meal_planner/presentation/screens/meal_planner_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../features/shopping_list/presentation/screens/shopping_list_screen.dart';
import '../../features/ocr_scanner/presentation/screens/ocr_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';
  static const String dietPlan = '/diet-plan';
  static const String mealPlanner = '/meal-planner';
  static const String inventory = '/inventory';
  static const String progress = '/progress';
  static const String nutrition = '/nutrition';
  static const String shopping = '/shopping';
  static const String ocr = '/ocr';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      name: 'otp',
      builder: (context, state) => const OtpScreen(),
    ),
    
    // ShellRoute for tabs
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // Return a scaffold with bottom nav here later
        return child; 
      },
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.dietPlan,
          name: 'dietPlan',
          builder: (context, state) => const DietPlanScreen(),
        ),
        GoRoute(
          path: AppRoutes.mealPlanner,
          name: 'mealPlanner',
          builder: (context, state) => const MealPlannerScreen(),
        ),
        GoRoute(
          path: AppRoutes.inventory,
          name: 'inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.progress,
          name: 'progress',
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: AppRoutes.nutrition,
          name: 'nutrition',
          builder: (context, state) => const NutritionScreen(),
        ),
        GoRoute(
          path: AppRoutes.shopping,
          name: 'shopping',
          builder: (context, state) => const ShoppingListScreen(),
        ),
        GoRoute(
          path: AppRoutes.ocr,
          name: 'ocr',
          builder: (context, state) => const OcrScreen(),
        ),
      ],
    ),
  ],
);
