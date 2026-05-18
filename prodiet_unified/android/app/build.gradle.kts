import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.prodiet.app"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.prodiet.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = 35
        // INCREMENT versionCode by 1 before EVERY distribution
        // Current: 1 → next should be 2, then 3, etc.
        // Must always be higher than the last APK sent to any user.
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    lint {
        checkReleaseBuilds = false
        abortOnError = false
    }

    signingConfigs {
        create("release") {
            val envKeystorePath = System.getenv("KEYSTORE_PATH")
            val envKeyAlias = System.getenv("KEY_ALIAS")
            val envKeyPassword = System.getenv("KEY_PASSWORD")
            val envStorePassword = System.getenv("STORE_PASSWORD")

            if (envKeystorePath != null && envKeyAlias != null && envKeyPassword != null && envStorePassword != null) {
                storeFile = file(envKeystorePath)
                storePassword = envStorePassword
                keyAlias = envKeyAlias
                keyPassword = envKeyPassword
            } else {
                // Fallback to local.properties — never hardcode here
                val props = Properties()
                val localPropsFile = rootProject.file("local.properties")
                if (localPropsFile.exists()) {
                    localPropsFile.inputStream().use { props.load(it) }
                }
                
                val keystorePath = props.getProperty("KEYSTORE_PATH")
                if (keystorePath != null) {
                    storeFile = file(keystorePath)
                } else {
                    storeFile = signingConfigs.getByName("debug").storeFile
                }
                
                storePassword = props.getProperty("KEYSTORE_PASSWORD") ?: ""
                keyAlias     = props.getProperty("KEY_ALIAS") ?: ""
                keyPassword  = props.getProperty("KEY_PASSWORD") ?: ""
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled   = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Uses release keystore if env vars are defined, or local.properties has a valid storeFile
            val releaseConfig = signingConfigs.getByName("release")
            val hasEnvVars = System.getenv("KEYSTORE_PATH") != null &&
                             System.getenv("KEY_ALIAS") != null &&
                             System.getenv("KEY_PASSWORD") != null &&
                             System.getenv("STORE_PASSWORD") != null
                             
            signingConfig = if (hasEnvVars || (releaseConfig.storeFile != null && releaseConfig.storeFile!!.exists()))
                releaseConfig
            else
                signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
