import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/upload/data/services/resume_file_picker.dart';
import 'package:vitafolio/features/upload/presentation/viewmodels/upload_resume_viewmodel.dart';

class TestFakeResumeFilePicker implements ResumeFilePicker {
  PickedResumeFile? returnFile;
  bool shouldThrow = false;

  @override
  Future<PickedResumeFile?> pickResumeFile() async {
    if (shouldThrow) {
      throw Exception('Picker error');
    }
    return returnFile;
  }
}

void main() {
  group('UploadResumeViewModel & ResumeFilePicker Abstraction Tests', () {
    test('Test 1 — Tapping Choose Resume calls file picker abstraction', () async {
      final fakePicker = TestFakeResumeFilePicker()
        ..returnFile = const PickedResumeFile(
          path: '/path/to/my_resume.pdf',
          name: 'my_resume.pdf',
          sizeInMB: 1.5,
        );

      final container = ProviderContainer(
        overrides: [
          resumeFilePickerProvider.overrideWithValue(fakePicker),
        ],
      );

      final viewModel = container.read(uploadResumeViewModelProvider.notifier);

      expect(container.read(uploadResumeViewModelProvider).selectedFileName, isNull);

      await viewModel.pickRealFile();

      final state = container.read(uploadResumeViewModelProvider);
      expect(state.selectedFileName, equals('my_resume.pdf'));
      expect(state.selectedFileSize, equals('1.5 MB'));
      expect(state.errorMessage, isNull);
    });

    test('Test 2 — User cancels file picker retains null state without default file', () async {
      final fakePicker = TestFakeResumeFilePicker()..returnFile = null;

      final container = ProviderContainer(
        overrides: [
          resumeFilePickerProvider.overrideWithValue(fakePicker),
        ],
      );

      final viewModel = container.read(uploadResumeViewModelProvider.notifier);
      await viewModel.pickRealFile();

      final state = container.read(uploadResumeViewModelProvider);
      expect(state.selectedFileName, isNull);
      expect(state.extractedResume, isNull);
    });

    test('Test 3 — Unsupported file format rejects file selection', () async {
      final fakePicker = TestFakeResumeFilePicker()
        ..returnFile = const PickedResumeFile(
          path: '/path/to/malicious.exe',
          name: 'malicious.exe',
          sizeInMB: 2.0,
        );

      final container = ProviderContainer(
        overrides: [
          resumeFilePickerProvider.overrideWithValue(fakePicker),
        ],
      );

      final viewModel = container.read(uploadResumeViewModelProvider.notifier);
      await viewModel.pickRealFile();

      final state = container.read(uploadResumeViewModelProvider);
      expect(state.selectedFileName, isNull);
      expect(state.errorMessage, contains('Unsupported file type'));
    });

    test('Test 4 — File size exceeding 10MB rejects file selection', () async {
      final fakePicker = TestFakeResumeFilePicker()
        ..returnFile = const PickedResumeFile(
          path: '/path/to/huge_resume.pdf',
          name: 'huge_resume.pdf',
          sizeInMB: 12.5,
        );

      final container = ProviderContainer(
        overrides: [
          resumeFilePickerProvider.overrideWithValue(fakePicker),
        ],
      );

      final viewModel = container.read(uploadResumeViewModelProvider.notifier);
      await viewModel.pickRealFile();

      final state = container.read(uploadResumeViewModelProvider);
      expect(state.selectedFileName, isNull);
      expect(state.errorMessage, contains('too large'));
    });
  });
}
