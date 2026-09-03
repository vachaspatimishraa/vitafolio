import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';
import 'package:vitafolio/features/resume/domain/services/pdf_raster_service.dart';
import 'package:vitafolio/features/resume/domain/services/resume_ocr_service.dart';

class MockPdfRasterService implements PdfRasterService {
  final List<Uint8List> mockImages;
  int callCount = 0;

  MockPdfRasterService({required this.mockImages});

  @override
  Future<List<Uint8List>> renderPdfPagesToImages(List<int> pdfBytes) async {
    callCount++;
    return mockImages;
  }
}

class MockResumeOcrService implements ResumeOcrService {
  final String mockOcrText;
  int callCount = 0;

  MockResumeOcrService({required this.mockOcrText});

  @override
  Future<String?> extractTextFromImageBytes(List<int> imageBytes) async {
    callCount++;
    return mockOcrText;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Resume Import & Extraction Pipeline Tests', () {
    test('DOCX file extraction decompresses zip and extracts structured resume', () async {
      // Create a valid in-memory DOCX (ZIP archive with word/document.xml)
      const documentXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p><w:r><w:t>Morgan Tyler</w:t></w:r></w:p>
    <w:p><w:r><w:t>Senior Cloud Architect</w:t></w:r></w:p>
    <w:p><w:r><w:t>morgan.tyler@example.com</w:t></w:r></w:p>
    <w:p><w:r><w:t>+1 555-234-5678</w:t></w:r></w:p>
    <w:p><w:r><w:t>linkedin.com/in/morgantyler</w:t></w:r></w:p>
    <w:p><w:r><w:t>PROFESSIONAL SUMMARY</w:t></w:r></w:p>
    <w:p><w:r><w:t>Experienced cloud solutions architect with 8+ years designing scalable systems.</w:t></w:r></w:p>
    <w:p><w:r><w:t>WORK EXPERIENCE</w:t></w:r></w:p>
    <w:p><w:r><w:t>Cloud Infrastructure Lead</w:t></w:r></w:p>
    <w:p><w:r><w:t>Apex Technologies</w:t></w:r></w:p>
    <w:p><w:r><w:t>Architected distributed microservices on AWS and GCP.</w:t></w:r></w:p>
    <w:p><w:r><w:t>EDUCATION</w:t></w:r></w:p>
    <w:p><w:r><w:t>Bachelor of Science in Software Engineering</w:t></w:r></w:p>
    <w:p><w:r><w:t>California Institute of Technology</w:t></w:r></w:p>
    <w:p><w:r><w:t>SKILLS</w:t></w:r></w:p>
    <w:p><w:r><w:t>Kubernetes, Docker, Terraform, Python, Go</w:t></w:r></w:p>
  </w:body>
</w:document>''';

      final archive = Archive();
      final xmlBytes = utf8.encode(documentXml);
      archive.addFile(ArchiveFile('word/document.xml', xmlBytes.length, xmlBytes));
      final zipEncoder = ZipEncoder();
      final docxBytes = zipEncoder.encode(archive);
      expect(docxBytes, isNotNull);

      const parser = ResumeParserImpl();
      final resume = await parser.parseBytes(docxBytes!, ext: 'docx');

      expect(resume.personalDetails?.fullName, equals('Morgan Tyler'));
      expect(resume.personalDetails?.email, equals('morgan.tyler@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+1 555-234-5678'));
      expect(resume.summary?.summaryText, contains('Experienced cloud solutions architect'));
      expect(resume.experiences.length, greaterThanOrEqualTo(1));
      expect(resume.experiences.first.jobTitle, equals('Cloud Infrastructure Lead'));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.educations.first.degree, contains('Bachelor of Science'));
      expect(resume.skills.length, greaterThanOrEqualTo(3));
    });

    test('PDF file extraction with FlateDecode compressed stream extracts text and structure', () async {
      // Build a minimal valid PDF with a FlateDecode compressed stream
      const streamText = '''BT
/F1 12 Tf
(Jordan Lee) Tj T*
(Mobile Developer) Tj T*
(jordan.lee@example.com) Tj T*
(+1 555-987-6543) Tj T*
(PROFESSIONAL SUMMARY) Tj T*
(Passionate mobile developer building modern iOS and Android apps.) Tj T*
(WORK EXPERIENCE) Tj T*
(Lead Flutter Engineer) Tj T*
(Global Tech Labs) Tj T*
(Built production applications with high reliability.) Tj T*
(EDUCATION) Tj T*
(Bachelor of Computer Science) Tj T*
(State University) Tj T*
(SKILLS) Tj T*
(Flutter, Dart, Firebase, Kotlin) Tj T*
ET''';

      final rawStreamBytes = utf8.encode(streamText);
      final compressedBytes = zlib.encode(rawStreamBytes);

      final pdfHeader = utf8.encode('%PDF-1.4\n1 0 obj\n<< /Length ${compressedBytes.length} /Filter /FlateDecode >>\nstream\r\n');
      final pdfTrailer = utf8.encode('\r\nendstream\nendobj\nxref\n0 2\n0000000000 65535 f \n0000000009 00000 n \ntrailer\n<< /Size 2 /Root 1 0 R >>\nstartxref\n100\n%%EOF');

      final fullPdfBytes = <int>[...pdfHeader, ...compressedBytes, ...pdfTrailer];

      const parser = ResumeParserImpl();
      final resume = await parser.parseBytes(fullPdfBytes, ext: 'pdf');

      expect(resume.personalDetails?.fullName, equals('Jordan Lee'));
      expect(resume.personalDetails?.email, equals('jordan.lee@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+1 555-987-6543'));
      expect(resume.summary?.summaryText, contains('Passionate mobile developer'));
      expect(resume.experiences.length, greaterThanOrEqualTo(1));
      expect(resume.experiences.first.jobTitle, equals('Lead Flutter Engineer'));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.skills.length, greaterThanOrEqualTo(3));
    });

    test('PDF with unreadable text triggers OCR fallback when available', () async {
      const ocrExtractedResume = '''
Sarah Connor
Security Specialist
sarah@cyberdyne.com
+1 555-000-1122

SUMMARY
Cybersecurity engineer specializing in threat analysis and defenses.

EXPERIENCE
Chief Information Security Officer
Resistance Systems
Led threat modeling and defense architecture.

EDUCATION
Master of Science in Information Security
Tech Institute

SKILLS
Penetration Testing, Cryptography, Linux, Python
''';

      // Scanned/image PDF with empty text stream
      const emptyPdfStream = '%PDF-1.4\n1 0 obj\n<< /Length 0 >>\nstream\r\n\r\nendstream\nendobj\ntrailer\n<< /Size 2 >>\n%%EOF';
      final emptyPdfBytes = utf8.encode(emptyPdfStream);

      // Dummy PNG image bytes for raster mock
      final dummyPng = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);
      final mockRaster = MockPdfRasterService(mockImages: [dummyPng]);
      final mockOcr = MockResumeOcrService(mockOcrText: ocrExtractedResume);

      final parser = ResumeParserImpl(
        pdfRasterService: mockRaster,
        ocrService: mockOcr,
      );

      final resume = await parser.parseBytes(emptyPdfBytes, ext: 'pdf');

      expect(mockRaster.callCount, equals(1), reason: 'Raster service should be invoked for OCR fallback');
      expect(mockOcr.callCount, equals(1), reason: 'OCR service should be invoked');
      expect(resume.personalDetails?.fullName, equals('Sarah Connor'));
      expect(resume.personalDetails?.email, equals('sarah@cyberdyne.com'));
      expect(resume.experiences.first.jobTitle, equals('Chief Information Security Officer'));
    });

    test('Optional resume sections do not reject valid import', () async {
      // Resume with only Name, Email, Phone, and Education (NO Experience, Projects, Certs, Languages)
      const minimalResume = '''
Taylor Swift
Software Intern
taylor@example.com
+1 555-432-1098

EDUCATION
Bachelor of Science in Information Technology
City University
''';

      const parser = ResumeParserImpl();
      final resume = await parser.parseText(minimalResume);

      expect(resume.personalDetails?.fullName, equals('Taylor Swift'));
      expect(resume.personalDetails?.email, equals('taylor@example.com'));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.experiences, isEmpty);
      expect(resume.projects, isEmpty);
      expect(resume.certifications, isEmpty);
      expect(resume.languages, isEmpty);
    });
  });
}
