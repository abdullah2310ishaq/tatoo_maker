plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

import java.util.Properties

android {
    namespace = "com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val signingPropertiesFile = rootProject.file("key.properties")
    val signingProperties = Properties()
    val hasSigningProperties = signingPropertiesFile.exists()

    if (hasSigningProperties) {
        signingProperties.load(signingPropertiesFile.inputStream())
    }

    signingConfigs {
        if (hasSigningProperties) {
            create("release") {
                keyAlias = signingProperties.getProperty("keyAlias")
                keyPassword = signingProperties.getProperty("keyPassword")
                storeFile = file(signingProperties.getProperty("storeFile"))
                storePassword = signingProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        getByName("debug") {
            // Keep default debug behavior.
            // Uses the standard Android debug keystore.
        }

        getByName("release") {
            // If `android/key.properties` exists, use it for release signing.
            // Otherwise, fall back to debug signing (dummy) so local release builds still work.
            signingConfig = if (hasSigningProperties) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            isDebuggable = false
            isMinifyEnabled = false
            isShrinkResources = false

            // Standard ProGuard / R8 configuration for release builds.
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("com.google.android.material:material:1.12.0")
}
