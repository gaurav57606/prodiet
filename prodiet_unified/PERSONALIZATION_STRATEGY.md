# ProDiet Unified - Personalization Strategy & Habit Engine

ProDiet Unified personalizes user experiences based on passive learning profiles rather than intrusive telemetry tracking.

---

## 1. User Intelligence Profile Parameters

The engine tracks a rich, multi-dimensional timeline baseline to understand exactly how the user interacts with their dietary goals:

```dart
class UserIntelligenceProfile {
  final List<String> dietaryPreferences;
  final Map<String, List<double>> mealTimingHabits; // e.g. {'breakfast': [8.0, 8.5]}
  final Map<String, double> macroVariances;         // e.g. {'protein': 12.5}
  final int ocrTotalScans;
  final int ocrCorrectionCount;
  final Map<String, int> foodFrequency;             // food -> counts
  final int currentStreak;
  final int longestStreak;
  final List<bool> lastFortnightLogs;
}
```

---

## 2. Behavior Scoring Formulas

*   **Consistency Index**: Ratio of days logged within the last rolling fortnight.
    $$\text{Consistency} = \frac{\text{Logged Days}}{14}$$
*   **Goal Adherence Index**: Derived from the mean percentage variance across all tracked macronutrients.
    $$\text{Adherence} = \left(1.0 - \frac{\text{Average Variance}}{100.0}\right)\text{.clamp}(0, 1)$$
*   **Variety Index**: Ratio of unique food items logged vs total food items logged.
    $$\text{Variety} = \frac{\text{Unique Foods}}{\text{Total Items}}$$
*   **Timing Consistency**: Evaluates the standard deviation of decimal hours for eating breakfast, lunch, and dinner. Variances above 3 hours dramatically reduce this index.
*   **OCR Success Index**: Calculates the scanner's autonomy.
    $$\text{OCR Success} = 1.0 - \frac{\text{User Spelling Corrections}}{\text{Total OCR Scans}}$$

---

## 3. Levenshtein Typo Self-Correction

To improve OCR accuracy without an active internet connection, the `OcrLearningSystem` listens to manual spelling edits and populates a local typo mapping dictionary.
When a new scan occurs, it fuzzy-matches the raw text against known typos using **Levenshtein Distance**:

$$\text{Levenshtein}(a, b)$$

If the edit distance is $\le 2$, the corrected string is returned automatically. This eliminates repetitive manual typos and works completely offline.
