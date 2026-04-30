import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/features/auth/application/auth_state.dart';

// Shells
import 'package:prodiet_unified/shared/t1/widgets/dm_app_shell.dart';
import 'package:prodiet_unified/shared/t2/layout/scaffold_with_nav_bar.dart';

// T1 Screens
import 'package:prodiet_unified/features/auth/t1/presentation/screens/splash_screen.dart' as t1_splash;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/onboarding_screen.dart' as t1_onboarding;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/login_screen.dart' as t1_login;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/signup_screen.dart' as t1_signup;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/forgot_password_screen.dart' as t1_forgot_password;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/health_goals_screen.dart' as t1_health_goals;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/verify_phone_screen.dart' as t1_verify_phone;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/dashboard_screen.dart' as t1_dashboard;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/today_meals_screen.dart' as t1_today_meals;
import 'package:prodiet_unified/features/diet_plan/t1/presentation/screens/diet_plan_screen.dart' as t1_diet_plan;
import 'package:prodiet_unified/features/meal_planner/t1/presentation/screens/meal_planner_screen.dart' as t1_meal_planner;
import 'package:prodiet_unified/features/inventory/t1/presentation/screens/inventory_screen.dart' as t1_inventory;
import 'package:prodiet_unified/features/progress/t1/presentation/screens/progress_screen.dart' as t1_progress;
import 'package:prodiet_unified/features/nutrition/t1/presentation/screens/nutrition_screen.dart' as t1_nutrition;
import 'package:prodiet_unified/features/shopping_list/t1/presentation/screens/shopping_list_screen.dart' as t1_shopping;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/hydration_screen.dart' as t1_hydration;
import 'package:prodiet_unified/features/progress/t1/presentation/screens/activity_sync_screen.dart' as t1_activity_sync;
import 'package:prodiet_unified/features/ocr_scanner/t1/presentation/screens/ocr_scanner_screen.dart' as t1_ocr;

// T2 Screens
import 'package:prodiet_unified/features/auth/t2/presentation/screens/splash_screen.dart' as t2_splash;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/onboarding_screen.dart' as t2_onboarding;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/login_screen.dart' as t2_login;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/signup_screen.dart' as t2_signup;
import 'package:prodiet_unified/features/dashboard/t2/presentation/screens/dashboard_screen.dart' as t2_dashboard;
import 'package:prodiet_unified/features/meal_planner/t2/presentation/screens/meal_planner_screen.dart' as t2_meal_planner;
import 'package:prodiet_unified/features/diet_plan/t2/presentation/screens/diet_plan_screen.dart' as t2_diet_plan;
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/inventory/t2/presentation/screens/inventory_screen.dart' as t2_inventory;
import 'package:prodiet_unified/features/voice/t2/presentation/screens/voice_screen.dart' as t2_voice;
import 'package:prodiet_unified/features/diet_plan/t2/presentation/screens/diet_plan_detail_screen.dart' as t2_diet_plan_detail;
import 'package:prodiet_unified/features/water/t2/presentation/screens/water_screen.dart' as t2_water;
import 'package:prodiet_unified/features/ocr_scanner/t2/presentation/screens/ocr_screen.dart' as t2_ocr;
import 'package:prodiet_unified/features/recipe/t2/presentation/screens/recipe_screen.dart' as t2_recipe;
import 'package:prodiet_unified/features/compensation/t2/presentation/screens/compensation_screen.dart' as t2_compensation;
import 'package:prodiet_unified/features/vendor/t2/presentation/screens/vendor_screen.dart' as t2_vendor;
import 'package:prodiet_unified/features/fitband/t2/presentation/screens/fitband_screen.dart' as t2_fitband;
import 'package:prodiet_unified/features/preferences/t2/presentation/screens/preferences_screen.dart' as t2_preferences;

class AppRoutes {
  // T1 Standalone
  static const String t1Splash = '/t1/splash';
  static const String t1Onboarding = '/t1/onboarding';
  static const String t1Login = '/t1/login';
  static const String t1Signup = '/t1/signup';
  static const String t1ForgotPassword = '/t1/forgot-password';
  static const String t1HealthGoals = '/t1/health-goals';
  static const String t1VerifyPhone = '/t1/verify-phone';

  // T1 Shell
  static const String t1Dashboard = '/t1/dashboard';
  static const String t1TodayMeals = '/t1/today-meals';
  static const String t1DietPlan = '/t1/diet-plan';
  static const String t1MealPlanner = '/t1/meal-planner';
  static const String t1Inventory = '/t1/inventory';
  static const String t1Progress = '/t1/progress';
  static const String t1Nutrition = '/t1/nutrition';
  static const String t1Shopping = '/t1/shopping';

  // T1 Standalone Features
  static const String t1Hydration = '/t1/hydration';
  static const String t1ActivitySync = '/t1/activity-sync';
  static const String t1Ocr = '/t1/ocr';

