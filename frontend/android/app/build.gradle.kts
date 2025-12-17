plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// load file key.properties
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
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
        release {
            storeFile = keystorePropertiesFile.exists() ? file(keystoreProperties['storeFile']) : null

            storePassword = keystoreProperties['storePassword'] ?: System.getenv("ANDROID_STORE_PASSWORD")
            keyAlias = keystoreProperties['keyAlias'] ?: System.getenv("ANDROID_KEY_ALIAS")
            keyPassword = keystoreProperties['keyPassword'] ?: System.getenv("ANDROID_KEY_PASSWORD")

            // Khusus storeFile untuk Env Var (GitHub Actions)
            // Di GitHub kita decode .jks ke path tertentu, misal 'upload-keystore.jks'
            if (storeFile == null) {
                storeFile = file("upload-keystore.jks")
            }
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
        release {
            signingConfig signingConfigs.release

                    minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source = "../.."
}
