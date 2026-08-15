import 'dart:typed_data';

/// Interface for rasterizing PDF document pages into bitmap image byte arrays for OCR.
abstract class PdfRasterService {
  /// Renders all pages of a PDF document into sequential image byte arrays (PNG/JPEG).
  /// Processed page by page to conserve memory on mobile platforms.
  Future<List<Uint8List>> renderPdfPagesToImages(List<int> pdfBytes);
}
