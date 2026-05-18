# ProDiet Unified — Recommendation Engine Specification

This specification document outlines the inner mathematical and filtering mechanics of the `RecommendationEngine` and the `NutritionIntelligenceLayer` inside ProDiet Unified.

---

## 1. Recommendation Formulas & Scoring Weights

Recommendation candidates are prioritized dynamically using scoring formulas weighted by the user's active profile habits:

$$\text{Final Score} = \text{Base Score} \times \text{Adaptive Behavioral Weight}$$

Where behavioral weights are sourced dynamically from the `UserProfileEngine`:
- **Nutrition Weight (`nutritionWeight`)**: Amplifies critical macronutrient balance prompts.
- **Variety Weight (`varietyWeight`)**: Boosts alternative meal swap suggestions to diversify the diet.
- **Streak Weight (`streakWeight`)**: Increases confidence scores of stable grocery restocking cards to lock in momentum.

---

## 2. Recommendation Flow & Filtration Layers

All generated suggestion candidates are passed through the strict `NutritionIntelligenceLayer` before being serialized or presented to the user:

```
[Raw Suggestion Candidates]
          │
          ▼
┌───────────────────────────────┐
│  Allergen Elimination Filter  │  <── Excludes items containing User Allergies
└───────────────────────────────┘
          │
          ▼
┌───────────────────────────────┐
│    Strict Diet Bounds Filter  │  <── Enforces Vegan/Vegetarian compliance
└───────────────────────────────┘
          │
          ▼
┌───────────────────────────────┐
│     In-Memory Cache Sync      │  <── Validates against 5-min caching thresholds
└───────────────────────────────┘
          │
          ▼
[Sorted Final Dashboard Cards]
```

---

## 3. Hydration Insight Mechanics

Hydration targets are calculated using daily baseline water deficiencies:
- Met: Return positive achievement card (`hyd_goal_met` - Score 1.0)
- Deficit: Calculates deficit proportions dynamically:

$$\text{Deficit Score} = \left( \frac{\text{Target Ml} - \text{Current Ml}}{\text{Target Ml}} \right) \text{ clamped to } [0.20, 0.95]$$
