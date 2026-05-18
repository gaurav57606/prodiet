# ProDiet Unified — Production Pre-Flight Release Checklist

Use this checklist to verify the system before promoting a build to Apple TestFlight, Google Play Console, or public production.

---

## 1. Automated Environment Check
Before manual audits, run the automated validation suite in the workspace:

```bash
dart tool/release_validator.dart
```

Ensure all items pass with zero critical errors.

---

## 2. Technical Validation & Code Quality
- [ ] **No Analysis Warnings**: Run `flutter analyze` and ensure there are 0 warnings or errors in the repository.
- [ ] **Test Integrity**: Ensure all unit, widget, integration, sync, and OCR pipeline tests are passing cleanly:
  ```bash
  flutter test
  ```
- [ ] **Dependency Audit**: Review `pubspec.yaml` dependencies. Remove any unused developer or experimental dependencies.
- [ ] **Disable Development Diagnostics**: Ensure that debug overlays are completely disabled:
  - [ ] `showPerformanceOverlay: false` (MaterialApp)
  - [ ] `debugShowCheckedModeBanner: false` (MaterialApp)
  - [ ] Development logging logging level is restricted to `Level.WARNING` or higher.

---

## 3. Database Security & Infrastructure
- [ ] **Supabase RLS Hardening**:
  - [ ] Verify that Row Level Security (RLS) is enabled on all tables (`users`, `meals`, `water_logs`, `outbox`).
  - [ ] Confirm `SELECT`, `INSERT`, `UPDATE`, and `DELETE` policies restrict access exclusively to authenticated owners (`auth.uid() = user_id`).
- [ ] **Supabase Performance Optimization**:
  - [ ] Add composite indices on high-frequency queries (e.g., `user_id` + `logged_date`).
  - [ ] Test slow queries inside the Supabase SQL editor to verify query plans use indices.
- [ ] **Firebase Hardened Configs**:
  - [ ] Confirm `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) match production project credentials.
  - [ ] FCM push certificates are uploaded and not expiring soon.

---

## 4. UI/UX & Design Assets Consistency
- [ ] **Dynamic Theme Switching**: Run the app and verify both Theme 1 (Dark/Light) and Theme 2 (Dark/Light) load consistent gradients, custom Google fonts, and high-quality iconography.
- [ ] **On-Disk Asset Verification**:
  - [ ] Assets directories exist: `assets/images/`, `assets/icons/`, `assets/animations/`, `assets/fonts/`.
  - [ ] No hardcoded layout clip limits or absolute dimensions that cause clipping at 3.0x font scaling.
- [ ] **OCR Pipeline**: Verify scan and item selection transitions behave gracefully under varying internet connectivity speeds.

---

## 5. Deployment & Store Configuration
- [ ] **Version Bump**: Increment the version identifier inside `pubspec.yaml` matching standard SemVer rules:
  - Format: `version: [major].[minor].[patch]+[build_number]`
  - Increment the `+build_number` on every target push.
- [ ] **Release Keystore Setup**:
  - [ ] Keystore file `key.jks` exists in the local environment and has not been checked into Git.
  - [ ] Key details are loaded dynamically inside `android/key.properties`.
- [ ] **Changelog Documentation**:
  - [ ] Update `CHANGELOG.md` detailing the optimizations, offline-first sync engine implementation, observability pass, and testing framework integrations.
- [ ] **App Store Metadata**:
  - [ ] "What's New" release notes text is drafted and translated for all target languages.
  - [ ] Promotional screenshots are up to date.
- [ ] **Privacy Policies**: Confirm the standard user-visible privacy documentation is updated with information about OCR capture and local/cloud storage.