  // T1 Aliases (to fix undefined getter errors in migrated T1 screens)
  static const String splashName = 't1Splash';
  static const String onboardingName = 't1Onboarding';
  static const String loginName = 't1Login';
  static const String signupName = 't1Signup';
  static const String forgotPasswordName = 't1ForgotPassword';
  static const String healthGoalsName = 't1HealthGoals';
  static const String verifyPhoneName = 't1VerifyPhone';
  static const String dashboardName = 't1Dashboard';
  static const String mealsName = 't1MealPlanner';
  static const String inventoryName = 't1Inventory';
  static const String dietPlanName = 't1DietPlan';
  static const String activitySyncName = 't1ActivitySync';
  static const String ocrName = 't1Ocr';
  static const String progressName = 't1Progress';
  // TODO: These routes are not yet registered. Do not use goNamed() with these until screens are built.
  static const String recipeName = 't1Recipe';
  static const String profileName = 't1Profile';
  static const String notificationsName = 't1Notifications';

  // T2 Standalone
  static const String t2Splash = '/t2/splash';
  static const String t2Onboarding = '/t2/onboarding';
  static const String t2Login = '/t2/login';
  static const String t2Signup = '/t2/signup';

  // T2 Shell
  static const String t2Dashboard = '/t2/dashboard';
  static const String t2Meals = '/t2/meals';
  static const String t2DietPlan = '/t2/diet-plan';
  static const String t2Inventory = '/t2/inventory';
  static const String t2Voice = '/t2/voice';

  // T2 Standalone Features
  static const String t2DietPlanDetail = '/t2/diet-plan/detail';
  static const String t2Water = '/t2/water';
  static const String t2Ocr = '/t2/ocr';
  static const String t2Recipe = '/t2/recipe';
  static const String t2Compensation = '/t2/compensation';
  static const String t2Vendor = '/t2/vendor';
  static const String t2Fitband = '/t2/fitband';
  static const String t2Preferences = '/t2/preferences';
}

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellT1Key = GlobalKey<NavigatorState>(debugLabel: 'shellT1');
final GlobalKey<NavigatorState> _shellT2Key = GlobalKey<NavigatorState>(debugLabel: 'shellT2');

/// Bridges Riverpod auth state changes into GoRouter's
/// refreshListenable so redirects fire automatically.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(ProviderContainer container) {
    container.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
  }
}

