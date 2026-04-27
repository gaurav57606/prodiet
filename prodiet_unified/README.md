# ProDiet Unified

Single Flutter project containing **all screens from theme1 and theme2**,
with a hard island boundary between them so changes to one theme can
never affect the other.

---

## Folder layout

```
lib/
├── main.dart
├── app.dart                        ← theme switcher entry point
├── core/
│   ├── router/app_router.dart      ← unified GoRouter
│   ├── screen_registry.dart        ← lock system
│   └── theme/
│       ├── active_theme_provider.dart
│       ├── t1/                     ← Theme1 island (Outfit font, purple)
│       │   ├── t1_colors.dart
│       │   ├── t1_spacing.dart
│       │   ├── t1_text_styles.dart
│       │   └── t1_theme.dart
│       └── t2/                     ← Theme2 island (BarlowCondensed+DmSans, lime)
│           ├── t2_colors.dart
│           ├── t2_spacing.dart
│           ├── t2_text_styles.dart
│           └── t2_theme.dart
├── features/
│   ├── auth/t1/                    ← Theme1 auth screens
│   ├── auth/t2/                    ← Theme2 auth screens
│   ├── dashboard/t1/
│   ├── dashboard/t2/
│   └── …
└── shared/
    ├── t1/widgets/                 ← Theme1 shared widgets
    └── t2/widgets/                 ← Theme2 shared widgets
        └── layout/
```

---

## Screen Lock System

1. Open `lib/core/screen_registry.dart`
2. Find the screen key (e.g. `'t1/dashboard'`)
3. Change `ScreenStatus.inProgress` → `ScreenStatus.locked`
4. Commit with prefix: `🔒 lock: t1/dashboard`
5. **Never edit that screen file again** without first
   changing it back to `inProgress` in a separate commit.

---

## Island Rules (never break these)

| Rule | Reason |
|---|---|
| t1 screens import only `t1_colors`, `t1_spacing`, `t1_text_styles` | Prevents color/font bleed |
| t2 screens import only `t2_colors`, `t2_spacing`, `t2_text_styles` | Prevents color/font bleed |
| `T1Spacing.radiusXl` ≠ `T2Spacing.radiusExtraLarge` | Different values — don't mix |
| `google_fonts` only used inside `t2_text_styles.dart` | Theme1 uses asset Outfit font |
| Never share widget files between t1/ and t2/ | Widget look differs per theme |

---

## Build prompts completed

- [x] Prompt 1 — Foundation (theme islands, pubspec, main, app, screen_registry)
- [ ] Prompt 2 — Shared widgets (t1 + t2)
- [ ] Prompt 3 — All t1 screens
- [ ] Prompt 4 — All t2 screens
- [ ] Prompt 5 — Unified router wiring
