# PROVIDER_INIT_AUDIT.md - Riverpod Provider Initialization Audit

## 1. Executive Summary
We performed a comprehensive codebase audit to detect and mitigate any risk of uninitialized singleton access across all Riverpod providers in the ProDiet Unified project. Special attention was given to components reading `Supabase.instance`, `FirebaseApp`, `SharedPreferences`, and database models.

## 2. Audited Providers & Findings

| Provider Name | File Location | Status | Action Taken / Verification |
| :--- | :--- | :--- | :--- |
| `bootstrapStateProvider` | `lib/app/bootstrap_screen.dart` | **SECURE** | Introduced to act as the centralized startup state machine. |
| `supabaseServiceProvider` | `lib/core/services/supabase_service.dart` | **SECURE** | Refactored to act as a secure dependency wrapper. |
| `supabaseClientProvider` | `lib/core/services/supabase_service.dart` | **SECURE** | Created to expose the client directly via Riverpod DI. |
| `authRepositoryProvider` | `lib/features/auth/application/auth_providers.dart` | **SECURE** | Uses `ref.watch(supabaseServiceProvider)`. |
| `authProvider` | `lib/features/auth/application/auth_providers.dart` | **SECURE** | Safe downstream evaluation inside state notifier. |
| `dashboardRepositoryProvider` | `lib/features/dashboard/application/dashboard_providers.dart` | **SECURE** | Uses `ref.watch(supabaseServiceProvider)`. |
| `notificationsProvider` | `lib/features/dashboard/application/notification_providers.dart` | **SECURE** | Refactored from direct `Supabase.instance` lookup to `ref.watch(supabaseClientProvider)`. |
| `streakAchievementProvider` | `lib/features/achievements/application/achievement_providers.dart` | **SECURE** | Refactored from direct `Supabase.instance` lookup to `ref.watch(supabaseClientProvider)`. |
| `achievementRepositoryProvider` | `lib/features/achievements/application/achievement_providers.dart` | **SECURE** | Refactored from direct `Supabase.instance` lookup to `ref.watch(supabaseClientProvider)`. |

## 3. Best Practices & Architecture Standards
To prevent future regression into startup races:
1. **Never use static singletons directly inside providers**: Always wrap external SDK clients (Supabase, Firebase, SharedPreferences) in a Riverpod `Provider` or expose them via dedicated dependency providers.
2. **Strict pre-boot initialization driven by State-Machine**: Any asynchronous service that requires configuration *must* complete execution in the bootstrap phase before downstream router redirects or authentication flows start.
3. **No eager warmup in providers**: Use `WidgetsBinding.instance.addPostFrameCallback` in stateful widgets or UI entrypoints to trigger synchronization, analytics tracking, and listener registrations rather than running them eagerly during provider build phases.
