# STORE_COMPLIANCE_REPORT — Permissions, Privacy & Disclosures

This report validates the app-store compliance declarations and privacy posture of ProDiet Unified for Google Play and the Apple App Store.

---

## 1. Hardware Permissions & Store Rationale

ProDiet Unified requests hardware boundaries only when necessary to perform functional tasks. Below are the registered rationale statements displayed to users:

```
                  +--------------------------------+
                  |  Hardware Permission Rationale |
                  +---------------+----------------+
                                  |
         +------------------------+------------------------+
         |                                                 |
         v                                                 v
+--------+-----------------------+              +----------+----------------------+
| Camera & Photo Library         |              | Audio & Microphone Access       |
| - Purpose: OCR Ingredient Scans|              | - Purpose: Voice Meal Logging   |
| - Disclosure: Local parsing;   |              | - Disclosure: Only listening    |
|   Immediate physical deletion |              |   during active recording tap   |
+-------------------------------+              +---------------------------------+
```

### A. Camera & Photo Library Access
*   **Rationale Statement (iOS Info.plist)**: `"ProDiet Unified requires access to the camera to scan nutritional labels and extract ingredients using offline OCR image recognition."`
*   **Compliance Compliance**: Scanned images are processed locally and discarded from disk immediately in `finally` execution blocks. No photo files are exported to external tracking databases.

### B. Microphone & Audio Recording
*   **Rationale Statement (iOS Info.plist)**: `"ProDiet Unified requires access to your microphone to transcribe and parse ingredients through voice-activation commands."`
*   **Compliance Compliance**: Listening operates strictly during active recording button presses. Audio chunks are converted locally and never recorded or stored continuously.

### C. Notification Services
*   **Rationale Statement**: Used for daily hydration and meal log reminders. Completely opt-in.

---

## 2. GDPR/CCPA Privacy & Local Data Safeguards

To comply with international privacy regulations (GDPR / CCPA):

*   **Offline-First Local SQLite Sandbox**:
    *   All customer data (meals, hydration events, physical metrics) is persisted inside the sandboxed local Drift SQLite database.
    *   This database uses standard device container sandboxing, preventing other installed applications from reading physical files.
*   **Supabase Data Transit Security**:
    *   Synchronization variables and payload data pass over secure TLS/HTTPS channels directly to our dedicated database end-point.
    *   User authentications reside securely in hardware-backed Secure Enclave keychains.

---

## 3. Storage Containment & Cache Policies

To justify local storage requirements to reviewers:
*   **Purpose**: Persistent databases ensure that clients can log food, calculate calorie targets, and parse OCR images while completely disconnected from cellular data.
*   **Cache Management**: The application does not store large static file caches or dynamic video files, maintaining the app storage footprint under a highly optimized **20MB** limit.
