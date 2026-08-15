import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/pdf/optimization/font_cache.dart';
import 'package:vitafolio/core/pdf/optimization/performance_tracker.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
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
      final resume = Resume(
        id: const ResumeId('stress-test-1'),
        title: 'Stress Test Resume',
        selectedTemplateId: const TemplateId('ats'),
        personalDetails: const PersonalDetails(
          fullName: 'Alexander Sterling',
          email: 'alexander@example.com',
          phoneNumber: '+1 555 999 8888',
          address: 'San Francisco, CA',
          jobTitle: 'Principal Architect',
        ),
        summary: const ProfessionalSummary(
          summaryText: 'Seasoned Enterprise Software Architect with 15+ years experience.',
        ),
        experiences: const [
          Experience(
            id: 'e1',
            jobTitle: 'Principal Staff Architect',
            company: 'Tech Enterprise Megacorp',
            location: 'San Francisco',
            startDate: '2015',
            description: 'Engineered mission-critical transactional platforms.',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final pdfService = PdfService();
      final bytes = await pdfService.generatePdfFromDomain(resume);
      expect(bytes, isNotNull);
      expect(bytes.isNotEmpty, isTrue);
      expect(String.fromCharCodes(bytes.take(5)), equals('%PDF-'));
    });
  });
}
