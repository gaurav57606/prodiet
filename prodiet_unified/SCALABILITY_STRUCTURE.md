# ProDiet Unified — Scalability & Provider Structure Protocol

This document establishes the official standards for **State Management (Riverpod) Organization**, **Async Operations**, and **Future Monorepo / Multi-Package Scaling**. Following these standards prevents global provider chaos and guarantees smooth compiling times as the engineering team expands.

---

## 1. Riverpod Provider Standards & Protocols

To maintain high performance and prevent global cascades, ProDiet Unified enforces a strict provider mapping architecture.

### A. Provider Naming Standards
Every provider must follow standard naming rules that indicate its exact layer and responsibility:

1.  **Repository Providers**: `[feature]RepositoryProvider`
    *   *Example*: `waterRepositoryProvider` (Infrastructure mapping)
2.  **Notifier State Providers**: `[feature]NotifierProvider`
    *   *Example*: `mealPlannerNotifierProvider` (Application mapping)
3.  **UI Data Stream Providers**: `[feature]SummaryProvider`
    *   *Example*: `calorieSummaryProvider` (State slice provider)

### B. Standard Notifier Structure
All state managers must utilize Riverpod `AsyncNotifier` (or `Notifier` for synchronous modules) to ensure native support for loading, error, and data states:

```dart
// lib/features/water/application/water_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/water/domain/entities/water_log.dart';

class WaterNotifier extends AutoDisposeAsyncNotifier<List<WaterLog>> {
  @override
  Future<List<WaterLog>> build() async {
    // Standard initialization; auto-managed resource loading
    return ref.read(waterRepositoryProvider).fetchTodayLogs();
  }

  Future<void> logWater(int amountMl) async {
    state = const AsyncLoading();
    try {
      final updatedList = await ref.read(waterRepositoryProvider).addLog(amountMl);
      state = AsyncData(updatedList);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}
```

### C. Preventing Global Provider Chaos
*   **Enforce Auto-Dispose**: Every feature-scoped state provider must use the `.autoDispose` modifier. This guarantees that when a user leaves the Hydration screen, the water logs and database streams are immediately cleaned from memory, preventing resource leaks.
*   **Aggressive Rebuild Selectors**: Global UI consumers must query specific segments of state rather than watching complete notifier trees. This prevents global layout rebuilds:
    ```dart
    // 🟢 COMPLIANT: Rebuilds ONLY when target volume changes
    final target = ref.watch(waterNotifierProvider.select((state) => state.value?.target ?? 2000));
    ```

---

## 2. Monorepo Multi-Package Extraction Plan (Melos Setup)

When ProDiet Unified scales beyond 15 vertical features, we recommend decomposing the unified folder structure into fully isolated Dart/Flutter packages managed via **Melos**.

```
prodiet_monorepo/
 ├── melos.yaml                  # Central monorepo manager configuration
 ├── apps/
 │    └── prodiet_app/           # Main Flutter Shell (depends on core & features)
 ├── core/
 │    ├── prodiet_core_network/  # Supabase clients & REST interfaces
 │    ├── prodiet_core_storage/  # Drift DB models & local SQLite migrators
 │    └── prodiet_core_design/   # Atoms, design system tokens, dynamic themes
 └── features/
      ├── prodiet_feature_auth/  # Fully isolated login & onboarding flow
      ├── prodiet_feature_meals/ # Fully isolated macro meals log planner
      └── prodiet_feature_ocr/   # Fully isolated TensorFlow camera scanner
```

### Monorepo Extraction Benefits:
1.  **Hardened Boundaries**: Features can only import libraries specified in their local `pubspec.yaml`, preventing direct feature cross-imports at the compiler level.
2.  **Targeted Pre-commit Validation**: CI/CD runs widget and integration tests exclusively for package segments that received changes in a given PR, shrinking merge queues from minutes to seconds.
3.  **Dynamic Package Releases**: Features can be published to internal package registries as independent libraries, allowing rapid updates without rebuilding the entire monolith.

---

## 3. High-Scale Compilation Budgets

To keep engineering feedback loops fast, ProDiet Unified enforces target budgets on incremental build sizes and compile times:

| Parameter | High-Performance Target | Failure Threshold | Action on Breach |
| :--- | :--- | :--- | :--- |
| **Incremental Rebuild** | `< 1200ms` | `> 2500ms` | Split large widget trees into specialized sub-widgets with `const` constructors. |
| **Riverpod Rebuild Cascade** | `Single widget node` | `App shell rebuild` | Inject `.select` state segments; break global providers into distinct atomics. |
| **Clean Compilation** | `< 45 seconds` | `> 90 seconds` | Decompose monolithic code; configure Melos parallel builder tasks. |
