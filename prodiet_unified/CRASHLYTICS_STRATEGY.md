# CRASHLYTICS STRATEGY

Structured error reporting for rapid production bug resolution.

## 1. Severity Mapping
Logs are mapped to Crashlytics severity levels based on their impact:

| Level | Severity | Crashlytics Action |
| :--- | :--- | :--- |
| SHOUT | Critical | Fatal Crash + Alert |
| SEVERE | High | Non-fatal Error + Stack Trace |
| WARNING | Medium | Log Breadcrumb |
| INFO | Low | Log Breadcrumb |

## 2. Custom Keys
Every report automatically includes the following contextual metadata:

- `severity`: Human-readable impact level.
- `logger_name`: Feature area where the error occurred (e.g., `ProDiet.Sync`).
- `connectivity`: Network status at time of error.
- `user_id`: Link to user session for history tracing.

## 3. Global Error Handling
Implemented `PlatformDispatcher.instance.onError` to capture:
- Async exceptions that escape standard try/catch blocks.
- Widget building errors.
- Method channel initialization failures.

## 4. Feature Tagging
Errors in critical paths (OCR, Sync, Auth) include custom breadcrumbs marking the exact stage of failure (e.g., `sync_queue_db_read`, `ocr_image_upload`).
