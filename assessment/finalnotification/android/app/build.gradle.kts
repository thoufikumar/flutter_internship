// app/build.gradle.kts

plugins {
    id("com.android.application") // Apply the application plugin here
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services") // If your app uses Google Services
}

android {
    namespace = "com.your.package.name" // Replace with your actual package name
    compileSdk = 34 // Or your target SDK version

    defaultConfig {
        applicationId = "com.your.package.name" // Replace with your actual application ID
        minSdk = 24 // Or your minimum SDK version
        targetSdk = 34 // Or your target SDK version
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

dependencies {
    // Your app's dependencies go here
    implementation("androidx.core:core-ktx:1.13.1")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    // ... other dependencies
}