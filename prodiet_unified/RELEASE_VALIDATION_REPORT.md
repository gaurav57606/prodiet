# RELEASE_VALIDATION_REPORT — Obfuscation, iOS Target & Symbol Security

This report validates the compiler optimizations, symbol obfuscation boundaries, and release-mode stability criteria for ProDiet Unified.

---

## 1. Obfuscation & Minification Safety (R8/Proguard)

To protect intellectual property while ensuring the application does not crash in release mode due to over-aggressive code shrinking, we maintain strict **R8 / Proguard Rule Sets**:

```
+-----------------------------------------------------------------+
|                        Compiler Obfuscation                     |
+-----------------------------------------------------------------+
          |
          +---> [ Code Shrinking & Obfuscation Enabled ]
          |     - Wipes unused class strings
          |     - Tree-shakes dead build modules
          |
          +---> [ Critical Symbol Preservation Guards ]
                - Keep Riverpod Notifier & State classes intact
                - Keep Drift Database Entity/DAO bindings intact
                - Prevent dynamic serialization mapping crashes
```

### Critical Keep Assertions:
1.  **Riverpod State Serialization**:
    *   *Risk*: Aggressive obfuscation renaming can strip state field names, breaking dynamic local configurations or parsing logic.
    *   *Guard*: Custom keep rules preserve the serialization metadata boundaries on domain models.
2.  **Drift Local Database DAOs**:
    *   *Risk*: R8 code shrinking can remove necessary database reflective elements used by SQLite during launches.
    *   *Guard*: Standard SQLite/Drift proguard keep structures ensure all relational query classes are safely excluded from R8 removal.

---

## 2. iOS Release Compatibility

iOS release builds compile native binaries targetting modern architecture baselines:

*   **Target Architectures**: Optimized strictly for `ARM64` pipelines to ensure high-performance execution on iPhones and iPads.
*   **CocoaPods Environment Isolation**: All native plugins (such as keychain security libraries) are audited to guarantee they run within sandboxed environments without requiring root privileges.
*   **Bitcode Configuration**: Configured to match the latest App Store requirements, ensuring compilation stability and deployment security.

---

## 3. Release Crash Safety & Observability

To catch production-level exceptions while retaining user privacy:

1.  **Crash Safety Wrapper**: Active loops are wrapped in comprehensive try-catch captures to prevent model-layer exceptions from triggering hard application exits.
2.  **Symbolic Upload Pipelines**:
    During release builds, debug symbols are captured and archived:
    ```bash
    # Android debug symbol path
    build/app/outputs/symbols
    # iOS debug symbol path
    build/ios/outputs/symbols
    ```
    Uploading these files to the release console maps obfuscated runtime crash stacks back to readable Dart files and line numbers (`app_dialog.dart:L45`).
3.  **Encrypted Logging**: Debug print lines are fully stripped from release binaries, ensuring no API tokens, user emails, or database keys are ever exposed in system logs.
