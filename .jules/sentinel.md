## 2024-05-21 - [Secure Error Sanitization in Flutter]
**Vulnerability:** Raw exception messages from backend services (Supabase) were displayed directly to the user, leaking internal implementation details (e.g., DB column names, file paths).
**Learning:** Defaulting to raw `error.toString()` in UI-visible error classes is a common source of information leakage. Even with some sanitization logic, a "catch-all" generic message is required to ensure defense-in-depth.
**Prevention:** Always implement a generic fallback message in error-to-string mapping logic for user-facing displays.
