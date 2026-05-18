# PERFORMANCE_BASELINES — Execution Budgets & Metric Targets

This document establishes the **Official Performance Baselines** and acceptable runtime thresholds designed to keep ProDiet Unified running smoothly.

---

## 1. UI Rendering & Frame Build Budgets

To ensure zero visual stutter ("jank") during transitions, scrolling, or heavy calculation, we enforce strict rendering frame ceilings:

```
+-----------------------------------------------------------------+
|                       UI Rendering Budgets                      |
+-----------------------------------------------------------------+
          |
          +---> [ 60fps Target ] (Standard screens)
          |     - Max Frame Build: 16.6ms
          |     - Max Frame Raster: 16.6ms
          |
          +---> [ 120fps Target ] (High-refresh modern devices)
                - Max Frame Build: 8.3ms
                - Max Frame Raster: 8.3ms
```

### Rendering Metric Thresholds:
*   **Frame Build Time**: Time spent by the CPU assembling the widget tree.
    *   *Baseline Target*: **< 8.0ms** (Safe for both 60Hz and 120Hz).
    *   *Jank Warning Trigger*: **> 16.0ms**.
*   **Frame Raster Time**: Time spent by the GPU drawing the layers.
    *   *Baseline Target*: **< 10.0ms**.
    *   *Jank Warning Trigger*: **> 16.6ms**.

---

## 2. Startup Thresholds

Application launch speeds dictate first impressions. We benchmark and enforce two launch configurations:

| Startup Profile | Execution Scope | Acceptable Ceiling | Target Target |
| :--- | :--- | :--- | :--- |
| **Cold Start** | Complete boot from process initialisation, through native Splash Screen load, up to first interactive session render. | **< 1.5 seconds** | **900ms** |
| **Warm Start** | App resumes from OS background suspend directly into the active dashboard view. | **< 400ms** | **250ms** |

---

## 3. Memory Allocation Baselines

Memory consumption must be strictly capped to prevent system-level process terminations (OOM kills):

*   **Baseline Memory Footprint (Idle)**: **< 60MB** (App initialized, sitting on the active Dashboard).
*   **Active Database Query Footprint**: **< 80MB** (Performing lookups or sorting large lists).
*   **OCR Image Processing Peak (Limit)**: **< 150MB** (Capturing, downscaling, and parsing photo inputs).
*   **Long-Session 24hr Target Cap**: **< 100MB** (Continuous foreground/background cycles).

---

## 4. Asynchronous Sync Execution Budgets

Data synchronization is managed as a secondary, silent background task to protect main thread responsiveness:

*   **Outbox Sweep Initiation**: Triggered within **500ms** of local state changes.
*   **Single Batch Sync Run**: **< 3.0 seconds** (Over standard 3G/4G network latency, for up to 10 serialized outbox tasks).
*   **Main Thread Block duration**: **0.0ms** (All network and sync operations reside entirely on asynchronous background tasks).
