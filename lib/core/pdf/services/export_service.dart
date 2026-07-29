import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../data/models/resume_model.dart';
import '../optimization/performance_tracker.dart';

class ExportResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;

  const ExportResult({required this.success, this.filePath, this.errorMessage});
}

/// Service handling document save, platform print interface, and file sharing with duplicate protection.
class ExportService {
  final PerformanceTracker _tracker;

  ExportService({PerformanceTracker? tracker})
    : _tracker = tracker ?? PerformanceTracker();

  /// Generates clean file name based on resume model details.
  String generateFileName(ResumeModel resume) {
    final rawName = (resume.personalInfo?.fullName?.trim().isEmpty ?? true)
        ? 'Resume'
        : resume.personalInfo!.fullName!.trim();
    final sanitized = rawName
        .replaceAll(RegExp(r'[^\w\s\-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    return '${sanitized}_CV.pdf';
  }

  /// Saves PDF to local device application documents folder.
  Future<ExportResult> savePdfToStorage(
    Uint8List pdfBytes,
    String fileName,
  ) async {
    _tracker.startExportTrace();
    try {
      final dir = await getApplicationDocumentsDirectory();
      var targetFile = File('${dir.path}/$fileName');

      // Duplicate protection: add timestamp suffix if file exists
      if (await targetFile.exists()) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final nameWithoutExt = fileName.replaceAll('.pdf', '');
        targetFile = File('${dir.path}/${nameWithoutExt}_$timestamp.pdf');
      }

      await targetFile.writeAsBytes(pdfBytes, flush: true);
      final exportDuration = _tracker.stopExportTrace();

      _tracker.recordMetrics(
        renderingDuration: Duration.zero,
        exportDuration: exportDuration,
        fileSizeBytes: pdfBytes.length,
      );

      return ExportResult(success: true, filePath: targetFile.path);
    } catch (e) {
      _tracker.stopExportTrace();
      return ExportResult(success: false, errorMessage: e.toString());
    }
  }

  /// Triggers platform printing window (iOS/Android/Windows/macOS/Linux).
  Future<bool> printPdf(
    Uint8List pdfBytes, {
    String name = 'Resume.pdf',
  }) async {
    return Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: name,
    );
  }

  /// Shares PDF via OS native share sheet using `share_plus`.
  Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(pdfBytes, flush: true);

    await Share.shareXFiles([
      XFile(tempFile.path),
    ], text: 'Exported Resume from Vitafolio');
  }
}
