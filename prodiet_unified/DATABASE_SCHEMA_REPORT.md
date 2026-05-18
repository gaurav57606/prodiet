# DATABASE SCHEMA REPORT

## Table: `users`
| Column | Type | Constraints |
| :--- | :--- | :--- |
| `id` | uuid | PK, FK auth.users |
| `email` | text | Unique, Not Null |
| `full_name` | text | - |
| `avatar_url` | text | - |
| `daily_water_goal_ml` | integer | Default 2000 |
| `daily_calorie_goal` | integer | Default 2500 |
| `created_at` | timestamp | Server Default |
| `updated_at` | timestamp | Trigger |

## Table: `meals`
| Column | Type | Constraints |
| :--- | :--- | :--- |
| `id` | uuid | PK, Default v4 |
| `user_id` | uuid | FK users.id, Not Null |
| `name` | text | Not Null |
| `meal_type` | text | Enum check |
| `calories` | float8 | - |
| `protein_g` | float8 | - |
| `carbs_g` | float8 | - |
| `fat_g` | float8 | - |
| `ingredients` | jsonb | Default [] |
| `status` | text | Enum check |
| `planned_date` | date | Not Null, Index |

## Table: `water_logs`
| Column | Type | Constraints |
| :--- | :--- | :--- |
| `id` | uuid | PK, Default v4 |
| `user_id` | uuid | FK users.id, Not Null |
| `amount_ml` | integer | Not Null |
| `date` | date | Not Null, Index |
| `logged_at` | timestamp | - |

## Table: `user_devices`
| Column | Type | Constraints |
| :--- | :--- | :--- |
| `id` | uuid | PK |
| `user_id` | uuid | FK users.id |
| `device_id` | text | Unique per User |
| `fcm_token` | text | - |
| `platform` | text | Enum check |
| `app_version` | text | - |
| `last_seen` | timestamp | Not Null |
