import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:prodiet_unified/features/auth/application/auth_providers.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/core/services/fcm_service.dart';

// Shells
import 'package:prodiet_unified/shared/t1/widgets/dm_app_shell.dart';
import 'package:prodiet_unified/shared/t2/layout/scaffold_with_nav_bar.dart';

// T1 Screens
import 'package:prodiet_unified/features/auth/presentation/t1/screens/splash_screen.dart' as t1_splash;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/onboarding_screen.dart' as t1_onboarding;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/login_screen.dart' as t1_login;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/signup_screen.dart' as t1_signup;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/forgot_password_screen.dart' as t1_forgot_password;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/health_goals_screen.dart' as t1_health_goals;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/verify_phone_screen.dart' as t1_verify_phone;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/verify_email_screen.dart' as t1_verify_email;
import 'package:prodiet_unified/features/dashboard/presentation/t1/screens/today_meals_screen.dart' as t1_today_meals;
import 'package:prodiet_unified/features/diet_plan/presentation/t1/screens/diet_plan_screen.dart' as t1_diet_plan;
import 'package:prodiet_unified/features/diet_plan/presentation/t1/screens/diet_plan_detail_screen.dart' as t1_diet_plan_detail;
import 'package:prodiet_unified/features/meal_planner/presentation/t1/screens/meal_planner_screen.dart' as t1_meal_planner;
import 'package:prodiet_unified/features/inventory/presentation/t1/screens/inventory_screen.dart' as t1_inventory;
import 'package:prodiet_unified/features/progress/presentation/t1/screens/progress_screen.dart' as t1_progress;
import 'package:prodiet_unified/features/nutrition/presentation/t1/screens/nutrition_screen.dart' as t1_nutrition;
import 'package:prodiet_unified/features/shopping_list/presentation/t1/screens/shopping_list_screen.dart' as t1_shopping;
import 'package:prodiet_unified/features/dashboard/presentation/t1/screens/hydration_screen.dart' as t1_hydration;
import 'package:prodiet_unified/features/progress/presentation/t1/screens/activity_sync_screen.dart' as t1_activity_sync;
import 'package:prodiet_unified/features/ocr_scanner/presentation/t1/screens/ocr_scanner_screen.dart' as t1_ocr;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/profile_screen.dart' as t1_profile;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/preferences_screen.dart' as t1_preferences;
import 'package:prodiet_unified/features/dashboard/presentation/t1/screens/notifications_screen.dart' as t1_notifications;
import 'package:prodiet_unified/features/recipe/presentation/t1/screens/recipe_screen.dart' as t1_recipe;
import 'package:prodiet_unified/features/achievements/presentation/screens/achievements_screen.dart' as achievements;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/privacy_policy_screen.dart' as t1_privacy_v2;
import 'package:prodiet_unified/features/auth/presentation/t1/screens/terms_screen.dart' as t1_terms_v2;

// Unified Screens
import 'package:prodiet_unified/features/dashboard/presentation/screens/dashboard_screen.dart' as unified_dashboard;

// T2 Screens
import 'package:prodiet_unified/features/auth/presentation/t2/screens/splash_screen.dart' as t2_splash;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/onboarding_screen.dart' as t2_onboarding;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/login_screen.dart' as t2_login;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/signup_screen.dart' as t2_signup;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/forgot_password_screen.dart' as t2_forgot_password;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/verify_phone_screen.dart' as t2_verify_phone;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/privacy_policy_screen.dart' as t2_privacy;
import 'package:prodiet_unified/features/auth/presentation/t2/screens/terms_of_service_screen.dart' as t2_terms;
import 'package:prodiet_unified/features/meal_planner/presentation/t2/screens/meal_planner_screen.dart' as t2_meal_planner;
import 'package:prodiet_unified/features/diet_plan/presentation/t2/screens/diet_plan_screen.dart' as t2_diet_plan;
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
import 'package:prodiet_unified/features/inventory/presentation/t2/screens/inventory_screen.dart' as t2_inventory;
import 'package:prodiet_unified/features/voice/presentation/t2/screens/voice_screen.dart' as t2_voice;
import 'package:prodiet_unified/features/diet_plan/presentation/t2/screens/diet_plan_detail_screen.dart' as t2_diet_plan_detail;
import 'package:prodiet_unified/features/water/presentation/t2/screens/water_screen.dart' as t2_water;
import 'package:prodiet_unified/features/ocr_scanner/presentation/t2/screens/ocr_screen.dart' as t2_ocr;
import 'package:prodiet_unified/features/recipe/presentation/t2/screens/recipe_screen.dart' as t2_recipe;
import 'package:prodiet_unified/features/compensation/presentation/t2/screens/compensation_screen.dart' as t2_compensation;
import 'package:prodiet_unified/features/vendor/presentation/t2/screens/vendor_screen.dart' as t2_vendor;
import 'package:prodiet_unified/features/fitband/presentation/t2/screens/fitband_screen.dart' as t2_fitband;
import 'package:prodiet_unified/features/preferences/presentation/t2/screens/preferences_screen.dart' as t2_preferences;

