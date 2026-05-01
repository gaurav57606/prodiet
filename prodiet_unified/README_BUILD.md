# ProDiet Build Instructions

## Environment Setup
All secrets are injected at build time via `--dart-define-from-file`.
DO NOT use `.env` files — they are not loaded at runtime.

### Required file: `.env.json` (gitignored — never commit)
Create `prodiet_unified/.env.json` with:
{
  "SUPABASE_URL": "your_supabase_project_url",
  "SUPABASE_ANON_KEY": "your_anon_key",
  "GEMINI_API_KEY": "your_gemini_key"
}

## Build Commands
| Target | Command |
|---|---|
| Debug APK | `./build.sh apk` |
| Release APK | `./build.sh apk --release` |
| App Bundle (Play) | `./build.sh appbundle --release` |
| iOS | `./build.sh ios --release` |

## Key Files
- `lib/core/config/app_config.dart` — reads env vars at compile time
- `build.sh` — wraps flutter build with --dart-define-from-file
