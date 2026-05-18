# ProDiet Unified - Advanced Intelligence Layer Specification

This document details the concrete implementation of the OCR autocorrection, anomaly detectors, and background isolations within ProDiet Unified.

---

## 1. Local OCR Typo Learning System

The `OcrLearningSystem` listens to spelling adjustments on OCR food scanners and fuzzy-cleans scanned text completely offline:

*   **Fuzzy Cleaning Algorithm**: Uses normalized character edit distances.
*   **Case Insensitivity**: Auto-converts entries to uniform lookup keys while retaining original display strings.
*   **Performance Optimization**: Map lookups are $O(1)$. Levenshtein distances are computed on-demand over small dictionary lengths, keeping the execution times under **2 milliseconds**.

---

## 2. Behavioral Anomaly & Habit Classifiers

The `AnalyticsIntelligence` engine monitors logs sequentially to detect negative health vectors and dynamic lifestyle anomalies:

### Tracked Anomalies:
1.  **Sodium Level Spike**: Triggered if a meal surpasses $2300\text{ mg}$ of sodium or a daily log exceeds the RDA by $150\%$.
2.  **Saturated Fat Surge**: Triggered when saturated fat contributes over $15\%$ of total caloric intake in a 24-hour log.
3.  **High Processed Sugars Surge**: Triggered when refined carbohydrates contribute over $30\%$ of a meal's total macros.

### Behavioral Habit Inductions:
*   **Late Night Snacking**: Logged meals with hours $\ge 22.0$ (10:00 PM) or $\le 4.0$ (4:00 AM) that contribute $> 25\%$ of daily calories.
*   **Breakfast Skipper**: Regular instances where the first caloric log of the day occurs after $11.0$ (11:00 AM).
*   **Cheat Day Spiker**: Periodic calorie spikes ($> 150\%$ of target) occurring precisely every 7 days (usually on weekends).

---

## 3. GDPR & CCPA Physical Privacy Erasure Protocol

Privacy is a core feature of the ProDiet architecture. Under the control of the `PrivacyEthicsManager`, users can request complete data erasure:

```dart
final privacy = PrivacyEthicsManager(ocrSystem, recEngine);
privacy.setPersonalizationPreference(false);
```

### Erasure Pipeline Steps:
1.  **Typo Memory Clear**: Clears spelling maps within `OcrLearningSystem`.
2.  **Calorie & Swap Cache Eviction**: Purges active recommendations.
3.  **State Invalidation**: Notifies the Riverpod notifier hierarchy to reload to an anonymous baseline, ensuring no traces remain in RAM or persistent storage.
