import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prodiet_unified/core/theme/active_theme_provider.dart';
import 'package:prodiet_unified/features/auth/application/auth_providers.dart';

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
import 'package:prodiet_unified/features/auth/t1/presentation/screens/verify_email_screen.dart' as t1_verify_email;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/dashboard_screen.dart' as t1_dashboard;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/today_meals_screen.dart' as t1_today_meals;
import 'package:prodiet_unified/features/diet_plan/t1/presentation/screens/diet_plan_screen.dart' as t1_diet_plan;
import 'package:prodiet_unified/features/diet_plan/t1/presentation/screens/diet_plan_detail_screen.dart' as t1_diet_plan_detail;
import 'package:prodiet_unified/features/meal_planner/t1/presentation/screens/meal_planner_screen.dart' as t1_meal_planner;
import 'package:prodiet_unified/features/inventory/t1/presentation/screens/inventory_screen.dart' as t1_inventory;
import 'package:prodiet_unified/features/progress/t1/presentation/screens/progress_screen.dart' as t1_progress;
import 'package:prodiet_unified/features/nutrition/t1/presentation/screens/nutrition_screen.dart' as t1_nutrition;
import 'package:prodiet_unified/features/shopping_list/t1/presentation/screens/shopping_list_screen.dart' as t1_shopping;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/hydration_screen.dart' as t1_hydration;
import 'package:prodiet_unified/features/progress/t1/presentation/screens/activity_sync_screen.dart' as t1_activity_sync;
import 'package:prodiet_unified/features/ocr_scanner/t1/presentation/screens/ocr_scanner_screen.dart' as t1_ocr;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/profile_screen.dart' as t1_profile;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/preferences_screen.dart' as t1_preferences;
import 'package:prodiet_unified/features/dashboard/t1/presentation/screens/notifications_screen.dart' as t1_notifications;
import 'package:prodiet_unified/features/recipe/t1/presentation/screens/recipe_screen.dart' as t1_recipe;
import 'package:prodiet_unified/features/achievements/presentation/screens/achievements_screen.dart' as achievements;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/privacy_policy_screen.dart' as t1_privacy_v2;
import 'package:prodiet_unified/features/auth/t1/presentation/screens/terms_screen.dart' as t1_terms_v2;

// T2 Screens
import 'package:prodiet_unified/features/auth/t2/presentation/screens/splash_screen.dart' as t2_splash;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/onboarding_screen.dart' as t2_onboarding;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/login_screen.dart' as t2_login;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/signup_screen.dart' as t2_signup;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/forgot_password_screen.dart' as t2_forgot_password;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/verify_phone_screen.dart' as t2_verify_phone;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/privacy_policy_screen.dart' as t2_privacy;
import 'package:prodiet_unified/features/auth/t2/presentation/screens/terms_of_service_screen.dart' as t2_terms;
import 'package:prodiet_unified/features/dashboard/t2/presentation/screens/dashboard_screen.dart' as t2_dashboard;
import 'package:prodiet_unified/features/meal_planner/t2/presentation/screens/meal_planner_screen.dart' as t2_meal_planner;
import 'package:prodiet_unified/features/diet_plan/t2/presentation/screens/diet_plan_screen.dart' as t2_diet_plan;
import 'package:prodiet_unified/features/diet_plan/domain/diet_plan.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_day.dart';
import 'package:prodiet_unified/features/diet_plan/domain/diet_meal.dart';
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
import 'package:prodiet_unified/core/services/fcm_service.dart';

class AppRoutes {
  // T1 Standalone
  static const String t1Splash = '/t1/splash';
  static const String t1Onboarding = '/t1/onboarding';
  static const String t1Login = '/t1/login';
  static const String t1Signup = '/t1/signup';
  static const String t1ForgotPassword = '/t1/forgot-password';
  static const String t1HealthGoals = '/t1/health-goals';
  static const String t1VerifyPhone = '/t1/verify-phone';
  static const String t1VerifyEmail = '/t1/verify-email';
  static const String t1PrivacyPolicy = '/t1/privacy-policy';
  static const String t1Terms = '/t1/terms';

  // T1 Shell
  static const String t1Dashboard = '/t1/dashboard';
  static const String t1TodayMeals = '/t1/today-meals';
  static const String t1DietPlan = '/t1/diet-plan';
  static const String t1MealPlanner = '/t1/meal-planner';
  static const String t1Inventory = '/t1/inventory';
  static const String t1Progress = '/t1/progress';
  static const String t1Nutrition = '/t1/nutrition';
  static const String t1Shopping = '/t1/shopping';
  static const String t1DietPlanDetail = '/t1/diet-plan/detail';

  // T1 Standalone Features
  static const String t1Hydration = '/t1/hydration';
  static const String t1ActivitySync = '/t1/activity-sync';
  static const String t1Ocr = '/t1/ocr';
  static const String t1Profile = '/t1/profile';
  static const String t1Notifications = '/t1/notifications';
  static const String t1Recipe = '/t1/recipe';
  static const String t1Preferences = '/t1/preferences';
  static const String t1Achievements = '/t1/achievements';

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
  static const String recipeName = 't1Recipe';
  static const String profileName = 't1Profile';
  static const String notificationsName = 't1Notifications';
  static const String preferencesName = 't1Preferences';
  static const String achievementsName = 't1Achievements';
  static const String verifyEmailName = 't1VerifyEmail';

