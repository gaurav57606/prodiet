# AUTH_SECURITY_REPORT — Session Hardening & Cryptographic State Transitions

This document details the **Authentication Architecture**, state-machine lifecycle, and token transmission security protocols implemented across **ProDiet Unified**.

---

## 1. Stream-Based Authentication State Isolation

To prevent race conditions, profile injection, or stale session state transitions, ProDiet Unified enforces a robust, single-source-of-truth state machine managed within [AuthNotifier](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/features/auth/application/auth_notifier.dart).

```
                      +-----------------------------+
                      |         AuthLoading         |
                      +--------------+--------------+
                                     |
                          [ Read Session Stream ]
                                     |
                  +------------------+------------------+
                  |                                     |
         [ Session Active ]                    [ Session Null ]
                  |                                     |
                  v                                     v
      +-----------+-----------+             +-----------+-----------+
      |  Fetch Profile Data   |             |   AuthUnauthenticated |
      +-----------+-----------+             +-----------------------+
                  |
        +---------+---------+
        |                   |
 [ Complete = true ]  [ Complete = false ]
        |                   |
        v                   v
+-------+-----------+  +----+--------------+
| AuthAuthenticated |  | AuthNeedsOnboard  |
+-------------------+  +-------------------+
```

### State-Machine Integrity Principles:
1.  **Atomicity**: App states are strictly bound to an `AuthState` union class (`AuthLoading`, `AuthAuthenticated`, `AuthNeedsOnboarding`, `AuthUnauthenticated`, `AuthFailure`). Direct manual state injection is impossible.
2.  **Completer and Microtask Guards**: Application launch sequence queries the secure hardware keychain first and schedules profile fetches in a microtask. This delays UI building until the active security context is fully validated, eliminating flashing screens or race conditions.
3.  **Automatic Timeout Failovers**: Profile fetches are gated by a strict 5-second `TimeoutException` timer to prevent infinite loading screens on degraded or high-latency networks.

---

## 2. Supabase JWT Network Encryption (HTTPS-only)

All authentication communication and query traffic transit exclusively via secure TLS channels:
*   **Enforced HTTPS**: The endpoint `https://uhdmqjptvfokszascedv.supabase.co` guarantees that token exchanges utilize **TLS 1.2/1.3** exclusively.
*   **Encrypted Bearer Headers**: Supabase JWT tokens are dynamically compiled and passed within automated bearer authentication headers. Access tokens never append as query strings inside standard log outputs.

---

## 3. Session Purification & Deep Cleanup

Logging out must be an absolute operation that leaves zero traces of session access keys behind on the physical hardware:
1.  **Cryptographic Session Purging**: Calling `signOut()` triggers Supabase key removal inside [SecureSupabaseStorage](file:///c:/Users/PC/Desktop/fa/allthemeui/prodiet_unified/lib/core/security/secure_supabase_storage.dart) via `removePersistedSession()`, erasing key indices immediately.
2.  **Subscription Cancellation**: Subscription streams are actively garbage-collected to prevent memory leaks or posthumous state updates:
    ```dart
    _authSubscription?.cancel();
    ```
3.  **Active Telemetry Deregistration**: FCM credentials are flagged as inactive on the remote database to prevent target push messaging leakages to a logged-out device:
    ```dart
    await _fcm?.signOut(userId);
    ```
