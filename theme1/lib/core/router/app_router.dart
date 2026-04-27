import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/diet_plan/presentation/screens/diet_plan_screen.dart';
import '../../features/meal_planner/presentation/screens/meal_planner_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/nutrition/presentation/screens/nutrition_screen.dart';
import '../../features/shopping_list/presentation/screens/shopping_list_screen.dart';
import '../../features/ocr_scanner/presentation/screens/ocr_scanner_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/health_goals_screen.dart';
import '../../features/auth/presentation/screens/verify_phone_screen.dart';
import '../../features/progress/presentation/screens/activity_sync_screen.dart';

// Shared Widgets
import '../../shared/widgets/dm_app_shell.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String dietPlan = '/diet-plan';
  static const String mealPlanner = '/meal-planner';
  static const String inventory = '/inventory';
  static const String progress = '/progress';
  static const String nutrition = '/nutrition';
  static const String shopping = '/shopping';
  static const String ocr = '/ocr';
  static const String activitySync = '/activity-sync';
  static const String healthGoals = '/health-goals';
  static const String verifyPhone = '/verify-phone';
  static const String forgotPassword = '/forgot-password';

  // Names
  static const String splashName = 'splash';
  static const String onboardingName = 'onboarding';
  static const String loginName = 'login';
  static const String signupName = 'signup';
  static const String dashboardName = 'dashboard';
  static const String dietPlanName = 'dietPlan';
  static const String mealPlannerName = 'mealPlanner';
  static const String inventoryName = 'inventory';
  static const String progressName = 'progress';
  static const String nutritionName = 'nutrition';
  static const String shoppingName = 'shopping';
  static const String ocrName = 'ocr';
  static const String activitySyncName = 'activitySync';
  static const String healthGoalsName = 'healthGoals';
  static const String verifyPhoneName = 'verifyPhone';
  static const String forgotPasswordName = 'forgotPassword';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // Auth Routes
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splashName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboardingName,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.loginName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signupName,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRoutes.forgotPasswordName,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.healthGoals,
      name: AppRoutes.healthGoalsName,
      builder: (context, state) => const HealthGoalsScreen(),
    ),
    GoRoute(
      path: AppRoutes.verifyPhone,
      name: AppRoutes.verifyPhoneName,
      builder: (context, state) => const VerifyPhoneScreen(),
    ),

    // Main App Shell (with Bottom Nav)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => DmAppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: AppRoutes.dashboardName,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.dietPlan,
          name: AppRoutes.dietPlanName,
          builder: (context, state) => const DietPlanScreen(),
        ),
        GoRoute(
          path: AppRoutes.mealPlanner,
          name: AppRoutes.mealPlannerName,
          builder: (context, state) => const MealPlannerScreen(),
        ),
        GoRoute(
          path: AppRoutes.inventory,
          name: AppRoutes.inventoryName,
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.progress,
          name: AppRoutes.progressName,
          builder: (context, state) => const ProgressScreen(),
        ),
        GoRoute(
          path: AppRoutes.nutrition,
          name: AppRoutes.nutritionName,
          builder: (context, state) => const NutritionScreen(),
        ),
        GoRoute(
          path: AppRoutes.shopping,
          name: AppRoutes.shoppingName,
          builder: (context, state) => const ShoppingListScreen(),
        ),
      ],
    ),
    
    // Full screen routes
    GoRoute(
      path: AppRoutes.ocr,
      name: AppRoutes.ocrName,
      builder: (context, state) => const OcrScannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.activitySync,
      name: AppRoutes.activitySyncName,
      builder: (context, state) => const ActivitySyncScreen(),
    ),
  ],
);
