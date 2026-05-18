# ProDiet Unified — Personalization Strategy & Metrics

This strategy document defines the user profiling formulas, timing distributions, and behavior calibration algorithms embedded within `UserProfileEngine`.

---

## 1. User Intelligence Profile Properties

Every local client sandboxed profile captures multiple metrics over a rolling evaluation history:
- **Macro Variance**: Standard deviation of logged protein, fat, and carbohydrates compared to objectives.
- **Timing Distribution**: Normal distribution modeling of breakfast, lunch, and dinner logged times to detect lifestyle delays.
- **Goal Adherence**: Total successful macro matching streaks.
- **Food Frequency Register**: Maps counts of logged food catalog entities to personalize grocery replenishment priority.

---

## 2. Behavioral Score Calculation

The master User Behavior Score represents macro adherence stability over historical logs:

$$\text{Behavior Score} = \left( 1.0 - \frac{\text{Macro Variances Sum}}{\text{Log Count}} \right) \text{ clamped to } [0.0, 1.0]$$

- **High Score (>0.85)**: Reflects highly consistent logging patterns.
- **Low Score (<0.50)**: Senses highly volatile logging schedules, automatically scaling down streak weights and boosting macro guidance triggers.

---

## 3. Dynamic Weight Alignments

Behavioral scoring adjusts suggestion weights across three critical vectors:

| User Behavior State | Nutrition Weight | Variety Weight | Streak Weight |
|:---|:---|:---|:---|
| **Highly Consistent (>0.85)** | Balanced (1.0) | Standard (1.0) | Amplified (1.2) |
| **Highly Volatile (<0.50)** | Amplified (1.4) | Standard (1.0) | Suppressed (0.6) |
