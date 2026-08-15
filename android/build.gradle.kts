allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
            configure<com.android.build.gradle.LibraryExtension> {
                compileSdk = 35
                if (namespace == null) {
                    namespace = if (project.name == "isar_flutter_libs") {
                        "dev.isar.isar_flutter_libs"
                    } else {
                        "dev.isar.${project.name.replace("-", ".")}"
                    }
                }
            }
        }
    }
    plugins.withId("com.android.application") {
        configure<com.android.build.gradle.AppExtension> {
            if (namespace == null) {
                namespace = "dev.isar.${project.name.replace("-", ".")}"
            }
        }
    }
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