import 'package:prodiet_unified/app/app_routes.dart';
import 'package:prodiet_unified/app/router_notifier.dart';
import 'package:prodiet_unified/app/app_navigator.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellT1Key = GlobalKey<NavigatorState>(debugLabel: 'shellT1');
final _shellT2Key = GlobalKey<NavigatorState>(debugLabel: 'shellT2');

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);
  
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: notifier,
    redirect: (context, state) => redirectLogic(context, state, ref),
    routes: [
      // Safe loading fallback for root path
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),

      // T1 Standalone
      GoRoute(path: AppRoutes.t1Splash, name: 't1Splash', builder: (context, state) => const t1_splash.SplashScreen()),
      GoRoute(path: AppRoutes.t1Onboarding, name: 't1Onboarding', builder: (context, state) => const t1_onboarding.OnboardingScreen()),
      GoRoute(path: AppRoutes.t1Login, name: 't1Login', builder: (context, state) => const t1_login.LoginScreen()),
      GoRoute(path: AppRoutes.t1Signup, name: 't1Signup', builder: (context, state) => const t1_signup.SignupScreen()),
      GoRoute(path: AppRoutes.t1ForgotPassword, name: 't1ForgotPassword', builder: (context, state) => const t1_forgot_password.ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.t1HealthGoals, name: 't1HealthGoals', builder: (context, state) => const t1_health_goals.HealthGoalsScreen()),
      GoRoute(path: AppRoutes.t1VerifyPhone, name: 't1VerifyPhone', builder: (context, state) => const t1_verify_phone.VerifyPhoneScreen()),
      GoRoute(
        path: AppRoutes.t1VerifyEmail,
        name: 't1VerifyEmail',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return t1_verify_email.VerifyEmailScreen(email: email);
        },
      ),
      GoRoute(path: AppRoutes.t1PrivacyPolicy, name: 't1PrivacyPolicy', builder: (context, state) => const t1_privacy_v2.PrivacyPolicyScreen()),
      GoRoute(path: AppRoutes.t1Terms, name: 't1Terms', builder: (context, state) => const t1_terms_v2.TermsScreen()),

      // T1 Shell
      ShellRoute(
        navigatorKey: _shellT1Key,
        builder: (context, state, child) => DmAppShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.t1Dashboard, name: 't1Dashboard', builder: (context, state) => const unified_dashboard.DashboardScreen()),
          GoRoute(
            path: AppRoutes.t1TodayMeals,
            name: 't1TodayMeals',
            builder: (context, state) {
              final date = state.extra as DateTime?;
              return t1_today_meals.TodayMealsScreen(date: date);
            },
          ),
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
      GoRoute(
        path: AppRoutes.t1DietPlanDetail,
        name: 't1DietPlanDetail',
        builder: (context, state) {
          final meal = state.extra as DietMeal?;
          if (meal == null) {
            return const Scaffold(
              body: Center(child: Text('Navigation error: missing meal data.')),
            );
          }
          return t1_diet_plan_detail.DietPlanDetailScreen(meal: meal);
        },
      ),
      GoRoute(path: AppRoutes.t1ActivitySync, name: 't1ActivitySync', builder: (context, state) => const t1_activity_sync.ActivitySyncScreen()),
      GoRoute(path: AppRoutes.t1Ocr, name: 't1Ocr', builder: (context, state) => const t1_ocr.OcrScannerScreen()),
      GoRoute(path: AppRoutes.t1Profile, name: 't1Profile', builder: (context, state) => const t1_profile.ProfileScreen()),
      GoRoute(path: AppRoutes.t1Notifications, name: 't1Notifications', builder: (context, state) => const t1_notifications.NotificationsScreen()),
      GoRoute(path: AppRoutes.t1Recipe, name: 't1Recipe', builder: (context, state) => const t1_recipe.RecipeScreen()),
      GoRoute(path: AppRoutes.t1Preferences, name: 't1Preferences', builder: (context, state) => const t1_preferences.PreferencesScreen()),
      GoRoute(path: AppRoutes.t1Achievements, name: 't1Achievements', builder: (context, state) => const achievements.AchievementsScreen()),

      // T2 Standalone
      GoRoute(path: AppRoutes.t2Splash, name: 't2Splash', builder: (context, state) => const t2_splash.SplashScreen()),
      GoRoute(path: AppRoutes.t2Onboarding, name: 't2Onboarding', builder: (context, state) => const t2_onboarding.OnboardingScreen()),
      GoRoute(path: AppRoutes.t2Login, name: 't2Login', builder: (context, state) => const t2_login.LoginScreen()),
      GoRoute(path: AppRoutes.t2Signup, name: 't2Signup', builder: (context, state) => const t2_signup.SignupScreen()),
      GoRoute(
        path: AppRoutes.t2VerifyPhone,
        name: 't2VerifyPhone',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return t2_verify_phone.VerifyPhoneScreen(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.t2ForgotPassword,
        name: 't2ForgotPassword',
        builder: (context, state) => const t2_forgot_password.ForgotPasswordScreen(),
      ),

      // T2 Shell
      ShellRoute(
        navigatorKey: _shellT2Key,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(path: AppRoutes.t2Dashboard, name: 't2Dashboard', builder: (context, state) => const unified_dashboard.DashboardScreen()),
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
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final plan = extras?['plan'] as DietPlan?;
          final day = extras?['day'] as DietDay?;
          if (plan == null || day == null) {
            return const Scaffold(
              body: Center(child: Text('Navigation error: missing plan data.')),
            );
          }
          return t2_diet_plan_detail.DietPlanDetailScreen(plan: plan, day: day);
        },
      ),
      GoRoute(path: AppRoutes.t2Water, name: 't2Water', builder: (context, state) => const t2_water.WaterScreen()),
      GoRoute(path: AppRoutes.t2Ocr, name: 't2Ocr', builder: (context, state) => const t2_ocr.OcrScreen()),
      GoRoute(path: AppRoutes.t2Recipe, name: 't2Recipe', builder: (context, state) => const t2_recipe.RecipeScreen()),
      GoRoute(path: AppRoutes.t2Compensation, name: 't2Compensation', builder: (context, state) => const t2_compensation.CompensationScreen()),
      GoRoute(path: AppRoutes.t2Vendor, name: 't2Vendor', builder: (context, state) => const t2_vendor.VendorScreen()),
      GoRoute(path: AppRoutes.t2Fitband, name: 't2Fitband', builder: (context, state) => const t2_fitband.FitbandScreen()),
      GoRoute(path: AppRoutes.t2Preferences, name: 't2Preferences', builder: (context, state) => const t2_preferences.PreferencesScreen()),
      GoRoute(path: AppRoutes.t2PrivacyPolicy, name: 't2PrivacyPolicy', builder: (context, state) => const t2_privacy.PrivacyPolicyScreen()),
      GoRoute(path: AppRoutes.t2TermsOfService, name: 't2TermsOfService', builder: (context, state) => const t2_terms.TermsOfServiceScreen()),
      GoRoute(
        path: AppRoutes.t2ProfileRetry,
        builder: (context, state) => const _ProfileRetryScreen(),
      ),
    ],
  );

  AppRouterNavigator.setRouter(router);
  return router;
});

