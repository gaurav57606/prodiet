# FAILURE_RECOVERY_REPORT — FIFO Queue Hardening & Sync Conflict Resolution

This report outlines the **Fault-Tolerant Sync Engine** and automated recovery patterns designed to manage offline states and backend recovery inside ProDiet Unified.

---

## 1. FIFO Outbox Serialization & Queue Integrity

To guarantee that offline operations execute in the exact order they were performed by the user, the sync outbox operates under a strict **FIFO (First-In, First-Out) Serialization Protocol**:

```
[ User Operations Logged Offline ]
  |
  +---> Meal Log (Create)   [ID: 101] ---> Queue Task 1
  |
  +---> Meal Log (Update)   [ID: 101] ---> Queue Task 2
  |
  +---> Meal Log (Delete)   [ID: 101] ---> Queue Task 3
  |
  v
[ Outbox Processing Pipeline ]
  |
  +---> Task 1 Processes (Success) -> Remove from outbox
  |
  +---> Task 2 Encounters Socket Error (Failure)
  |     |
  |     v
  |   [ FIFO HARDENING TRIGGERED ]
  |   - Stop processing batch immediately
  |   - Prevent Task 3 (Delete) from executing out of sequence
  |   - Await exponential backoff retry for Task 2
```

### Outbox Safety Safeguards:
*   **Chronological Lock**: If any task encounters a failure (e.g. timeout, Supabase drop), the queue processor immediately halts the remaining batch. This prevents a "Delete" or "Update" transaction from executing before the corresponding "Insert" is registered, preserving relational sanity.
*   **Persistent Outbox State**: Outbox tasks reside in the highly resilient local `LocalSyncQueue` table, meaning that even if the app process is terminated mid-sync, the transaction queue recovers instantly upon launch.

---

## 2. Exponential Backoff & Dead Letter Queue (DLQ)

Dynamic errors (e.g. Supabase rate limits or temporary offline conditions) receive an intelligent retry structure managed by our `RetryPolicy`:

| Attempt # | Calculated Backoff Delay | System Status | Path |
| :--- | :--- | :--- | :--- |
| **Attempt 1** | `15 seconds` | Background retryscheduled | Active Queue |
| **Attempt 2** | `60 seconds` | Background retryscheduled | Active Queue |
| **Attempt 3** | `4 minutes` | Background retryscheduled | Active Queue |
| **Attempt 4** | `15 minutes` | Background retryscheduled | Active Queue |
| **Attempt 5** | `—` | Max Retries Reached | **Dead Letter Queue (DLQ)** |

### Dead Letter Queue (DLQ) Safeguard:
Once a task exhausts 4 backoff retries, the `SyncManager` flags it as a `DEAD_LETTER` task. This moves the item out of the active sync loop to prevent queue blockages, while retaining the raw payload locally for administrative debugging or support logs.

---

## 3. Timestamp-Based Conflict Resolution

When local updates conflict with concurrent server-side modifications, ProDiet Unified enforces a high-scale conflict broker:

```dart
// lib/core/sync/sync_manager.dart
final resolved = _conflictResolver.resolve(
  localData: data,
  remoteData: remoteRow,
  localUpdatedAt: localTime,
  remoteUpdatedAt: remoteTime,
  strategy: ConflictStrategy.clientWins,
);
```

### Conflict Strategies:
1.  **Client Wins (Default)**: If the local `client_updated_at` timestamp is newer than the server's timestamp, the local record upserts and overwrites the remote.
2.  **Server Wins**: If the server has a newer modification, the remote payload is projected back to the local database, and the outbox task is safely cleared without overwriting server-side history.
3.  **Field-Level Merging**: Resolves updates to different non-overlapping fields safely without losing user history.
