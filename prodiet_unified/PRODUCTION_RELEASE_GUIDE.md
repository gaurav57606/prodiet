# PRODUCTION_RELEASE_GUIDE — Build Automation & Signing Configurations

This guide documents the **Production Build Pipelines** and release-gating automation established for ProDiet Unified.

---

## 1. Automated Release Gating & Verification

Before executing production compilations, the built-in [release_validator.dart](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/tool/release_validator.dart) automation script must be executed to guarantee environment sanity:

```bash
# Execute local environment validation
dart run tool/release_validator.dart
```

### Validator Actions & Assertions:
1.  **JSON Syntax Verification**: Confirms `.env.json` contains well-formatted JSON with zero structural anomalies.
2.  **Secret and Key Checklist**: Scans for essential environment properties (`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `GEMINI_API_KEY`, `OPEN_FOOD_FACTS_BASE_URL`).
3.  **Asset Directory Inspection**: Validates that all physical directories registered inside `pubspec.yaml` (e.g. typography assets, animations, icons) exist on physical disk to prevent runtime file-not-found exceptions.
4.  **Gradle Configuration Scan**: Detects Android dimensions and custom release configurations.

---

## 2. Step-by-Step App Store Compilation Pipelines

### A. Android Deployment (AAB Generation)
1.  Ensure signing credentials are loaded into `/android/key.properties` (secured outside version control).
2.  Compile the production-hardened **Android App Bundle (AAB)** with full code obfuscation:
    ```bash
    flutter build appbundle --obfuscate --split-debug-info=build/app/outputs/symbols --release
    ```

### B. iOS Deployment (IPA Generation)
1.  Verify development team, certificates, and app identifiers are correctly configured in Xcode.
2.  Compile the release archive and generate the App Store distribution IPA:
    ```bash
    flutter build ipa --obfuscate --split-debug-info=build/ios/outputs/symbols --release
    ```

---

## 3. Environment Separation & Signing Integrity

To guarantee that staging variables or developer credentials never bleed into customer releases:

*   **Keystore Security**: `/android/key.properties` dynamically loads:
    *   `storeFile`: Path to the encrypted physical Keystore.
    *   `storePassword` / `keyPassword`: Highly secure administrative hashes (never stored in version control; injected via secure CI/CD environment secrets).
*   **iOS Provisioning**: CocoaPods and Xcode build target schemes separate the App Store production profiles, restricting test flight builds to isolated sandboxes.
*   **Separation Check**: `tool/release_validator.dart` blocks deployment if placeholder strings or staging API credentials exist within the dynamic `.env.json` configuration.