String? redirectLogic(BuildContext context, GoRouterState state, dynamic ref) {
  final isInitialized = ref.read(activeThemeInitializedProvider);
  if (!isInitialized) return '/';

  if (state.matchedLocation == '/') {
    final active = ref.read(activeThemeProvider);
    final isT2 = active == ActiveTheme.t2Dark ||
                 active == ActiveTheme.t2Light ||
                 active == ActiveTheme.t2Amoled;
    return isT2 ? AppRoutes.t2Splash : AppRoutes.t1Splash;
  }

  final authState = ref.read(authProvider);
  final loc = state.matchedLocation;
  
  const publicRoutes = {
    AppRoutes.t1Splash, AppRoutes.t2Splash,
    AppRoutes.t1Login,  AppRoutes.t2Login,
    AppRoutes.t1Signup, AppRoutes.t2Signup,
    AppRoutes.t1ForgotPassword,
    AppRoutes.t2ForgotPassword,
    AppRoutes.t1Onboarding, AppRoutes.t2Onboarding,
    AppRoutes.t1HealthGoals,
    AppRoutes.t1VerifyPhone,
    AppRoutes.t2VerifyPhone,
    AppRoutes.t1VerifyEmail,
    AppRoutes.t1PrivacyPolicy,
    AppRoutes.t1Terms,
    AppRoutes.t2PrivacyPolicy,
    AppRoutes.t2TermsOfService,
  };

  final isPublic = publicRoutes.contains(loc);

  final activeTheme = ref.read(activeThemeProvider);
  final isT2 = activeTheme == ActiveTheme.t2Dark ||
               activeTheme == ActiveTheme.t2Light ||
               activeTheme == ActiveTheme.t2Amoled;

  if (authState is AuthLoading) {
    if (isPublic) return null;
    return loc.contains('splash') ? null : (isT2 ? AppRoutes.t2Splash : AppRoutes.t1Splash);
  }
  if (authState is AuthUnauthenticated) {
    if (loc.contains('splash')) {
      return isT2 ? AppRoutes.t2Login : AppRoutes.t1Login;
    }
    return isPublic ? null : (isT2 ? AppRoutes.t2Login : AppRoutes.t1Login);
  }
  if (authState is AuthProfileMissing) {
    return (loc == AppRoutes.t2ProfileRetry) ? null : AppRoutes.t2ProfileRetry;
  }
  if (authState is AuthNeedsOnboarding) {
    if (isT2) {
      return (loc == AppRoutes.t2Onboarding) ? null : AppRoutes.t2Onboarding;
    }
    if (loc == AppRoutes.t1Onboarding || loc == AppRoutes.t1HealthGoals) return null;
    return AppRoutes.t1HealthGoals;
  }
  if (authState is AuthAuthenticated) {
    if (isPublic) {
      return isT2 ? AppRoutes.t2Dashboard : AppRoutes.t1Dashboard;
    }
    return null;
  }
  if (authState is AuthFailure) {
    if (isPublic) return null;
    if (loc.contains('splash')) {
      return isT2 ? AppRoutes.t2Login : AppRoutes.t1Login;
    }
    return isT2 ? AppRoutes.t2Splash : AppRoutes.t1Splash;
  }
  return null;
}

