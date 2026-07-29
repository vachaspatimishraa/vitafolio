# Technical Architecture Guide

Vitafolio is structured using strict **MVVM (Model-View-ViewModel)** with the **Repository Pattern** and **Clean Architecture** principles.

---

## Data Flow Diagram

```
[ User Interaction ]
        │
        ▼
[ View (Flutter Widgets) ]
        │
        ▼
[ ViewModel (Riverpod StateNotifier/Notifier) ]
        │
        ▼
[ Repository Layer (Abstractions & Concrete Impl) ]
        │
        ▼
[ Data Source (Isar Local Service) ]
        │
        ▼
[ Isar Database Engine ]
```

---

## Architectural Layers

### 1. Presentation Layer (`lib/features/`)
- **Views**: Stateless/ConsumerWidgets rendering Material 3 UI components.
- **ViewModels**: Manage screen-specific state using Riverpod providers.
- **State**: Immutable state models holding loading states, validation errors, and resume drafts.

### 2. Core Security & Utilities (`lib/core/security/`)
- **InputValidator**: Sanitizes and validates user input.
- **DataValidator**: Asserts entity integrity before persistence.
- **ExceptionHandler**: Centralized logging and user-safe error translation.
- **ReleaseChecker**: Audits asset presence and release security settings.

### 3. PDF Rendering Engine (`lib/core/pdf/`)
- Utilizes strategy-pattern renderers (`ModernPdfRenderer`, `MinimalPdfRenderer`, `ExecutivePdfRenderer`) to map domain `ResumeModel` objects to vector-based PDF pages.

### 4. Data Layer (`lib/data/` & `lib/core/database/`)
- **Isar Database**: High-speed, typed NoSQL database storing resumes and section entries.
- **Repositories**: Abstract database operations away from ViewModels.
