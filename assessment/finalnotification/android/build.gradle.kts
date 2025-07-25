// Top-level build.gradle.kts

plugins {
    // Declare the versions of plugins available for sub-modules to use.
    // Use 'apply false' here, as these plugins will be applied in individual module build.gradle.kts files.
    id("com.android.application") version "8.7.3" apply false
    id("com.android.library") version "8.7.3" apply false // <-- CHANGED to apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    id("com.google.gms.google-services") version "4.4.3" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // This part seems a bit unusual for a standard setup.
    // Setting buildDirectory for subprojects relative to a parent of rootProject's buildDirectory
    // might indicate a custom build output structure.
    // For standard projects, the build directory for subprojects is usually within their own module.
    // If you're encountering issues related to build output paths, this might be a secondary area to check.
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // 'project.evaluationDependsOn(":app")' can also cause issues if not used carefully,
    // especially for clean builds or when dependencies aren't clear.
    // It forces the current subproject to be evaluated AFTER the ':app' project.
    // Only keep this if you absolutely understand its implications and it's necessary for your specific setup.
    // Otherwise, consider removing it.
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    // This task will delete the custom 'build' directory you've set up.
    delete(rootProject.layout.buildDirectory)
}