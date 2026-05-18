# ANALYTICS TAXONOMY

Standardized naming convention for all ProDiet Unified events.

## Convention: `category_action_result`
*Note: Dots are converted to underscores for Firebase compatibility.*

## 1. Authentication
| Event | Trigger | Parameters |
| :--- | :--- | :--- |
| `auth_login_started` | User taps login button | - |
| `auth_login_success` | Successful session established | `method` (email, google, apple) |
| `auth_login_failed` | Auth error occurred | `error` |
| `auth_logout` | User manually logs out | - |

## 2. Meal & Nutrition
| Event | Trigger | Parameters |
| :--- | :--- | :--- |
| `meal_scan_started` | OCR camera opened | - |
| `meal_scan_success` | Data extracted from image | `calories` |
| `meal_scan_failed` | OCR engine error | `error` |
| `meal_logged` | Meal saved to database | `type` (breakfast, lunch, etc) |

## 3. Sync Engine
| Event | Trigger | Parameters |
| :--- | :--- | :--- |
| `sync_started` | Sync process initiated | - |
| `sync_success` | Queue cleared successfully | `count` |
| `sync_failed` | Connectivity or API failure | `error` |
| `sync_retry` | Task retrying after fail | `attempt` |

## 4. Navigation
| Event | Trigger | Parameters |
| :--- | :--- | :--- |
| `navigation_screen_view` | Screen enters view | `screen` |
| `dashboard_loaded` | Main dashboard fully rendered | - |
