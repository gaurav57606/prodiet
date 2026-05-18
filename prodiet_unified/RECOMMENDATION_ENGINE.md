# ProDiet Unified - Recommendation Engine Spec & Decision Matrices

The `RecommendationEngine` is responsible for generating personalized dietary, physical, hydration, and meal-swap recommendations.

---

## 1. Adaptive Weight Adjustment

Recommendations are scored dynamically based on the user's `UserBehaviorScore`. The system adjusts the importance of nutritional density versus diet variety based on the user's recent logging consistency:

| User Behavior Profile | Consistency / Adherence Score | Nutrition Weight | Variety Weight | Timing Match Weight | Streak Weight |
|:---|:---:|:---:|:---:|:---:|:---:|
| **Low Consistency / High Variance** | `< 0.5` | **0.65** (Safety Net) | 0.10 | 0.15 | 0.10 |
| **High Consistency / Low Variance** | `≥ 0.5` | 0.35 | **0.35** (Explore) | 0.15 | 0.15 |

---

## 2. Core Scoring Heuristics

### A. Calorie Deficit Recommendation
Triggered if the user has a significant target deficit remaining:
$$\text{Score} = \min\left(0.95, \frac{\text{Remaining Calories}}{2000.0} + 0.3\right)$$
Suggestions focus on macro-dense, healthy replenishment foods.

### B. Dynamic Diet Swaps
Matches user food items against predefined high-density or low-processed counterparts:
*   `egg_fried` $\rightarrow$ Suggests **Poached Eggs** or **Egg White Scramble** (lower fat, high density).
*   `white_bread` $\rightarrow$ Suggests **Sourdough Whole Wheat** or **Oat bread**.
*   `processed_sugars` $\rightarrow$ Suggests **Greek Yogurt with Fresh Berries** or **Dark Chocolate (85%)**.

### C. Pantry Replenishment
Learns user logging frequencies from their history and alerts them to restock staple ingredients when they are likely running low based on their food frequency counts.

### D. Hydration Reminders
If logged water intake is far below the target (e.g. `< 1500ml` remaining of a `3000ml` goal), a standard or high-urgency water reminder prompt is generated:
```dart
final prompts = engine.generateHydrationPrompts(loggedMl, targetMl);
```

---

## 3. Sandboxed Off-Thread Processing

The scoring routines are executed in async environments, allowing complex sorting, allergy exclusions (e.g., Peanuts, Dairy, Gluten), and dynamic weighting matrices to complete instantly without blocking the visual layer.
