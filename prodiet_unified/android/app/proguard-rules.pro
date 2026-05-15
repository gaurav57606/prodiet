# ProDiet Unified ProGuard Rules

# 1. Flutter standard rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# 2. Firebase & GMS
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# 3. Drift (SQLite) - Prevent model/table obfuscation
-keep class * extends com.drift.DriftDatabase { *; }
-keep class * extends com.drift.Table { *; }
-keep class * implements com.drift.DataClass { *; }

# 4. Supabase & JSON Models
# Keep all domain models from the app to ensure JSON serialization works
-keep class com.prodiet.app.features.**.domain.** { *; }
-keep class com.prodiet.app.core.data.local.** { *; }

# 5. Jackson/Moshi/Gson (if used via dependencies)
-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn sun.misc.Unsafe
