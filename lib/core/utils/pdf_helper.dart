import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vitafolio/core/security/input_validator.dart';
import 'package:vitafolio/core/security/exception_handler.dart';

/// Helper class for secure, resilient PDF generation, saving, and sharing operations.
class PdfHelper {
  PdfHelper._();

  /// Saves the PDF document to a file securely with filename sanitization and collision prevention.
  static Future<String?> savePdf(pw.Document pdf, String rawFilename) async {
    return await ExceptionHandler.runAsyncSafely(() async {
      final sanitized = InputValidator.sanitizeFilename(rawFilename);
      final directory = await getApplicationDocumentsDirectory();

      String targetPath = p.join(directory.path, '$sanitized.pdf');
      File file = File(targetPath);
      int counter = 1;

      // Handle duplicate file names safely without overwriting unintentionally
      while (await file.exists()) {
        targetPath = p.join(directory.path, '${sanitized}_$counter.pdf');
        file = File(targetPath);
        counter++;
      }

      final bytes = await pdf.save();
      await file.writeAsBytes(bytes, flush: true);
      return targetPath;
    }, context: 'PdfHelper.savePdf');
  }

  /// Converts the PDF document to bytes safely.
  static Future<Uint8List?> convertToBytes(pw.Document pdf) async {
    return await ExceptionHandler.runAsyncSafely(() async {
      return await pdf.save();
    }, context: 'PdfHelper.convertToBytes');
  }

  /// Shares the PDF file using the system share sheet safely.
  static Future<bool> sharePdf(pw.Document pdf, String rawFilename) async {
    final result = await ExceptionHandler.runAsyncSafely(
      () async {
        final bytes = await convertToBytes(pdf);
        if (bytes == null) return false;

        final sanitized = InputValidator.sanitizeFilename(rawFilename);
        final tempDir = await getTemporaryDirectory();
        final filePath = p.join(tempDir.path, '$sanitized.pdf');
        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);

        await Share.shareXFiles([XFile(filePath)], text: 'Here is my resume');
        return true;
      },
      context: 'PdfHelper.sharePdf',
      fallback: false,
    );

    return result ?? false;
  }

  /// Downloads/Saves the PDF file to the device documents storage safely.
  static Future<String?> downloadPdf(
    pw.Document pdf,
    String rawFilename,
  ) async {
    return await savePdf(pdf, rawFilename);
  }
}