  // T2 Standalone
  static const String t2Splash = '/t2/splash';
  static const String t2Onboarding = '/t2/onboarding';
  static const String t2Login = '/t2/login';
  static const String t2Signup = '/t2/signup';
  static const String t2ForgotPassword = '/t2/forgot-password';

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
  static const String t2PrivacyPolicy = '/t2/privacy-policy';
  static const String t2TermsOfService = '/t2/terms-of-service';
  static const String t2VerifyPhone = '/t2/verify-phone';
  static const String t2ProfileRetry = '/t2/profile-retry';
}

final GlobalKey<NavigatorState> appRouterNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellT1Key = GlobalKey<NavigatorState>(debugLabel: 'shellT1');
final GlobalKey<NavigatorState> _shellT2Key = GlobalKey<NavigatorState>(debugLabel: 'shellT2');

/// Bridges Riverpod auth and theme state changes into GoRouter's
/// refreshListenable so redirects fire automatically.
class _AppStateNotifier extends ChangeNotifier {
  _AppStateNotifier(ProviderContainer container) {
    container.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
      fireImmediately: true,
    );
    container.listen<ActiveTheme>(
      activeThemeProvider,
      (_, __) => notifyListeners(),
      fireImmediately: true,
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = createAppRouter(ref.container);
  // Wire the router to the static helper for FCM/Global navigation
  AppRouterNavigator.setRouter(router);
  return router;
});

GoRouter createAppRouter(ProviderContainer ref) => GoRouter(
  navigatorKey: appRouterNavigatorKey,
  initialLocation: '/',
  refreshListenable: _AppStateNotifier(ref),
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
    // Standalone T1/T2 screens

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
        GoRoute(path: AppRoutes.t1Dashboard, name: 't1Dashboard', builder: (context, state) => const t1_dashboard.DashboardScreen()),
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
        final meal = state.extra as DietMeal;
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
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return t2_diet_plan_detail.DietPlanDetailScreen(
          plan: extras['plan'] as DietPlan,
          day: extras['day'] as DietDay,
        );
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

String? redirectLogic(BuildContext context, GoRouterState state, ProviderContainer ref) {
  // ── Guard: Wait for theme initialization ──
  final isInitialized = ref.read(activeThemeInitializedProvider);
  if (!isInitialized) return '/';

  // ── Root redirect — fully theme aware ──
  if (state.matchedLocation == '/') {
    final active = ref.read(activeThemeProvider);
    final isT2 = active == ActiveTheme.t2Dark ||
                 active == ActiveTheme.t2Light ||
                 active == ActiveTheme.t2Amoled;
    return isT2 ? '/t2/splash' : '/t1/splash';
  }

  // ── Auth guard ──
  final authState = ref.read(authProvider);
  final loc = state.matchedLocation;
  
  const publicRoutes = {
    '/t1/splash', '/t2/splash',
    '/t1/login',  '/t2/login',
    '/t1/signup', '/t2/signup',
    '/t1/forgot-password',
    '/t2/forgot-password',
    '/t1/onboarding', '/t2/onboarding',
    '/t1/health-goals',
    '/t1/verify-phone',
    '/t2/verify-phone',
  };

  final isPublic = publicRoutes.contains(loc);

  final activeTheme = ref.read(activeThemeProvider);
  final isT2 = activeTheme == ActiveTheme.t2Dark ||
               activeTheme == ActiveTheme.t2Light ||
               activeTheme == ActiveTheme.t2Amoled;

  if (authState is AuthLoading) {
    if (isPublic) return null;
    return loc.contains('splash') ? null : (isT2 ? '/t2/splash' : '/t1/splash');
  }
  if (authState is AuthUnauthenticated) {
    if (loc.contains('splash')) {
      return isT2 ? '/t2/login' : '/t1/login';
    }
    return isPublic ? null : (isT2 ? '/t2/login' : '/t1/login');
  }
  if (authState is AuthProfileMissing) {
    return (loc == AppRoutes.t2ProfileRetry) ? null : AppRoutes.t2ProfileRetry;
  }
  if (authState is AuthNeedsOnboarding) {
    if (isT2) {
      return (loc == AppRoutes.t2Onboarding) ? null : AppRoutes.t2Onboarding;
    }
    // Allow both onboarding and health-goals for T1 to prevent loop
    if (loc == AppRoutes.t1Onboarding || loc == AppRoutes.t1HealthGoals) return null;
    return AppRoutes.t1HealthGoals;
  }
  if (authState is AuthAuthenticated) {
    if (isPublic) {
      return isT2 ? '/t2/dashboard' : '/t1/dashboard';
    }
    return null;
  }
  if (authState is AuthFailure) {
    if (isPublic) return null;
    return loc.contains('splash') ? null : (isT2 ? '/t2/splash' : '/t1/splash');
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
