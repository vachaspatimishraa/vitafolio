# ANTIGRAVITY_IDE_REPORT_050

## Root Cause

The previous implementation in `upload_resume_viewmodel.dart` and `upload_resume_page.dart` contained a placeholder method `selectMockFile('John_Doe_Resume_2024.pdf', '2.3 MB')` bound to the 'Upload Resume' / 'Browse' button instead of invoking the native Android document file picker. When tapped on Android, it bypassed the system picker entirely and populated hard-coded file metadata.

---

## File Picker Implementation

- **Package Used**: `file_picker` (`^8.0.0` added to `pubspec.yaml`).
- **Clean Architecture Abstraction**: Defined `ResumeFilePicker` contract and `ProductionResumeFilePicker` (`lib/features/upload/data/services/resume_file_picker.dart`).
- **Allowed Extensions**: `['pdf', 'doc', 'docx']`.
- **Cancel Behavior**: If the user cancels the native Android picker (`result == null`), `pickRealFile()` resets loading state without setting any fallback file, keeping `selectedFileName` null.
- **Change File Behavior**: Tapping 'Change File' invokes `pickRealFile()` via `ResumeFilePicker`, allowing the user to select another file from Android storage.
- **URI/Path Handling**: Handles both filesystem paths (`path`) and in-memory byte arrays (`bytes`) from Android SAF document providers without throwing exceptions.

---

## Parser & Data Flow

- **Selected File Delivery**: `UploadResumeViewModel.parseSelectedFile()` retrieves the selected file path / bytes and passes it directly to `ParseResumeFile` usecase -> `ResumeParserImpl`.
- **No Hard-Coded Fallback**: Removed `selectMockFile` and mock text generation entirely from production code. If no file is selected, returns explicit error `No resume file was selected.`
- **File Validation**: Validates file extension and size limit (max 10 MB).
- **No-Fabrication Guarantee**: Missing fields in selected files remain empty.

---

## Persistence & State

- **CreateResume**: Saves extracted resume to local Isar database.
- **activeResumeIdProvider**: Binds active resume ID to the newly imported resume.
- **Multi-Resume Isolation**: Each file import creates a distinct resume record.
- **Duplicate Prevention**: Prevents double-taps by locking state (`isLoading = true`).

---

## Tests

- Added `test/features/upload/real_file_picker_test.dart` verifying file picker abstraction, cancellation handling, format validation, and size validation.
- All unit, widget, and integration tests passed (`122/122 tests passed`).

---

## Physical Android Verification

```text
PHYSICAL ANDROID VERIFICATION: NOT PERFORMED
```
*(Executed in non-GUI container environment)*
