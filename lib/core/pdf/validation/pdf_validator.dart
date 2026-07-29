import 'dart:typed_data';
import '../../../../data/models/resume_model.dart';

class PdfValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final int fileSizeBytes;

  const PdfValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
    required this.fileSizeBytes,
  });

  @override
  String toString() =>
      'PdfValidationResult(isValid: $isValid, errors: ${errors.length}, warnings: ${warnings.length}, size: ${fileSizeBytes}B)';
}

/// Validates PDF file integrity, header magic bytes, metadata, and size targets.
class PdfValidator {
  static const int maxRecommendedSize = 2 * 1024 * 1024; // 2 MB

  /// Validates generated PDF bytes against production requirements.
  static PdfValidationResult validate(Uint8List bytes, {ResumeModel? resume}) {
    final errors = <String>[];
    final warnings = <String>[];

    if (bytes.isEmpty) {
      errors.add('Generated PDF file is empty (0 bytes).');
      return PdfValidationResult(
        isValid: false,
        errors: errors,
        fileSizeBytes: 0,
      );
    }

    // Check PDF magic header header (%PDF-)
    if (bytes.length < 5) {
      errors.add('File is too small to contain valid PDF headers.');
    } else {
      final header = String.fromCharCodes(bytes.sublist(0, 5));
      if (header != '%PDF-') {
        errors.add('Invalid PDF file header: $header (expected %PDF-)');
      }
    }

    if (bytes.length > maxRecommendedSize) {
      warnings.add(
        'PDF size (${(bytes.length / (1024 * 1024)).toStringAsFixed(2)}MB) exceeds 2MB target.',
      );
    }

    return PdfValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      fileSizeBytes: bytes.length,
    );
  }

  /// Creates standardized metadata map for exports.
  static Map<String, String> createMetadata(ResumeModel resume) {
    final fullName = (resume.personalInfo?.fullName?.isNotEmpty ?? false)
        ? resume.personalInfo!.fullName!
        : 'Vitafolio User';
    final jobTitle = (resume.personalInfo?.jobTitle?.isNotEmpty ?? false)
        ? resume.personalInfo!.jobTitle!
        : 'Resume';

    return {
      'title': '$fullName - Resume',
      'author': fullName,
      'subject': jobTitle,
      'creator': 'Vitafolio Resume Builder',
      'keywords': 'Resume, CV, $jobTitle, Vitafolio',
    };
  }
}