class _ProfileRetryScreen extends ConsumerWidget {
  const _ProfileRetryScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final authState = ref.watch(authProvider);
    final userId = authState is AuthProfileMissing ? authState.userId : '';
    final isLoading = authState is AuthLoading;

    final activeTheme = ref.read(activeThemeProvider);
    final isT2 = activeTheme.name.contains('t2');

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⏳', style: TextStyle(fontSize: 52)),
              const SizedBox(height: 24),
              Text('Setting up your account',
                textAlign: TextAlign.center,
                style: isT2 
                  ? GoogleFonts.barlowCondensed(fontSize: 32, fontWeight: FontWeight.w900, color: scheme.onSurface)
                  : theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: scheme.onSurface)),
              const SizedBox(height: 12),
              Text('This usually takes just a second.\nTap below if it\'s taking too long.',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
              const SizedBox(height: 40),
              if (isLoading)
                CircularProgressIndicator(color: scheme.primary)
              else
                ElevatedButton(
                  onPressed: () =>
                    ref.read(authProvider.notifier).retryProfileLoad(userId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    minimumSize: const Size(220, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
                  child: const Text('RETRY',
                    style: TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 16)),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                  ref.read(authProvider.notifier).signOut(),
                child: Text('Sign out and try again',
                  style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
