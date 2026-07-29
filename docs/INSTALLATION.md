# Installation & Build Guide

This document provides step-by-step instructions for building, testing, and installing Vitafolio.

---

## 1. System Requirements

- **Flutter SDK**: 3.11.0 or higher
- **Dart SDK**: 3.x
- **Android Studio / VS Code**: Latest version with Flutter plugins installed
- **Android SDK**: API level 21 (Android 5.0) or higher
- **JDK**: Java 17

---

## 2. Setting Up the Environment

1. Ensure Flutter is installed and added to your `PATH`:
   ```bash
   flutter doctor
   ```
2. Verify all required tools (Android toolchain, IDEs) pass the check.

---

## 3. Cloning & Building

```bash
# Clone the codebase
git clone https://github.com/vachaspatimishraa/vitafolio.git
cd vitafolio

# Fetch packages
flutter pub get

# Generate Isar and Freezed models
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 4. Building Production Release Artifacts

### Android Release APK

```bash
flutter build apk --release
```
Output path: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (AAB for Google Play Store)

```bash
flutter build appbundle --release
```
Output path: `build/app/outputs/bundle/release/app-release.aab`

---

## 5. Running Tests

```bash
# Run unit tests
flutter test

# Run static code analysis
flutter analyze
```
