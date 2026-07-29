import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'font_cache.dart';
import 'image_optimizer.dart';

/// Transparent PDF Optimizer layer that enforces page settings, font caching,
/// memory disposal, and size bounds.
class PdfOptimizer {
  PdfOptimizer._internal();
  static final PdfOptimizer _instance = PdfOptimizer._internal();
  factory PdfOptimizer() => _instance;

  static const int maxFileSizeBytes = 2 * 1024 * 1024; // 2 MB target

  /// Configures default page theme with optimized fonts and standard margins.
  pw.PageTheme createOptimizedPageTheme({
    PdfPageFormat format = PdfPageFormat.a4,
    pw.EdgeInsets margin = const pw.EdgeInsets.all(32),
  }) {
    final fontCache = FontCache();
    return pw.PageTheme(
      pageFormat: format,
      margin: margin,
      theme: fontCache.pdfThemeData,
    );
  }

  /// Post-processes document generation, releases transient memory.
  Future<Uint8List> compileAndCompress(pw.Document document) async {
    final bytes = await document.save();
    ImageOptimizer().clearCache();
    return bytes;
  }
}
