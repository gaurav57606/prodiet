class AppRoutes {
  AppRoutes._();

  // ─── T1 ROUTES ─────────────────────────────────────────────────────────────
  
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

  // T1 Shell (Authenticated)
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

  // ─── T2 ROUTES ─────────────────────────────────────────────────────────────

  // T2 Standalone
  static const String t2Splash = '/t2/splash';
  static const String t2Onboarding = '/t2/onboarding';
  static const String t2Login = '/t2/login';
  static const String t2Signup = '/t2/signup';
  static const String t2ForgotPassword = '/t2/forgot-password';
  static const String t2VerifyPhone = '/t2/verify-phone';

  // T2 Shell (Authenticated)
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
  static const String t2ProfileRetry = '/t2/profile-retry';

  // ─── ALIASES (Compatibility) ──────────────────────────────────────────────
  
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
}
