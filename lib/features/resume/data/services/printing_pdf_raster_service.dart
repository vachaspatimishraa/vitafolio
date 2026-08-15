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
      final rasters = await Printing.raster(bytesList, dpi: 150).toList();
      final pageCount = rasters.length;

      if (kDebugMode) {
        print('[PdfRasterService] Page count: $pageCount');
      }

      final images = <Uint8List>[];

      for (int i = 0; i < rasters.length; i++) {
        final raster = rasters[i];
        final pngBytes = await raster.toPng();
        
        final w = raster.width;
        final h = raster.height;
        final byteLen = pngBytes.length;

        bool isValidHeader = false;
        String format = 'UNKNOWN';
        if (pngBytes.length >= 4 &&
            pngBytes[0] == 0x89 &&
            pngBytes[1] == 0x50 &&
            pngBytes[2] == 0x4E &&
            pngBytes[3] == 0x47) {
          isValidHeader = true;
          format = 'PNG';
        } else if (pngBytes.length >= 3 &&
            pngBytes[0] == 0xFF &&
            pngBytes[1] == 0xD8 &&
            pngBytes[2] == 0xFF) {
          isValidHeader = true;
          format = 'JPEG';
        }

        if (kDebugMode) {
          print('[PdfRasterService] Rendering page: ${i + 1}/$pageCount');
          print('[PdfRasterService] Raster width: $w, height: $h');
          print('[PdfRasterService] Raster byte length: $byteLen');
          print('[PdfRasterService] Raster format: $format (header check: ${isValidHeader ? "PASS" : "FAIL"})');
        }

        if (w > 0 && h > 0 && byteLen > 0 && isValidHeader) {
          images.add(pngBytes);
        } else {
          if (kDebugMode) {
            print('[PdfRasterService] WARNING: Invalid raster on page ${i + 1}. Code: PDF_RASTER_INVALID_IMAGE');
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
