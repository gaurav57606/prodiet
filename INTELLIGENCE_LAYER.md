# ProDiet Unified — Intelligence Layer Specifications

This document defines the core processing specifications of the offline OCR spelling correction engine, habit trackers, and GDPR/CCPA security sandboxing protocols inside ProDiet Unified.

---

## 1. Offline OCR Spelling Correction Specifications

Typo detection and spelling corrections are evaluated completely offline inside `OcrLearningSystem` using Levenshtein distance calculations:

$$\text{Levenshtein}(s, t) = \text{minimum operations required to transform } s \text{ to } t$$

- **Maximum typo error tolerance**: 2 edit distances (insertions, deletions, substitutions). Any error distance higher than 2 will fail back to the raw scanned text to avoid false positives.
- **Dynamic Preprocessing Boost**: If the historical scan failure rate exceeds 25%, the engine suggests adaptive image booster parameters (Contrast Boost 1.5, grayscale overrides) to improve subsequent image binarizations.

---

## 2. Dynamic Habit & Anomaly Classification

The `AnalyticsIntelligence` engine monitors macrologs to stream active insights:

- **Sodium Surge anomaly**: Triggered when daily sodium levels exceed $2300 \text{ mg}$.
- **Sugar Surge anomaly**: Triggered when daily sugar logs exceed $50 \text{ g}$.
- **Breakfast Skipper habit**: Triggered if breakfast is delayed past 11:00 AM on more than 50% of logged days.
- **Late Snacking trend**: Triggered if snacks are logged past 10:00 PM on multiple days.

---

## 3. GDPR & CCPA Compliance Sandboxing

ProDiet Unified operates on strict **local sandboxing security principles**:
1. All learned spellings, macro scores, and timing habits are persisted **exclusively in sandboxed application memory**.
2. Opt-out controls dynamically disable specific intelligence modules.
3. Wiping preference controls trigger **deep erasures**:
   - `executeFullErasure()` completely zeroes out all in-memory learned spelling maps, empties the recommendation engine's caches, and resets all privacy switches to false.
