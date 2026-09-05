import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:vitafolio/features/resume/domain/services/pdf_raster_service.dart';

/// Production implementation of [PdfRasterService] using `Printing.raster`.
class PrintingPdfRasterService implements PdfRasterService {
  const PrintingPdfRasterService();

  @override
  Future<List<Uint8List>> renderPdfPagesToImages(List<int> pdfBytes) async {
    if (pdfBytes.isEmpty) {
      if (kDebugMode) {
        print('[PdfRasterService] ERROR: Input PDF bytes empty. Code: PDF_RASTER_EMPTY');
      }
      return [];
    }

    if (kDebugMode) {
      print('[PdfRasterService] Starting rasterization for ${pdfBytes.length} bytes');
    }

    try {
      final bytesList = Uint8List.fromList(pdfBytes);
      // Limit raster to first 4 pages max (standard resumes are 1-3 pages) at 100 DPI
      final rasters = await Printing.raster(bytesList, pages: const [0, 1, 2, 3], dpi: 100).toList();
      final pageCount = rasters.length;
      if (kDebugMode) {
        print('[PdfRasterService] Page count: $pageCount');
      }

      final images = <Uint8List>[];

      for (int i = 0; i < rasters.length; i++) {
        final raster = rasters[i];
        final pngBytes = await raster.toPng();

        if (pngBytes.isNotEmpty && pngBytes.length > 50) {
          images.add(pngBytes);
        } else {
          if (kDebugMode) {
            print('[PdfRasterService] WARNING: Empty raster on page ${i + 1}. Code: PDF_RASTER_INVALID_IMAGE');
          }
        }
      }

      return images;
    } catch (e) {
      if (kDebugMode) {
        print('[PdfRasterService] ERROR: Exception during rasterization: $e. Code: PDF_RASTERIZATION_FAILED');
      }
      return [];
    }
  }
}
