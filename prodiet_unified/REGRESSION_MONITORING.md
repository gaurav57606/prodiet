# REGRESSION_MONITORING — Automated Performance Testing & Alerting

This document outlines the **Automated Regression Detection System** designed to safeguard the performance of ProDiet Unified against code changes, dependency updates, and feature expansions.

---

## 1. Automated Performance Profiling Framework

To prevent performance degradation, the application implements specialized profiling rules:

```
[ Active Code Commit / Pull Request ]
  |
  v
[ Automated CI Pipeline / Local Profiler ]
  |
  +---> 1. Run Flutter Driver Performance Tests
  |     - Scroll tests over long inventory sheets
  |     - Rebuild counter assertions via Riverpod debug wrappers
  |
  +---> 2. Memory Analyzer Run
  |     - Heap leak detection checks
  |
  v
[ Threshold Gate Check ]
  |
  +---> Passed? -> Merge Allowed
  +---> Failed? -> Trigger Build Failure + Alerts
```

### Automated Profile Targets:
*   **Rebuild Auditing**: Ensures that changing a single element (e.g., ticking a water cup) does not trigger full-screen invalidations. We track this by wrapping high-frequency screens in clean consumer builders that isolate rebuild scopes.
*   **Scrolling Performance Driver**: Simulates programmatic scroll offsets on lists, tracking `frame_build_rate` and flagging frames exceeding **16ms** as regressions.

---

## 2. Regression Alerting & Threshold Gates

Performance gates are established to automatically flag performance regressions during verification:

| Metric Vector | Baseline Benchmark | Regression Threshold | Severity / Action |
| :--- | :--- | :--- | :--- |
| **Cold Start Duration** | `795ms` | **> 1200ms** | 🔴 **Blocking** (Fail build immediately) |
| **Dashboard Frame Build** | `1.8ms` | **> 6.0ms** | 🟡 **Warning** (Flag in telemetry logs) |
| **Scroll Frame Build (99th %)** | `6.8ms` | **> 12.0ms** | 🔴 **Blocking** (Fail rendering tests) |
| **Idle Heap Footprint** | `50MB` | **> 80MB** | 🟡 **Warning** (Trigger memory leak audit) |
| **OCR Local Processing** | `290ms` | **> 500ms** | 🟡 **Warning** (Optimize image compression) |

---

## 3. Continuous Regression Prevention Best Practices

To sustain our performance metrics as new features are added:

1.  **Enforce riverpod `.autoDispose`**: Never keep UI-bound streams active globally; ensure resources are returned to the OS.
2.  **Use `const` Constructors**: Consistently apply `const` keywords to widget instances. This enables Flutter's compiler to cache UI layouts, completely eliminating rebuilds of static view components.
3.  **Perform Lazy ListView Initializations**: Avoid loading complete collections into the render tree; always utilize `ListView.builder` for infinite or high-scale UI collections.
