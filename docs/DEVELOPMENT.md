# Developer Workflow & Contribution Guide

This guide outlines standards for contributing to the Vitafolio repository.

---

## Code Style & Formatting

1. **Dart Lints**: All code must conform to `flutter_lints`.
   ```bash
   flutter analyze
   ```
2. **Formatting**: Format all `.dart` files before committing:
   ```bash
   dart format .
   ```
3. **Documentation**: Write triple-slash (`///`) docstrings for public classes and methods.

---

## Code Generation

When modifying models in `lib/data/models/` or Isar schemas:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Pull Request Guidelines

1. Ensure all tests pass (`flutter test`).
2. Run code generation and static analysis (`flutter analyze`).
3. Maintain existing documentation.
