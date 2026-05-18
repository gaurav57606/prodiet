# Rebuild Analysis Report

## Overview
This report analyzes the Flutter widget tree rebuild cycles on the core ProDiet Unified `DashboardScreen` before and after the performance engineering pass. Excessive rebuilds are a primary cause of high CPU utilization and battery drain in Flutter applications.

## Before Refactor
- **Architecture:** The `DashboardScreen` watched a monolithic `FutureProvider` (`dashboardProvider`). 
- **Behavior:** Whenever any specific metric changed (e.g., adding 250ml of water), the `dashboardProvider` invalidated and returned a new `DashboardSummary`. The `AsyncValueWidget` detected a new data instance, passing it to its builder.
- **Consequence:** This caused a complete rebuild of the `CustomScrollView` and all nested UI elements (`AdaptiveDashboardHeader`, `AdaptiveCalorieProgress`, `AdaptiveActivitySection`, etc.), even if their specific data domains were unchanged. This is known as a **Rebuild Storm**.

## After Refactor
- **Granular Consumers:** All child components (e.g., `AdaptiveMacroSection`, `AdaptiveHydrationCard`) were converted to `ConsumerWidget`s.
- **Scoped Subscriptions:** Instead of receiving a monolithic `data` object, these components now watch localized slices of the state using `ref.watch(dashboardProvider.select((v) => v.valueOrNull?.specificField))`.
- **Top-level Isolation:** The parent `DashboardScreen` now only watches for high-level state transitions (e.g., `isLoading`, `hasError`).
- **Repaint Boundaries:** Added `RepaintBoundary` wrappers around heavy graphics (like `MacroRingChart`) to ensure any micro-animations do not invalidate the layout of surrounding widgets.

## Verdict
The dashboard now successfully isolates state updates. Adding water will solely trigger a rebuild of the `AdaptiveHydrationCard` and its internal `WaterBanner`. The rest of the widget tree remains dormant, significantly reducing layout calculation overhead.
