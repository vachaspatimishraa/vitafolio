import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';
import 'package:vitafolio/features/upload/data/services/resume_file_picker.dart';

final resumeFilePickerProvider = Provider<ResumeFilePicker>((ref) {
  return const ProductionResumeFilePicker();
});

class UploadResumeState {
  final bool isLoading;
  final String? selectedFilePath;
  final String? selectedFileName;
  final String? selectedFileSize;
  final List<int>? selectedFileBytes;
  final Resume? extractedResume;
  final String? errorMessage;

  const UploadResumeState({
    this.isLoading = false,
    this.selectedFilePath,
    this.selectedFileName,
    this.selectedFileSize,
    this.selectedFileBytes,
    this.extractedResume,
    this.errorMessage,
  });

  UploadResumeState copyWith({
    bool? isLoading,
    String? selectedFilePath,
    String? selectedFileName,
    String? selectedFileSize,
    List<int>? selectedFileBytes,
    Resume? extractedResume,
    String? errorMessage,
  }) {
    return UploadResumeState(
      isLoading: isLoading ?? this.isLoading,
      selectedFilePath: selectedFilePath ?? this.selectedFilePath,
      selectedFileName: selectedFileName ?? this.selectedFileName,
      selectedFileSize: selectedFileSize ?? this.selectedFileSize,
      selectedFileBytes: selectedFileBytes ?? this.selectedFileBytes,
      extractedResume: extractedResume ?? this.extractedResume,
      errorMessage: errorMessage,
    );
  }
}

class UploadResumeViewModel extends StateNotifier<UploadResumeState> {
  final Ref _ref;

  UploadResumeViewModel(this._ref) : super(const UploadResumeState());

  Future<void> pickRealFile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final picker = _ref.read(resumeFilePickerProvider);
      final file = await picker.pickResumeFile();

      if (file == null) {
        // User cancelled picker
        state = state.copyWith(isLoading: false);
        return;
      }

      var ext = file.name.contains('.') ? file.name.split('.').last.toLowerCase() : '';
      if (ext.isEmpty && file.path != null && file.path!.contains('.')) {
        ext = file.path!.split('.').last.toLowerCase();
      }
      // Inspect magic bytes if extension not present in name or path
      if (ext.isEmpty && file.bytes != null && file.bytes!.isNotEmpty) {
        final b = file.bytes!;
        if (b.length >= 4 && b[0] == 0x25 && b[1] == 0x50 && b[2] == 0x44 && b[3] == 0x46) {
          ext = 'pdf';
        } else if (b.length >= 2 && b[0] == 0x50 && b[1] == 0x4B) {
          ext = 'docx';
        } else if (b.length >= 2 && b[0] == 0xFF && b[1] == 0xD8) {
          ext = 'jpg';
        } else if (b.length >= 4 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) {
          ext = 'png';
        }
      }

      if (ext != 'pdf' && ext != 'doc' && ext != 'docx' && ext != 'png' && ext != 'jpg' && ext != 'jpeg' && ext != 'webp') {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Unsupported file type. Please select a PDF, DOCX, or Image resume.',
        );
        return;
      }

      if (file.sizeInMB > 10.0) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'This file is too large. Please select a file smaller than 10 MB.',
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        selectedFilePath: file.path,
        selectedFileName: file.name,
        selectedFileSize: '${file.sizeInMB.toStringAsFixed(1)} MB',
        selectedFileBytes: file.bytes,
        extractedResume: null,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to read this file. Please choose another resume.',
      );
    }
  }

  void clearSelectedFile() {
    state = const UploadResumeState();
  }

  Future<Resume?> parseSelectedFile() async {
    if (state.selectedFilePath == null && state.selectedFileBytes == null) {
      state = state.copyWith(errorMessage: 'No resume file was selected.');
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final fileName = state.selectedFileName ?? '';
      var ext = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : '';
      final path = state.selectedFilePath;
      if (ext.isEmpty && path != null && path.contains('.')) {
        ext = path.split('.').last.toLowerCase();
      }

      var bytes = state.selectedFileBytes;
      if ((bytes == null || bytes.isEmpty) && path != null && path.isNotEmpty && File(path).existsSync()) {
        try {
          bytes = await File(path).readAsBytes();
        } catch (_) {}
      }

      if (ext.isEmpty && bytes != null && bytes.isNotEmpty) {
        if (bytes.length >= 4 && bytes[0] == 0x25 && bytes[1] == 0x50 && bytes[2] == 0x44 && bytes[3] == 0x46) {
          ext = 'pdf';
        } else if (bytes.length >= 2 && bytes[0] == 0x50 && bytes[1] == 0x4B) {
          ext = 'docx';
        } else if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
          ext = 'jpg';
        } else if (bytes.length >= 4 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
          ext = 'png';
        }
      }

      if (kDebugMode) {
        print('[UPLOAD] Starting resume parsing request');
        print('[UPLOAD] File name: $fileName');
        print('[UPLOAD] Extension: $ext');
        print('[UPLOAD] Path available: ${path != null && path.isNotEmpty}');
        if (path != null && path.isNotEmpty) print('[UPLOAD] Path: $path');
        print('[UPLOAD] Bytes available: ${bytes != null}');
        if (bytes != null) print('[UPLOAD] Byte count: ${bytes.length}');
      }

      final parser = _ref.read(resumeDomainParserProvider) as ResumeParserImpl;
      Resume parsed;

      if (bytes != null && bytes.isNotEmpty) {
        if (kDebugMode) print('[UPLOAD] Delegating to parser.parseBytes(bytes, ext: $ext)');
        parsed = await parser.parseBytes(bytes, ext: ext);
      } else if (path != null && path.isNotEmpty && File(path).existsSync()) {
        if (kDebugMode) print('[UPLOAD] Delegating to parser.parseFile(path)');
        parsed = await parser.parseFile(path);
      } else {
        throw Exception('No valid resume file path or content available.');
      }

      if (kDebugMode) {
        print('[UPLOAD] Resume extraction succeeded!');
        print('[UPLOAD] Personal details name: ${parsed.personalDetails?.fullName}');
        print('[UPLOAD] Experiences count: ${parsed.experiences.length}');
        print('[UPLOAD] Educations count: ${parsed.educations.length}');
        print('[UPLOAD] Skills count: ${parsed.skills.length}');
      }

      state = state.copyWith(
        isLoading: false,
        extractedResume: parsed,
      );
      return parsed;
    } catch (e, stack) {
      if (kDebugMode) {
        print('[UPLOAD] ERROR during resume parsing: $e');
        print('[UPLOAD] Stack trace: $stack');
      }
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  Future<bool> confirmImportAndSave() async {
    final extracted = state.extractedResume;
    if (extracted == null) return false;

    try {
      state = state.copyWith(isLoading: true);
      final newResume = await _ref.read(createResumeUseCaseProvider).call(extracted);
      _ref.read(activeResumeIdProvider.notifier).state = newResume.id;
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to import resume: ${e.toString()}',
      );
      return false;
    }
  }
}

final uploadResumeViewModelProvider =
    StateNotifierProvider<UploadResumeViewModel, UploadResumeState>((ref) {
  return UploadResumeViewModel(ref);
});
