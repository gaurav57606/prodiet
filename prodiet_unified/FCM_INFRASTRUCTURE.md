# FCM INFRASTRUCTURE

ProDiet Unified uses a multi-device device registry for reliable notification delivery and session management.

## 1. Device Registry (`user_devices`)
Stored in Supabase, this table tracks all active user installations.

| Field | Description |
| :--- | :--- |
| `user_id` | Foreign key to user account |
| `device_id` | Unique hardware ID (idForVendor or Android ID) |
| `fcm_token` | Firebase Cloud Messaging token |
| `platform` | android / ios |
| `app_version` | Current installed version |
| `last_seen` | Last time token was refreshed or app opened |
| `is_active` | Soft delete/invalidation flag |

## 2. Notification Lifecycle

### Permission Flow
- App requests permissions on first startup after login.
- "Provisional" notifications are disabled; we require explicit user intent for high-engagement features.

### Token Refresh
- Automatically handled via `FirebaseMessaging.onTokenRefresh`.
- Registry is updated without user interaction to prevent stale delivery targets.

### Foreground Handling
- Notifications received while app is open are converted to **local notifications**.
- Silent data updates are triggered via the `data` payload if required.

## 3. Operations
- **Cleanup**: Stale tokens (> 30 days) are automatically pruned by background maintenance tasks.
- **Multi-Device**: Notifications are broadcast to all `is_active` devices for the user.
