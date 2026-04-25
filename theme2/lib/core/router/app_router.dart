import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/meal_planner/presentation/screens/meal_planner_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/diet_plan/presentation/screens/diet_plan_screen.dart';
import '../../features/diet_plan/presentation/screens/diet_plan_detail_screen.dart';
import '../../features/water/presentation/screens/water_screen.dart';
import '../../features/ocr_scanner/presentation/screens/ocr_screen.dart';
import '../../features/recipe/presentation/screens/recipe_screen.dart';
import '../../features/compensation/presentation/screens/compensation_screen.dart';
import '../../features/voice/presentation/screens/voice_screen.dart';
import '../../features/vendor/presentation/screens/vendor_screen.dart';
import '../../features/fitband/presentation/screens/fitband_screen.dart';
import '../../features/preferences/presentation/screens/preferences_screen.dart';
import '../../shared/layout/scaffold_with_nav_bar.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String meals = '/meals';
  static const String inventory = '/inventory';
  static const String dietPlan = '/diet-plan';
  static const String dietPlanDetail = '/diet-plan/detail';
  static const String water = '/water';
  static const String ocr = '/ocr';
  static const String recipe = '/recipe';
  static const String compensation = '/compensation';
  static const String voice = '/voice';
  static const String vendor = '/vendor';
  static const String fitband = '/fitband';
  static const String preferences = '/preferences';
}

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = GoRouter(
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
    
    // ShellRoute for Bottom Navigation Bar
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.meals,
          name: 'meals',
          builder: (context, state) => const MealPlannerScreen(),
        ),
        GoRoute(
          path: AppRoutes.voice,
          name: 'voice',
          builder: (context, state) => const VoiceScreen(),
        ),
        GoRoute(
          path: AppRoutes.inventory,
          name: 'inventory',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.dietPlan,
          name: 'dietPlan',
          builder: (context, state) => const DietPlanScreen(),
        ),
      ],
    ),

    // Sub-screens (could be shells or standalone)
    GoRoute(
      path: AppRoutes.dietPlanDetail,
      name: 'dietPlanDetail',
      builder: (context, state) => const DietPlanDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.water,
      name: 'water',
      builder: (context, state) => const WaterScreen(),
    ),
    GoRoute(
      path: AppRoutes.ocr,
      name: 'ocr',
      builder: (context, state) => const OcrScreen(),
    ),
    GoRoute(
      path: AppRoutes.recipe,
      name: 'recipe',
      builder: (context, state) => const RecipeScreen(),
    ),
    GoRoute(
      path: AppRoutes.compensation,
      name: 'compensation',
      builder: (context, state) => const CompensationScreen(),
    ),
    GoRoute(
      path: AppRoutes.vendor,
      name: 'vendor',
      builder: (context, state) => const VendorScreen(),
    ),
    GoRoute(
      path: AppRoutes.fitband,
      name: 'fitband',
      builder: (context, state) => const FitbandScreen(),
    ),
    GoRoute(
      path: AppRoutes.preferences,
      name: 'preferences',
      builder: (context, state) => const PreferencesScreen(),
    ),
  ],
);
