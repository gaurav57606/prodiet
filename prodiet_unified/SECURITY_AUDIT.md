# SECURITY_AUDIT — ProDiet Unified Secret & Logging Architecture

This document establishes the official security architecture for **Secrets Management**, **Environment Isolation**, and **Telemetric Debug Audits** in ProDiet Unified. It serves as our security reference for production deployments.

---

## 1. Secrets Management & Zero-Hardcode Mandate

ProDiet Unified operates under a strict **Zero-Hardcode Security Policy**. No API keys, credentials, backend endpoints, or cloud configuration secrets are permitted within the version-controlled codebase.

### A. Environment Configuration Pipeline
All system secrets are housed exclusively inside external configuration files and injected at launch time:
*   **Local Execution**: Loaded dynamically from `[project_root]/.env.json` (which is git-ignored via `.gitignore` to prevent repository leaks).
*   **Template Config**: A template [env.example.json](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/.env.example.json) is provided to establish configuration patterns for onboarding engineers.
*   **Compile-Time Verification**:
    ```json
    {
      "SUPABASE_URL": "https://uhdmqjptvfokszascedv.supabase.co",
      "SUPABASE_ANON_KEY": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "GEMINI_API_KEY": "YOUR_GEMINI_API_KEY",
      "OPEN_FOOD_FACTS_BASE_URL": "https://world.openfoodfacts.org/api/v2"
    }
    ```

### B. CI/CD Variable Injections
For production pipeline builds, the build variables are injected dynamically through encrypted environment vectors:
1.  **GitHub Actions / GitLab CI**: Environment secrets are stored in secure credentials vaults (e.g., GitHub Secrets).
2.  **Flutter Build Argumentation**: Injected during compilation using `--dart-define` or dynamic file generation of `.env.json` at build time.

---

## 2. Centralized Observability & Privacy Logging Firewall

Standard console logging (`print` or raw `debugPrint`) risks leaking database results, session values, or proprietary system pathways to device syslogs. ProDiet Unified solves this using a centralized **Logging Firewall** inside [AppLogger](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/core/observability/logger/app_logger.dart).

```
                      +-----------------------------+
                      |       System Event Log      |
                      +--------------+--------------+
                                     |
                                     v
                       +-------------+-------------+
                       |    AppLogger Core Rules   |
                       +-------------+-------------+
                                     |
                    +----------------+----------------+
                    |                                 |
             [ kDebugMode ]                   [ Release Mode ]
                    |                                 |
                    v                                 v
        +-----------+-----------+        +------------+------------+
        |  Local Console Output |        | Firebase Crashlytics Log|
        |  (Raw Strings Active) |        | (Sanitized Tags Only)   |
        +-----------------------+        +-------------------------+
```

### Logging Isolation Rules:
1.  **Environment-Based Routing**: In `kDebugMode`, logs are routed to developer console outputs. In release builds, log printing is **completely disabled**.
2.  **Pristine Production Logs**: Only `SEVERE` or `SHOUT` level system failures trigger remote telemetry (Firebase Crashlytics).
3.  **Sanitization Safeguards**: Remote logs strictly strip user passwords, database identifiers, and local filenames, utilizing high-level component tag names (such as `[Sync]`, `[OCR]`) to guarantee zero customer context leaks.

---

## 3. Deployment Security & Build Verifications

To prevent local vulnerability propagation, all binary releases must undergo build-time sanity checks:
*   **Proactive Release Validator**: The compilation routine employs a release checker [release_validator.dart](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/tool/release_validator.dart) to analyze imports and configs prior to generating Google Play/iOS App Store release archives.
*   **Dependency Auditing**: Regular vulnerability sweeps are conducted using `flutter pub pub` security analyzers to lock down supply-chain paths.
