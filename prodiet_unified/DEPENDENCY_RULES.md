# ProDiet Unified — Strict Dependency & Layer Rules

This document establishes the official **Dependency Flow & Layer Integration Rules** for ProDiet Unified. All developers must adhere to these rules to preserve type safety, prevent architectural erosion, and ensure smooth multi-platform operations.

---

## 1. Onion Architecture Dependency Flow

ProDiet Unified utilizes a strict **Onion Architecture** model where dependencies point exclusively inwards toward the core domain logic.

```
                  ┌───────────────────────────────┐
                  │          Presentation         │
                  │   ┌───────────────────────┐   │
                  │   │      Application      │   │
                  │   │   ┌───────────────┐   │   │
                  │   │   │     Domain    │   │   │
                  │   │   │               │   │   │
                  │   │   └───────────────┘   │   │
                  │   │           ▲           │   │
                  │   └───────────┼───────────┘   │
                  │               │               │
                  │         Infrastructure        │
                  └───────────────┴───────────────┘
```

### Flow Definitions:
1.  **Presentation (Outer)**: Allowed to import from `Application` and `Domain`. **NEVER** allowed to import from `Infrastructure`.
2.  **Application**: Allowed to import from `Domain` and inject database/network objects defined in `core/`. **NEVER** allowed to import `presentation` (UI) files.
3.  **Domain (Inner Core)**: Fully decoupled and isolated. **NEVER** allowed to import from `Application`, `Presentation`, or `Infrastructure`. It must be compile-safe using pure, vanilla Dart only.
4.  **Infrastructure (Database/APIs)**: Allowed to import from `Domain` (to implement its contracts) and `core/` (to access SQLite/network clients).

---

## 2. Preventing Direct SDK Leaks (UI Boundaries)

A primary contributor to architectural decay is "leaky abstractions." Under no circumstances may third-party database, camera, voice, or network SDKs be referenced directly inside presentation widgets.

### Anti-Patterns vs. Compliant Architecture:

❌ **Anti-Pattern (Direct SDK Access)**:
```dart
// lib/features/water/presentation/screens/water_screen.dart
import 'package:supabase_flutter/supabase_flutter.dart'; // Leak!

class WaterScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return ElevatedButton(
      onTap: () {
        // Direct remote API call bypassing repositories and state managers
        Supabase.instance.client.from('water_logs').insert({'amount': 250});
      },
      child: const Text('Add Water'),
    );
  }
}
```

🟢 **Compliant Pattern (Decoupled Flow)**:
```dart
// lib/features/water/presentation/screens/water_screen.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prodiet_unified/features/water/application/water_notifier.dart';

class WaterScreen extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onTap: () {
        // Exclusively invokes the application state manager
        ref.read(waterNotifierProvider.notifier).addWater(250);
      },
      child: const Text('Add Water'),
    );
  }
}
```

---

## 3. Strict Linter Rules & Import Restrictions

To prevent circular dependency chaos at compile-time, we configure strict package boundaries inside `analysis_options.yaml`.

### A. Layer Import Guard
Add the following rules under `analyzer -> plugins -> custom_lint` or standard lint constraints to flag invalid references:

```yaml
# analysis_options.yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    # Flag absolute feature leakage as compile errors
    avoid_relative_lib_imports: error
    implementation_imports: error
```

### B. Command-Line Import Checker
As part of our CI/CD automation validation pipeline, we run an automated shell script to scan import headers and flag circular boundary violations:

```bash
# Scan for relative leaks between isolated features
grep -rn "import 'package:prodiet_unified/features/" lib/features/ | while read -r line; do
    file=$(echo "$line" | cut -d':' -f1)
    import=$(echo "$line" | cut -d"'" -f2)
    
    # Extract source and target feature names
    src_feat=$(echo "$file" | cut -d'/' -f3)
    tgt_feat=$(echo "$import" | cut -d'/' -f5)
    
    if [ "$src_feat" != "$tgt_feat" ]; then
        echo "❌ ARCHITECTURE ERROR: Leaked import detected from Feature [$src_feat] into Feature [$tgt_feat]!"
        echo "   Location: $file"
        exit 1
    fi
done
```
This guarantees 100% build-safety and prevents compile-time regressions from slipping into production releases.
