# ProDiet Unified — Design QA Report & Audit

This document presents a comprehensive, high-fidelity design audit of the **ProDiet Unified** user interface codebase. It evaluates token discipline, typography rhythms, component consistency, motion mechanics, and theme-switching adaptability across the target feature screens (`lib/features/`).

---

## 1. Executive Summary & Design Debt Score

| Metric | Rating | Unresolved Debt | Target Architecture |
| :--- | :--- | :--- | :--- |
| **Token Discipline** | 🟠 Needs Improvement | ~40 hardcoded color/spacing overrides | 100% token resolution via `context.tokens` |
| **Component Reuse** | 🟢 Good | Isolated screen-level custom card shapes | Standardization under `AppCard` & `AppButton` |
| **Motion Consistency** | 🟡 Moderate | Embedded ad-hoc `Duration` & `Curve` definitions | Unified motion triggers from `tokens.motion` |
| **Theme Adaptability (T1 vs. T2)** | 🟢 High | Excellent structural switches, minor color bleed | Automatic semantic theme color mapping |

---

## 2. Token Discipline & Style Drift Audit

Our audit reveals that while the foundation of the design system (`lib/core/design_system/tokens/`) is exceptionally strong, several presentation layers inside `lib/features/` suffer from visual drift due to hardcoded layout values.

### A. Spacing & Margin Drift (Layout Grids)
*   **High-Traffic Screens**: Direct usages of `EdgeInsets.all(16)`, `EdgeInsets.symmetric(horizontal: 24)`, and hardcoded `SizedBox(height: 16)` or `32` bypass the standard grid boundaries (`tokens.spacing.xs` through `tokens.spacing.xxl`).
*   **Impact**: Visual misalignment on smaller device screens and breaking of responsive column structures on Web/Desktop.

### B. Border Radius & Container Shapes
*   **High-Traffic Screens**: High volume of `BorderRadius.circular(12)`, `BorderRadius.circular(20)`, and `BorderRadius.circular(24)` instances.
*   **Impact**: T1 uses a highly rounded, standard-radius theme, whereas T2 is designed to use curved layout panels with distinct radii (`tokens.radius.sm`, `tokens.radius.md`, `tokens.radius.lg`). Hardcoded values prevent the cards from adapting when users change themes.

### C. Color Overrides & Raw Hex Values
*   **Preferences Screen**: Hardcoded constants:
    *   `Color(0xFFB8FF00)` (Lime)
    *   `Color(0xFFB06EFF)` (Purple)
    *   `Color(0xFFFF5C3A)` (Orange)
    *   `Colors.redAccent` (CCPA Erasure buttons)
*   **Hydration Screen**: Raw color definitions:
    *   `Color(0xFF00CED1)` (Teal accent for T1)
    *   `Color(0xFF00E5FF)` (Teal accent for T2)
*   **Impact**: When switching to Amoled dark mode or custom theme variants, these hardcoded colors remain statically high-contrast, breaking accessibility guidelines and design harmony.

---

## 3. Screen-by-Screen QA Findings

### 1. Water Tracking (`water_screen.dart` & `adaptive_water_widgets.dart`)
*   **Styling Drift**:
    *   Lines 39: `final accentColor = isT2 ? const Color(0xFF00E5FF) : const Color(0xFF00CED1);` (Raw colors instead of `tokens.colors.water` or semantic token map).
    *   Line 43: `AppBar` background color hardcoded to `Colors.transparent` with `elevation: 0`.
    *   Line 78: Padding `EdgeInsets.fromLTRB(24, 24, 24, 0)` is hardcoded.
    *   Line 236: `BorderRadius.circular(10)` hardcoded for water glass tracking boxes.
    *   Line 264: `BorderRadius.circular(20)` hardcoded for custom entry container shape.
*   **Unresolved UI Debt**: Under T2, the color `0xFF00E5FF` does not have standard contrast ratio verification against high-surface elements.

### 2. Recipe Inspector (`recipe_screen.dart` & `adaptive_recipe_widgets.dart`)
*   **Styling Drift**:
    *   Line 158-164: `FilledButton.icon` style uses `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))` which ignores `tokens.radius.button`.
    *   Line 236: `color: isSelected ? const Color(0xFFFF5C3A) : null` on the allergen chips override standard chip styling logic.
*   **Typography Rhythms**: Direct invocation of Google Fonts within UI body styles rather than querying the typography map (`tokens.typography`).

### 3. Smart Preferences (`preferences_screen.dart` & `adaptive_preference_widgets.dart`)
*   **Styling Drift**:
    *   Multiple choice chip containers map color directly using local conditional definitions.
    *   Erasure alert items style secondary colors using raw `Colors.redAccent` and `const Divider(height: 1, thickness: 1)`.
*   **Layout Spacing**: Padding value inside `_buildContainer` uses static margins `EdgeInsets.all(24)`.

### 4. AI & OCR Loader (`ai_thinking_loader.dart`)
*   **Styling Drift**:
    *   Ad-hoc micro-animation transitions use a literal `Duration(milliseconds: 500)` rather than accessing `tokens.motion.normal` or `tokens.motion.slow`.
    *   ProgressBar maps border radius hardcoded to `BorderRadius.circular(8)` rather than token constraints.

---

## 4. Proposed Refactoring Plan (Enterprise Hardening)

To transform this system into a pristine, premium enterprise-grade infrastructure, we will implement the following structured fixes:

```
┌────────────────────────────────────────────────────────┐
│                   Theme Token System                   │
│  (app_colors, app_spacing, app_radius, app_motion...)  │
└───────────┬────────────────────────────────┬───────────┘
            │                                │
            ▼                                ▼
┌────────────────────────┐      ┌────────────────────────┐
│  Standard Components   │      │    Adaptive Screens    │
│  - AppButton, AppCard  │      │  - Water, Recipes      │
│  - AppDialog, AppChip  │      │  - Preferences, Loader │
└────────────────────────┘      └────────────────────────┘
```

1.  **Harden Spacing Tokens**: Convert all layout margins/padding to read `tokens.spacing.sm`, `tokens.spacing.md`, `tokens.spacing.lg`.
2.  **Harden Radius Tokens**: Substitute all `BorderRadius.circular` calls with `BorderRadius.circular(tokens.radius.sm)` or equivalent theme values.
3.  **Map Semantic & Custom Colors**:
    *   All water-related accents must bind to `tokens.colors.water`.
    *   All high-alert states must bind to `tokens.colors.waterDanger` or `tokens.colors.error`.
    *   Specific choice chips should bind to `tokens.colors.primary` or semantic variations to preserve theme-switches cleanly.
4.  **Harden Motion Systems**:
    *   Refactor `AiThinkingLoader` to read transitions and curves from `tokens.motion.normal` and `tokens.motion.emphasized`.
5.  **Validate Integration**:
    *   Perform a dry-run widget validation.
    *   Execute 200+ unit/integration tests (`flutter test`) to ensure zero layout-breaking logic was introduced.