GoRouter createAppRouter(ProviderContainer ref) => GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  refreshListenable: _AuthStateNotifier(ref),
  redirect: (context, state) {
    // ── EXISTING theme-redirect (keep this block EXACTLY) ──
    if (state.matchedLocation == '/') {
      try {
        final container = ProviderScope.containerOf(context);
        final active = container.read(activeThemeProvider);
        if (active == ActiveTheme.t2Dark ||
            active == ActiveTheme.t2Light ||
            active == ActiveTheme.t2Amoled) {
          return '/t2/splash';
        }
        return '/t1/splash';
      } catch (e) {
        return '/t1/splash';
      }
    }

    // ── NEW: Auth guard ──
    final authState = ref.read(authProvider);
    final loc = state.matchedLocation;

    const publicRoutes = {
      '/t1/splash', '/t2/splash',
      '/t1/login',  '/t2/login',
      '/t1/signup', '/t2/signup',
      '/t1/forgot-password',
      '/t1/onboarding', '/t2/onboarding',
      '/t1/health-goals',
//      '/t1/verify-phone', // TODO: re-enable when phone auth is implemented
    };

    final isPublic = publicRoutes.contains(loc);

    final activeTheme = ref.read(activeThemeProvider);
    final isT2 = activeTheme == ActiveTheme.t2Dark ||
                 activeTheme == ActiveTheme.t2Light ||
                 activeTheme == ActiveTheme.t2Amoled;

    if (authState is AuthLoading) {
      return loc.contains('splash') ? null : (isT2 ? '/t2/splash' : '/t1/splash');
    }
    if (authState is AuthUnauthenticated) {
      return isPublic ? null : (isT2 ? '/t2/login' : '/t1/login');
    }
    if (authState is AuthNeedsOnboarding) {
      if (isT2) return (loc == '/t2/onboarding') ? null : '/t2/onboarding';
      return (loc == '/t1/health-goals') ? null : '/t1/health-goals';
    }
    if (authState is AuthAuthenticated) {
      if (isPublic && !loc.contains('splash')) {
        return isT2 ? '/t2/dashboard' : '/t1/dashboard';
      }
      return null;
    }
    return null;
  },
  routes: [
    // Standalone T1/T2 screens

    // T1 Standalone
    GoRoute(path: AppRoutes.t1Splash, name: 't1Splash', builder: (context, state) => const t1_splash.SplashScreen()),
    GoRoute(path: AppRoutes.t1Onboarding, name: 't1Onboarding', builder: (context, state) => const t1_onboarding.OnboardingScreen()),
    GoRoute(path: AppRoutes.t1Login, name: 't1Login', builder: (context, state) => const t1_login.LoginScreen()),
    GoRoute(path: AppRoutes.t1Signup, name: 't1Signup', builder: (context, state) => const t1_signup.SignupScreen()),
    GoRoute(path: AppRoutes.t1ForgotPassword, name: 't1ForgotPassword', builder: (context, state) => const t1_forgot_password.ForgotPasswordScreen()),
    GoRoute(path: AppRoutes.t1HealthGoals, name: 't1HealthGoals', builder: (context, state) => const t1_health_goals.HealthGoalsScreen()),
//    GoRoute(path: AppRoutes.t1VerifyPhone, name: 't1VerifyPhone', builder: (context, state) => const t1_verify_phone.VerifyPhoneScreen()), // TODO: re-enable when phone auth is implemented

    // T1 Shell
    ShellRoute(
      navigatorKey: _shellT1Key,
      builder: (context, state, child) => DmAppShell(child: child),
      routes: [
        GoRoute(path: AppRoutes.t1Dashboard, name: 't1Dashboard', builder: (context, state) => const t1_dashboard.DashboardScreen()),
        GoRoute(path: AppRoutes.t1TodayMeals, name: 't1TodayMeals', builder: (context, state) => const t1_today_meals.TodayMealsScreen()),
        GoRoute(path: AppRoutes.t1DietPlan, name: 't1DietPlan', builder: (context, state) => const t1_diet_plan.DietPlanScreen()),
        GoRoute(path: AppRoutes.t1MealPlanner, name: 't1MealPlanner', builder: (context, state) => const t1_meal_planner.MealPlannerScreen()),
        GoRoute(path: AppRoutes.t1Inventory, name: 't1Inventory', builder: (context, state) => const t1_inventory.InventoryScreen()),
        GoRoute(path: AppRoutes.t1Progress, name: 't1Progress', builder: (context, state) => const t1_progress.ProgressScreen()),
        GoRoute(path: AppRoutes.t1Nutrition, name: 't1Nutrition', builder: (context, state) => const t1_nutrition.NutritionScreen()),
        GoRoute(path: AppRoutes.t1Shopping, name: 't1Shopping', builder: (context, state) => const t1_shopping.ShoppingListScreen()),
      ],
    ),

    // T1 Standalone Features
    GoRoute(path: AppRoutes.t1Hydration, name: 't1Hydration', builder: (context, state) => const t1_hydration.HydrationScreen()),
    GoRoute(path: AppRoutes.t1ActivitySync, name: 't1ActivitySync', builder: (context, state) => const t1_activity_sync.ActivitySyncScreen()),
    GoRoute(path: AppRoutes.t1Ocr, name: 't1Ocr', builder: (context, state) => const t1_ocr.OcrScannerScreen()),

    // T2 Standalone
    GoRoute(path: AppRoutes.t2Splash, name: 't2Splash', builder: (context, state) => const t2_splash.SplashScreen()),
    GoRoute(path: AppRoutes.t2Onboarding, name: 't2Onboarding', builder: (context, state) => const t2_onboarding.OnboardingScreen()),
    GoRoute(path: AppRoutes.t2Login, name: 't2Login', builder: (context, state) => const t2_login.LoginScreen()),
    GoRoute(path: AppRoutes.t2Signup, name: 't2Signup', builder: (context, state) => const t2_signup.SignupScreen()),

    // T2 Shell
    ShellRoute(
      navigatorKey: _shellT2Key,
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(path: AppRoutes.t2Dashboard, name: 't2Dashboard', builder: (context, state) => const t2_dashboard.DashboardScreen()),
        GoRoute(path: AppRoutes.t2Meals, name: 't2Meals', builder: (context, state) => const t2_meal_planner.MealPlannerScreen()),
        GoRoute(path: AppRoutes.t2DietPlan, name: 't2DietPlan', builder: (context, state) => const t2_diet_plan.DietPlanScreen()),
        GoRoute(path: AppRoutes.t2Inventory, name: 't2Inventory', builder: (context, state) => const t2_inventory.InventoryScreen()),
        GoRoute(path: AppRoutes.t2Voice, name: 't2Voice', builder: (context, state) => const t2_voice.VoiceScreen()),
      ],
    ),

    // T2 Standalone Features
    GoRoute(
      path: AppRoutes.t2DietPlanDetail, 
      name: 't2DietPlanDetail', 
      builder: (context, state) => t2_diet_plan_detail.DietPlanDetailScreen(
        day: state.extra as DietDay,
      ),
    ),
    GoRoute(path: AppRoutes.t2Water, name: 't2Water', builder: (context, state) => const t2_water.WaterScreen()),
    GoRoute(path: AppRoutes.t2Ocr, name: 't2Ocr', builder: (context, state) => const t2_ocr.OcrScreen()),
    GoRoute(path: AppRoutes.t2Recipe, name: 't2Recipe', builder: (context, state) => const t2_recipe.RecipeScreen()),
    GoRoute(path: AppRoutes.t2Compensation, name: 't2Compensation', builder: (context, state) => const t2_compensation.CompensationScreen()),
    GoRoute(path: AppRoutes.t2Vendor, name: 't2Vendor', builder: (context, state) => const t2_vendor.VendorScreen()),
    GoRoute(path: AppRoutes.t2Fitband, name: 't2Fitband', builder: (context, state) => const t2_fitband.FitbandScreen()),
    GoRoute(path: AppRoutes.t2Preferences, name: 't2Preferences', builder: (context, state) => const t2_preferences.PreferencesScreen()),
  ],
);
