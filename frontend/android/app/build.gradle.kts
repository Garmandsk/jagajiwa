plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load file key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.frontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            // LOGIKA HYBRID (Versi Kotlin):

            // 1. Setup storeFile
            val keyStoreFileName = keystoreProperties.getProperty("storeFile")
            if (keyStoreFileName != null) {
                storeFile = file(keyStoreFileName)
            } else {
                // Fallback untuk GitHub Actions (jika key.properties tidak ada/kosong)
                storeFile = file("upload-keystore.jks")
            }

            // 2. Setup Password & Alias (Prioritas: File -> Env Var)
            storePassword = keystoreProperties.getProperty("storePassword")
                ?: System.getenv("ANDROID_STORE_PASSWORD")

            keyAlias = keystoreProperties.getProperty("keyAlias")
                ?: System.getenv("ANDROID_KEY_ALIAS")

            keyPassword = keystoreProperties.getProperty("keyPassword")
                ?: System.getenv("ANDROID_KEY_PASSWORD")
        }
    }


    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.frontend"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            // Pasang signingConfig yang kita buat di atas
            signingConfig = signingConfigs.getByName("release")

            // Syntax Kotlin beda dengan Groovy (pakai 'is' atau '=')
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
