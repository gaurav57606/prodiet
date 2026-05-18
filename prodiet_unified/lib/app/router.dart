import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/shared/presentation/widgets/adaptive_app_shell.dart';

// Unified Screens
import 'package:prodiet_unified/features/auth/presentation/screens/splash_screen.dart' as unified_splash;
import 'package:prodiet_unified/features/auth/presentation/screens/onboarding_screen.dart' as unified_onboarding;
import 'package:prodiet_unified/features/auth/presentation/screens/login_screen.dart' as unified_login;
import 'package:prodiet_unified/features/auth/presentation/screens/signup_screen.dart' as unified_signup;
import 'package:prodiet_unified/features/auth/presentation/screens/forgot_password_screen.dart' as unified_forgot_password;
import 'package:prodiet_unified/features/auth/presentation/screens/health_goals_screen.dart' as unified_health_goals;
import 'package:prodiet_unified/features/auth/presentation/screens/verify_phone_screen.dart' as unified_verify_phone;
import 'package:prodiet_unified/features/auth/presentation/screens/verify_email_screen.dart' as unified_verify_email;
import 'package:prodiet_unified/features/auth/presentation/screens/privacy_policy_screen.dart' as unified_privacy;
import 'package:prodiet_unified/features/auth/presentation/screens/terms_of_service_screen.dart' as unified_terms;

import 'package:prodiet_unified/features/dashboard/presentation/screens/dashboard_screen.dart' as unified_dashboard;
import 'package:prodiet_unified/features/dashboard/presentation/screens/today_meals_screen.dart' as unified_today_meals;
import 'package:prodiet_unified/features/diet_plan/presentation/screens/diet_plan_screen.dart' as unified_diet_plan;
import 'package:prodiet_unified/features/diet_plan/presentation/screens/diet_plan_detail_screen.dart' as unified_diet_plan_detail;
import 'package:prodiet_unified/features/meal_planner/presentation/screens/meal_planner_screen.dart' as unified_meal_planner;
import 'package:prodiet_unified/features/inventory/presentation/screens/inventory_screen.dart' as unified_inventory;
import 'package:prodiet_unified/features/progress/presentation/screens/progress_screen.dart' as unified_progress;
import 'package:prodiet_unified/features/progress/presentation/screens/activity_sync_screen.dart' as unified_activity_sync;
import 'package:prodiet_unified/features/nutrition/presentation/screens/nutrition_screen.dart' as unified_nutrition;
import 'package:prodiet_unified/features/shopping_list/presentation/screens/shopping_list_screen.dart' as unified_shopping;
import 'package:prodiet_unified/features/water/presentation/screens/water_screen.dart' as unified_water;
import 'package:prodiet_unified/features/ocr_scanner/presentation/screens/ocr_scanner_screen.dart' as unified_ocr;
import 'package:prodiet_unified/features/auth/presentation/screens/profile_screen.dart' as unified_profile;
import 'package:prodiet_unified/features/preferences/presentation/screens/preferences_screen.dart' as unified_preferences;
import 'package:prodiet_unified/features/dashboard/presentation/screens/notifications_screen.dart' as unified_notifications;
import 'package:prodiet_unified/features/recipe/presentation/screens/recipe_screen.dart' as unified_recipe;
import 'package:prodiet_unified/features/achievements/presentation/screens/achievements_screen.dart' as achievements;
import 'package:prodiet_unified/features/compensation/presentation/screens/compensation_screen.dart' as unified_compensation;
import 'package:prodiet_unified/features/vendor/presentation/screens/vendor_screen.dart' as unified_vendor;
import 'package:prodiet_unified/features/voice/presentation/screens/voice_screen.dart' as unified_voice;

