import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/pdf/optimization/font_cache.dart';
import 'package:vitafolio/core/pdf/optimization/performance_tracker.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/core/pdf/testing/pdf_quality_checker.dart';
import 'package:vitafolio/core/pdf/validation/ats_validator.dart';
import 'package:vitafolio/core/pdf/validation/pdf_validator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PDF Optimization & Performance Tests', () {
    test('FontCache initializes and returns non-null pdfThemeData', () async {
      final fontCache = FontCache();
      await fontCache.initialize();
      expect(fontCache.regular, isNotNull);
      expect(fontCache.pdfThemeData, isNotNull);
    });

    test('PerformanceTracker records metrics accurately', () {
      final tracker = PerformanceTracker();
      tracker.clear();
      tracker.recordMetrics(
        renderingDuration: const Duration(milliseconds: 450),
        exportDuration: const Duration(milliseconds: 600),
        fileSizeBytes: 250000,
      );

      expect(tracker.lastMetrics, isNotNull);
      expect(tracker.lastMetrics!.meetsRenderingTarget, isTrue);
      expect(tracker.lastMetrics!.meetsSizeTarget, isTrue);
    });

    test('PdfValidator validates non-empty PDF bytes', () {
      final sampleBytes = Uint8List.fromList([
        0x25,
        0x50,
        0x44,
        0x46,
        0x2D,
        0x31,
        0x2E,
        0x35,
      ]);
      final result = PdfValidator.validate(sampleBytes);
      expect(result.isValid, isTrue);
    });

    test('AtsValidator calculates ATS score correctly', () {
      final resume = PdfQualityChecker.createStressTestResume();
      final result = AtsValidator.validate(resume);
      expect(result.isAtsFriendly, isTrue);
      expect(result.atsScore, greaterThanOrEqualTo(80));
    });

    test('PdfService generates valid PDF for stress test resume', () async {
      final resume = PdfQualityChecker.createStressTestResume();
      final pdfService = PdfService();
      final bytes = await pdfService.generatePdf(resume);

      expect(bytes, isNotEmpty);
      final validation = PdfValidator.validate(bytes, resume: resume);
      expect(validation.isValid, isTrue);
      expect(validation.fileSizeBytes, lessThan(2 * 1024 * 1024)); // < 2 MB
    });
  });
}
