class AppRoutes {
  AppRoutes._();

  // ─── AUTH ROUTES ───────────────────────────────────────────────────────────
  
  static const String authSplash = '/auth/splash';
  static const String authOnboarding = '/auth/onboarding';
  static const String authLogin = '/auth/login';
  static const String authSignup = '/auth/signup';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authHealthGoals = '/auth/health-goals';
  static const String authVerifyPhone = '/auth/verify-phone';
  static const String authVerifyEmail = '/auth/verify-email';
  static const String authPrivacyPolicy = '/auth/privacy-policy';
  static const String authTerms = '/auth/terms';
  static const String authProfileRetry = '/auth/profile-retry';

  // ─── UNIFIED FEATURE ROUTES ────────────────────────────────────────────────
  
  static const String dashboard = '/dashboard';
  static const String todayMeals = '/today-meals';
  static const String dietPlan = '/diet-plan';
  static const String mealPlanner = '/meal-planner';
  static const String inventory = '/inventory';
  static const String progress = '/progress';
  static const String nutrition = '/nutrition';
  static const String shopping = '/shopping';
  static const String dietPlanDetail = '/diet-plan/detail';
  
  static const String hydration = '/hydration';
  static const String activitySync = '/activity-sync';
  static const String ocr = '/ocr';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String recipe = '/recipe';
  static const String preferences = '/preferences';
  static const String achievements = '/achievements';
  
  static const String voice = '/voice';
  static const String compensation = '/compensation';
  static const String vendor = '/vendor';

  // ─── LEGACY ALIASES (For T1/T2 compatibility during transition) ───────────
  
  static const String t1Splash = authSplash;
  static const String t1Dashboard = dashboard;
  static const String t1TodayMeals = todayMeals;
  static const String t1DietPlan = dietPlan;
  static const String t1MealPlanner = mealPlanner;
  static const String t1Inventory = inventory;
  static const String t1Progress = progress;
  static const String t1Nutrition = nutrition;
  static const String t1Shopping = shopping;
  static const String t1DietPlanDetail = dietPlanDetail;
  static const String t1Hydration = hydration;
  static const String t1ActivitySync = activitySync;
  static const String t1Ocr = ocr;
  static const String t1Profile = profile;
  static const String t1Notifications = notifications;
  static const String t1Recipe = recipe;
  static const String t1Preferences = preferences;
  static const String t1Achievements = achievements;

  static const String t2Splash = authSplash;
  static const String t2Dashboard = dashboard;
  static const String t2Meals = mealPlanner;
  static const String t2DietPlan = dietPlan;
  static const String t2Inventory = inventory;
  static const String t2Voice = voice;
  static const String t2DietPlanDetail = dietPlanDetail;
  static const String t2Water = hydration;
  static const String t2Ocr = ocr;
  static const String t2Recipe = recipe;
  static const String t2Compensation = compensation;
  static const String t2Vendor = vendor;
  static const String t2Fitband = activitySync;
  static const String t2Preferences = preferences;

  // Legacy Auth Aliases
  static const String t1Login = authLogin;
  static const String t1Signup = authSignup;
  static const String t1Onboarding = authOnboarding;
  static const String t1ForgotPassword = authForgotPassword;
  static const String t1VerifyPhone = authVerifyPhone;
  static const String t1VerifyEmail = authVerifyEmail;
  static const String t1HealthGoals = authHealthGoals;
  static const String t1PrivacyPolicy = authPrivacyPolicy;
  static const String t2PrivacyPolicy = authPrivacyPolicy;
  static const String t1Terms = authTerms;
  static const String t2TermsOfService = authTerms;
}
