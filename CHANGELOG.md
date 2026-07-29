# Changelog

All notable changes to the Vitafolio project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-29

### Added
- Initial v1.0.0 release of Vitafolio.
- Offline-first Isar NoSQL database architecture for local data persistence.
- Resume Editor supporting Personal Info, Work Experience, Education, Projects, Certifications, Languages, and Skills.
- Multiple ATS-compliant vector PDF templates (Modern, Minimalist, Executive).
- Real-time PDF preview engine with caching and performance monitoring.
- PDF file export with duplicate filename sanitization and protection.
- System share integration (`share_plus`).
- Input validation, data integrity verification, and centralized exception handling.
- Startup environment release checks and crash recovery service.
- Material 3 dynamic dark/light design system.

### Improved
- Memory management with explicit controller/node disposal in ViewModels.
- Routing guard checks and graceful fallback pages in `GoRouter`.
- PDF generation rendering speed with font caching and byte buffer reuse.