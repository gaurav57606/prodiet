# Suppress R8/ProGuard unresolved reference warnings
-dontwarn sun.misc.Unsafe
-dontwarn java.util.Map
-dontwarn com.google.gson.annotations.SerializedName
-dontwarn com.google.gson.TypeAdapterFactory
-dontwarn com.google.gson.JsonSerializer
-dontwarn com.google.gson.JsonDeserializer
-dontwarn drift.GeneratedDatabase
-dontwarn kotlinx.serialization.Serializable

# ── Flutter / General ───────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# ── Supabase ────────────────────────────────────────────────────────────
-keep class io.supabase.** { *; }
-keep class com.supabase.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ── Gson / JSON reflection ───────────────────────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# ── Drift (SQLite ORM) ───────────────────────────────────────────────────
-keep class app.cash.sqldelight.** { *; }
-keep class com.squareup.sqldelight.** { *; }
-keepclassmembers class * extends drift.GeneratedDatabase { *; }

# ── Firebase ────────────────────────────────────────────────────────────
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# ── OkHttp / Retrofit (used by Supabase internals) ──────────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ── Kotlin coroutines ────────────────────────────────────────────────────
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}
-dontwarn kotlinx.coroutines.**

# ── Kotlin serialization ─────────────────────────────────────────────────
-keepattributes RuntimeVisibleAnnotations
-keep class kotlinx.serialization.** { *; }
-keepclassmembers class * {
    @kotlinx.serialization.Serializable *;
}

# ── Bouncy Castle / SSL (used by Supabase TLS) ───────────────────────────
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# ── Riverpod / Dart reflection ───────────────────────────────────────────
-keep class **.BuildConfig { *; }

# ── App domain models (keep all fromJson/toJson) ─────────────────────────
-keep class com.prodiet.app.** { *; }
-keepclassmembers class ** {
    public static ** fromJson(java.util.Map);
    public ** toJson();
}