import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/app/router_notifier.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) => redirectLogic(context, state, ref),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),

      // ─── AUTH ROUTES ────────────────────────────────────────────────────────
      GoRoute(path: AppRoutes.authSplash, builder: (context, state) => const unified_splash.SplashScreen()),
      GoRoute(path: AppRoutes.authOnboarding, builder: (context, state) => const unified_onboarding.OnboardingScreen()),
      GoRoute(path: AppRoutes.authLogin, builder: (context, state) => const unified_login.LoginScreen()),
      GoRoute(path: AppRoutes.authSignup, builder: (context, state) => const unified_signup.SignupScreen()),
      GoRoute(path: AppRoutes.authForgotPassword, builder: (context, state) => const unified_forgot_password.ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.authHealthGoals, builder: (context, state) => const unified_health_goals.HealthGoalsScreen()),
      GoRoute(
        path: AppRoutes.authVerifyPhone, 
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? (state.extra as String? ?? '');
          return unified_verify_phone.VerifyPhoneScreen(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.authVerifyEmail,
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return unified_verify_email.VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(path: AppRoutes.authPrivacyPolicy, builder: (context, state) => const unified_privacy.PrivacyPolicyScreen()),
      GoRoute(path: AppRoutes.authTerms, builder: (context, state) => const unified_terms.TermsOfServiceScreen()),
      GoRoute(path: AppRoutes.authProfileRetry, builder: (context, state) => const _ProfileRetryScreen()),

      // ─── AUTHENTICATED SHELL ────────────────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AdaptiveAppShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard, builder: (context, state) => const unified_dashboard.DashboardScreen()),
          GoRoute(path: AppRoutes.mealPlanner, builder: (context, state) => const unified_meal_planner.MealPlannerScreen()),
          GoRoute(path: AppRoutes.dietPlan, builder: (context, state) => const unified_diet_plan.DietPlanScreen()),
          GoRoute(path: AppRoutes.inventory, builder: (context, state) => const unified_inventory.InventoryScreen()),
          GoRoute(path: AppRoutes.progress, builder: (context, state) => const unified_progress.ProgressScreen()),
          GoRoute(path: AppRoutes.nutrition, builder: (context, state) => const unified_nutrition.NutritionScreen()),
          GoRoute(path: AppRoutes.shopping, builder: (context, state) => const unified_shopping.ShoppingListScreen()),
          GoRoute(path: AppRoutes.voice, builder: (context, state) => const unified_voice.VoiceScreen()),
        ],
      ),

      // ─── STANDALONE FEATURES ────────────────────────────────────────────────
      GoRoute(path: AppRoutes.hydration, builder: (context, state) => const unified_water.WaterScreen()),
      GoRoute(
        path: AppRoutes.todayMeals,
        builder: (context, state) {
          final date = state.extra as DateTime?;
          return unified_today_meals.TodayMealsScreen(date: date);
        },
      ),
      GoRoute(
        path: AppRoutes.dietPlanDetail,
        builder: (context, state) {
          final meal = state.extra as DietMeal?;
          if (meal == null) return const Scaffold(body: Center(child: Text('Missing meal data')));
          return unified_diet_plan_detail.DietPlanDetailScreen(meal: meal);
        },
      ),
      GoRoute(path: AppRoutes.activitySync, builder: (context, state) => const unified_activity_sync.ActivitySyncScreen()),
      GoRoute(path: AppRoutes.ocr, builder: (context, state) => const unified_ocr.OcrScannerScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (context, state) => const unified_notifications.NotificationsScreen()),
      GoRoute(path: AppRoutes.profile, builder: (context, state) => const unified_profile.ProfileScreen()),
      GoRoute(path: AppRoutes.preferences, builder: (context, state) => const unified_preferences.PreferencesScreen()),
      GoRoute(path: AppRoutes.recipe, builder: (context, state) => const unified_recipe.RecipeScreen()),
      GoRoute(path: AppRoutes.achievements, builder: (context, state) => const achievements.AchievementsScreen()),
      GoRoute(path: AppRoutes.compensation, builder: (context, state) => const unified_compensation.CompensationScreen()),
      GoRoute(path: AppRoutes.vendor, builder: (context, state) => const unified_vendor.VendorScreen()),
    ],
  );

  return router;
});

String? redirectLogic(BuildContext context, GoRouterState state, dynamic ref) {
  final isInitialized = ref.read(activeThemeInitializedProvider);
  final authState = ref.read(authProvider);
  final loc = state.matchedLocation;

  // Hold on '/' loading screen until BOTH theme AND auth are ready
  if (!isInitialized || authState is AuthLoading) {
    return loc == '/' ? null : '/';
  }

  const publicRoutes = {
    AppRoutes.authSplash,
    AppRoutes.authLogin,
    AppRoutes.authSignup,
    AppRoutes.authForgotPassword,
    AppRoutes.authOnboarding,
    AppRoutes.authHealthGoals,
    AppRoutes.authVerifyPhone,
    AppRoutes.authVerifyEmail,
    AppRoutes.authPrivacyPolicy,
    AppRoutes.authTerms,
  };

  final isPublic = publicRoutes.contains(loc);

  if (authState is AuthFailure) {
    return isPublic ? null : AppRoutes.authSplash;
  }
  if (authState is AuthUnauthenticated) {
    return isPublic ? null : AppRoutes.authLogin;
  }
  if (authState is AuthProfileMissing) {
    return (loc == AppRoutes.authProfileRetry) ? null : AppRoutes.authProfileRetry;
  }
  if (authState is AuthNeedsOnboarding) {
    return (loc == AppRoutes.authOnboarding || loc == AppRoutes.authHealthGoals)
        ? null
        : AppRoutes.authHealthGoals;
  }
  if (authState is AuthAuthenticated) {
    if (loc == '/' || isPublic) return AppRoutes.dashboard;
    return null;
  }

  return null;
}

class _ProfileRetryScreen extends ConsumerWidget {
  const _ProfileRetryScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userId = authState is AuthProfileMissing ? authState.userId : '';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('⏳ Setting up account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(authProvider.notifier).retryProfileLoad(userId),
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
