# Vitafolio

> **Build Your Professional Story** — A premium, offline-first resume builder for Flutter.

Vitafolio is a modern, high-performance, offline-first Flutter application engineered to help professionals create, edit, preview, and export high-quality resumes effortlessly. Built with strict MVVM architecture, Isar database, Riverpod state management, and custom PDF rendering engines, Vitafolio ensures maximum data privacy and performance without requiring an active internet connection.

---

## Key Features

- **100% Offline & Private**: All user data resides locally on-device in a high-speed Isar NoSQL database. No servers, no tracking.
- **Dynamic Live Preview**: Instant visual feedback as you build and modify sections.
- **Multiple ATS-Friendly Templates**: Curated professional resume layouts (Modern, Minimalist, Executive) engineered for high ATS parsing accuracy.
- **High-Performance PDF Engine**: Native vector-based PDF generation with pixel-perfect pagination and typography.
- **Auto-Save & Crash Recovery**: Continuous draft persistence with transient state cache recovery.
- **Native Sharing & Export**: Instant export to device storage and system share sheet.

---

## Architecture & Technology Stack

- **Framework**: Flutter (Dart 3.x)
- **Architecture**: MVVM with Repository Pattern
- **State Management**: Flutter Riverpod (`2.6.1`)
- **Routing**: GoRouter (`16.0.0`)
- **Database**: Isar NoSQL Database (`3.1.0+1`)
- **PDF Generation**: `pdf` & `printing` packages
- **Styling**: Material 3 with HSL-tailored dark/light design system

---

## Project Folder Structure

```
lib/
├── app/                  # Application configuration, router, and themes
├── core/                 # Shared utilities, database, PDF engines, security, and widgets
│   ├── database/         # Isar database service, providers, and migrations
│   ├── pdf/              # Vector PDF renderers, theme calculators, ATS validators
│   ├── security/         # Exception handling, input validation, data integrity
│   ├── theme/            # Design system, color palettes, typography
│   └── utils/            # Date formatters, sanitizers, PDF helpers
├── data/                 # Models, schemas, datasources, repository implementations
├── features/             # App feature modules (MVVM structure)
│   ├── editor/           # Section-by-section resume editing
│   ├── home/             # Resume list, search, duplicate, delete
│   ├── navigation/       # App shell and bottom navigation
│   ├── preview/          # Live resume preview renderer
│   ├── splash/           # Splash screen and initialization
│   └── templates/        # Template picker and previewer
├── services/             # Application lifecycle, crash recovery, integrity services
└── shared/               # Reusable UI widgets and cards
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>=3.11.0`)
- Android Studio / VS Code with Flutter extension
- Android SDK (API level 21 or higher)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vachaspatimishraa/vitafolio.git
   cd vitafolio
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## Documentation

Comprehensive project documentation is available in the [`docs/`](file:///c:/Users/vacha/Desktop/projects/vitafolio/docs) directory:

- [Installation & Build Guide](file:///c:/Users/vacha/Desktop/projects/vitafolio/docs/INSTALLATION.md)
- [Architecture & Design Guide](file:///c:/Users/vacha/Desktop/projects/vitafolio/docs/ARCHITECTURE.md)
- [Development Workflow Guide](file:///c:/Users/vacha/Desktop/projects/vitafolio/docs/DEVELOPMENT.md)
- [Contributing Guidelines](file:///c:/Users/vacha/Desktop/projects/vitafolio/docs/CONTRIBUTING.md)

---

## Release Notes & Changelog

- Read the latest [Release Notes](file:///c:/Users/vacha/Desktop/projects/vitafolio/RELEASE_NOTES.md) for Version 1.0.0.
- Check the [CHANGELOG.md](file:///c:/Users/vacha/Desktop/projects/vitafolio/CHANGELOG.md) for version history.

---

## License

This project is licensed under the MIT License — see the [LICENSE](file:///c:/Users/vacha/Desktop/projects/vitafolio/LICENSE) file for details.