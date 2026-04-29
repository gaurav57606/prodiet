# ProDiet Unified - Expert Software Architect Audit Report

**Date:** 2026-04-29  
**Status:** Pre-Launch Review  
**Auditor:** Expert Software Architect (AI)

---

## 1. Executive Summary
The ProDiet Unified application is a sophisticated, feature-rich Flutter application utilizing a modern tech stack (Supabase, Riverpod, GoRouter, Firebase). The architecture is generally sound, following a feature-first layered approach. However, there are critical flaws in deployment configuration, accessibility, and testing that **MUST** be addressed before an App Store/Play Store launch.

---

## 2. Architectural Audit

### 2.1 Pattern Consistency
- **Strengths:** 
    - Consistent use of `Riverpod` for state management.
    - Excellent use of `AsyncValueWidget` to handle loading/error/data states uniformly.
    - Functional error handling using `dartz` and a centralized `ErrorHandler`.
- **Flaws:**
    - **Logic in UI:** Some screens (e.g., `OcrScannerScreen`) contain business logic (e.g., mapping and saving items) that should reside in a `Notifier` or `Service`.
    - **Brittle Auth Logic:** `AuthNotifier` uses `Future.delayed` to wait for database triggers. This is a "race condition" waiting to happen. A more robust approach would be to ensure profile creation during the signup transaction or handle missing profiles via a dedicated "Profile Initialization" state.

### 2.2 Dual-Theme System (T1 & T2)
- **Observations:** The app maintains two entirely different visual identities within the same codebase. While technically impressive, it introduces significant maintenance overhead.
- **Risk:** Every new feature requires dual UI implementation. If not managed strictly, the two themes will diverge in functionality.
- **Recommendation:** Use a unified UI component library where "Themes" only change tokens (colors, spacing, typography) rather than entire widget structures, unless the divergence is a core business requirement.

---

## 3. Backend & Services Audit

### 3.1 Supabase Integration
- **Real-time:** Good use of Supabase Streams for live updates.
- **Security:** Row Level Security (RLS) is mentioned but should be audited per table.
- **Flaw:** `MealRepository` contains "legacy column" hacks (`planned_date` vs `date`). The schema should be unified to prevent bugs.

### 3.2 Firebase (FCM & Crashlytics)
- **FCM:** Correctly initialized. However, the `fcmServiceProvider` instantiates `NotificationService` manually instead of watching a provider, which can lead to initialization issues or missed updates.
- **Crashlytics:** Correctly integrated in `main.dart` with `runZonedGuarded`.

---

## 4. App Store Launch Readiness (Critical)

### 4.1 Android Configuration
- **[CRITICAL] Release Signing:** `android/app/build.gradle.kts` is currently configured to use `debug` signing for release builds. This will be rejected by the Play Store. A proper upload key and `signingConfig` are required.
- **Min SDK:** 21 is acceptable, but 23/24 is recommended for modern health apps to ensure compatibility with latest APIs.
- **Version Management:** Currently hardcoded at 1.0.0. Needs a CI/CD process for auto-incrementing.

### 4.2 Accessibility
- **[CRITICAL] Text Scaling:** `app.dart` explicitly disables text scaling (`TextScaler.noScaling`). 
    - **Justification provided in code:** "Preserves pixel-perfect layout."
    - **Reality:** This is a **major accessibility violation**. Users with visual impairments who rely on system-wide large text will find the app unusable. This could lead to App Store rejection or poor ratings.
    - **Better Approach:** Design layouts to be responsive to text scaling using `Flexible`, `Expanded`, and `ListView`.

### 4.3 Testing
- **[CRITICAL] Coverage:** The `test/` directory is virtually empty.
    - **Requirement:** A production app requires at least 60-70% coverage for core logic (repositories, notifiers, models).
    - **Missing:** Unit tests for `AuthNotifier`, `MealRepository`, and `OcrScanner`. Integration tests for the main user flow.

---

## 5. UI/UX Audit

### 5.1 Navigation
- **Inconsistency:** The app mixes `Navigator.pop()` with `GoRouter`'s `context.push()`.
- **Bug Potential:** Redirection logic in `app_router.dart` defaults to `/t1/dashboard` for authenticated users even if they were using T2. This breaks the "Theme Awareness" of the router.

### 5.2 User Flows
- **OCR Flow:** Well-designed with a "Thinking" loader.
- **Dashboard:** Rich and informative, but hardcoded "Good morning" logic in the View should be in a ViewModel/Notifier for testability.

---

## 6. Detailed File-Level Flaws

| File | Issue | Severity | Fix/Approach |
| :--- | :--- | :--- | :--- |
| `app.dart` | `TextScaler.noScaling` | **High** | Remove and fix UI overflow issues. |
| `main.dart` | Hardcoded initialization sequence | Medium | Wrap in a dedicated `InitializationService`. |
| `app_router.dart` | Auth redirect lacks T2 awareness | Medium | Check `activeTheme` in auth redirect logic. |
| `build.gradle.kts` | Debug signing for release | **High** | Create keystore and update signing configs. |
| `auth_notifier.dart` | `Future.delayed(1s)` | Medium | Implement robust profile check/creation. |
| `ocr_scanner_screen.dart`| Logic in `onPressed` | Low | Move to `OcrNotifier`. |
| `fcm_service.dart` | Manual instantiation of services | Low | Use Riverpod dependency injection properly. |
| `preferences_screen.dart` | Hardcoded mockup (no logic) | **Medium** | Connect to `PreferencesNotifier` and sync with DB. |
| N/A | Missing Legal/Privacy Screens | **High** | Required for App Store/Play Store compliance. |

---

## 7. Recommendations for Better Approach

1.  **Strict Linting:** Replace `flutter_lints` with `very_good_analysis` to enforce higher code quality.
2.  **Environment Security:** Ensure `.env` is **never** checked into Git. Use a CI/CD vault (GitHub Secrets) for production builds.
3.  **Dependency Management:** Add `device_info_plus` and `package_info_plus` to replace hardcoded strings in analytics.
4.  **Error Feedback:** Implement a global "Snack Bar Service" or "Dialog Service" to handle `AuthFailure` states consistently across all screens.
5.  **Offline-First Strategy:** While `drift` is in `pubspec.yaml`, its usage is sparse in the repositories I audited. Ensure all critical data (diet plans, meal logs) is synced to local DB for offline usage.

---

## 8. Final Verdict
The app is **75% ready** for launch. It looks premium and performs well, but the **Keystore/Signing**, **Accessibility (Text Scaling)**, and **Testing** issues are "show-stoppers" that must be resolved to ensure a professional and successful App Store debut.
