import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';
import 'package:vitafolio/features/resume/domain/services/pdf_raster_service.dart';
import 'package:vitafolio/features/resume/domain/services/resume_ocr_service.dart';

class FakeResumeOcrService implements ResumeOcrService {
  final String mockText;
  int callCount = 0;
  List<int> lastReceivedBytes = [];

  FakeResumeOcrService({required this.mockText});

  @override
  Future<String?> extractTextFromImageBytes(List<int> imageBytes) async {
    callCount++;
    lastReceivedBytes = List.from(imageBytes);
    return mockText;
  }
}

class FakePdfRasterService implements PdfRasterService {
  final List<Uint8List> mockImages;

  FakePdfRasterService({required this.mockImages});

  @override
  Future<List<Uint8List>> renderPdfPagesToImages(List<int> pdfBytes) async {
    return mockImages;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const defaultParser = ResumeParserImpl();

  group('ResumeParserImpl Document Extraction & Garbage Rejection Tests', () {
    test('Test 1 — Text PDF / Normal Resume Text extraction', () async {
      const sampleResumeText = '''
Vacha Shah
Senior Flutter Engineer
vacha@example.com
+91 9876543210
linkedin.com/in/vachashah
github.com/vachashah

PROFESSIONAL SUMMARY
Experienced Senior Flutter Engineer with 5+ years of mobile application development.

WORK EXPERIENCE
Senior Mobile Developer
Tech Solutions Inc
Lead developer for enterprise mobile apps.

EDUCATION
B.Tech Computer Science
State Institute of Technology

SKILLS
Flutter, Dart, Riverpod, Firebase, REST API

PROJECTS
Vitafolio
A premium resume builder application.

CERTIFICATIONS
Google Certified Android Associate

LANGUAGES
English - Native
Hindi - Fluent
''';

      final resume = await defaultParser.parseText(sampleResumeText);

      expect(resume.personalDetails?.fullName, equals('Vacha Shah'));
      expect(resume.personalDetails?.jobTitle, equals('Senior Flutter Engineer'));
      expect(resume.personalDetails?.email, equals('vacha@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+91 9876543210'));
      expect(resume.summary?.summaryText, contains('Senior Flutter Engineer'));
      expect(resume.experiences.length, greaterThanOrEqualTo(1));
      expect(resume.experiences.first.jobTitle, equals('Senior Mobile Developer'));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.educations.first.degree, contains('B.Tech'));
      expect(resume.skills.length, equals(5));
      expect(resume.projects.length, greaterThanOrEqualTo(1));
      expect(resume.certifications.length, greaterThanOrEqualTo(1));
      expect(resume.languages.length, greaterThanOrEqualTo(1));
    });

    test('Test 2 — Garbage Extraction Rejection (%dcshjke & 3247687638375438)', () async {
      const garbageText = '''
%dcshjke
3247687638375438
\\u0000\\u0000\\u0000
asdfgh
qwerty
123456789012345678
''';

      expect(
        () async => await defaultParser.parseBytes(Uint8List.fromList(garbageText.codeUnits), ext: 'pdf'),
        throwsA(isA<Exception>()),
      );
    });

    test('Test 3 — Magic Byte Validation Rejects Invalid Binary File', () async {
      final randomBinary = Uint8List.fromList([0x00, 0xFF, 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB]);
      expect(
        () async => await defaultParser.parseBytes(randomBinary, ext: 'pdf'),
        throwsA(isA<Exception>()),
      );
    });

    test('Test 4 — DOC File returns descriptive unsupported message', () async {
      final oleHeader = Uint8List.fromList([0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB2, 0xC3, 0xD4]);
      expect(
        () async => await defaultParser.parseBytes(oleHeader, ext: 'doc'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('This DOC file could not be read reliably'),
          ),
        ),
      );
    });

    test('Test 5 — Deterministic Unique Fixture Test', () async {
      const uniqueText = '''
VITAFOLIO UNIQUE PERSON 987
Senior Flutter Engineer UNIQUE
vitafolio.unique.987@example.com
+91 9876543210

PROFESSIONAL SUMMARY
Unique candidate summary with special identifier 999.

WORK EXPERIENCE
Lead Engineer
UNIQUE COMPANY ALPHA
Built high performance cross-platform applications.

EDUCATION
Bachelor of Technology
UNIQUE UNIVERSITY DELTA

SKILLS
UNIQUE_SKILL_XYZ, Dart, Flutter

PROJECTS
UNIQUE PROJECT OMEGA
Built state-of-the-art resume management app.

CERTIFICATIONS
UNIQUE CERTIFICATION 777

LANGUAGES
English
''';

      final resume = await defaultParser.parseText(uniqueText);

      expect(resume.personalDetails?.fullName, equals('VITAFOLIO UNIQUE PERSON 987'));
      expect(resume.personalDetails?.jobTitle, equals('Senior Flutter Engineer UNIQUE'));
      expect(resume.personalDetails?.email, equals('vitafolio.unique.987@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+91 9876543210'));
      expect(resume.summary?.summaryText, contains('special identifier 999'));
      expect(resume.experiences.first.company, equals('UNIQUE COMPANY ALPHA'));
      expect(resume.educations.first.degree, contains('Bachelor of Technology'));
      expect(resume.skills.map((s) => s.name), contains('UNIQUE_SKILL_XYZ'));
      expect(resume.projects.first.name, equals('UNIQUE PROJECT OMEGA'));
      expect(resume.certifications.first.name, equals('UNIQUE CERTIFICATION 777'));
    });

    test('Test 6 — Handoff Test: Scanned PDF Raster -> Fake OCR Service -> Resume Domain Entity', () async {
      // Create valid PNG image bytes (PNG Signature: 89 50 4E 47)
      final fakePngBytes = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x0A,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x8D, 0x32, 0xCF, 0xBD,
      ]);

      const mockOcrResult = '''
John Smith
Senior Mobile Developer
john.smith@example.com
+1 (555) 019-2834

PROFESSIONAL SUMMARY
Experienced mobile developer specializing in Flutter and Clean Architecture.

EXPERIENCE
Senior Flutter Developer
Acme Solutions Tech
Developed cross-platform mobile apps serving 100k+ active users.

EDUCATION
Bachelor of Science in Computer Science
State University

SKILLS
Flutter, Dart, Riverpod, REST APIs
''';

      final fakeOcr = FakeResumeOcrService(mockText: mockOcrResult);
      final fakeRaster = FakePdfRasterService(mockImages: [fakePngBytes]);

      final handoffParser = ResumeParserImpl(
        ocrService: fakeOcr,
        pdfRasterService: fakeRaster,
      );

      // Construct dummy PDF bytes with %PDF header
      final pdfBytes = Uint8List.fromList([
        ...'%PDF-1.4\n1 0 obj\n<< /Type /Catalog >>\nendobj\n'.codeUnits,
      ]);

      final resume = await handoffParser.parseBytes(pdfBytes, ext: 'pdf');

      expect(fakeOcr.callCount, equals(1));
      expect(fakeOcr.lastReceivedBytes, equals(fakePngBytes));

      expect(resume.personalDetails?.fullName, equals('John Smith'));
      expect(resume.personalDetails?.jobTitle, equals('Senior Mobile Developer'));
      expect(resume.personalDetails?.email, equals('john.smith@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+1 (555) 019-2834'));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.skills.map((s) => s.name), contains('Flutter'));
    });

    test('Test 7 — DOCX Table Cell Extraction', () async {
      final docxXmlWithTable = '''
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
    <w:p><w:r><w:t>Alice Johnson</w:t></w:r></w:p>
    <w:p><w:r><w:t>Lead Systems Architect</w:t></w:r></w:p>
    <w:p><w:r><w:t>alice.johnson@example.com</w:t></w:r></w:p>
    <w:p><w:r><w:t>+1 555 123 4567</w:t></w:r></w:p>
    <w:p><w:r><w:t>PROFESSIONAL SUMMARY</w:t></w:r></w:p>
    <w:p><w:r><w:t>Systems architect with expertise in cloud architecture and microservices.</w:t></w:r></w:p>
    <w:p><w:r><w:t>EXPERIENCE</w:t></w:r></w:p>
    <w:p><w:r><w:t>Principal Cloud Engineer</w:t></w:r></w:p>
    <w:p><w:r><w:t>SKILLS</w:t></w:r></w:p>
    <w:p><w:r><w:t>Kubernetes, Docker, Go, Python</w:t></w:r></w:p>
  </w:body>
</w:document>
''';

      // Prepend ZIP magic header `PK\x03\x04`
      final docxBytes = Uint8List.fromList([
        0x50, 0x4B, 0x03, 0x04,
        ...docxXmlWithTable.codeUnits,
      ]);

      final resume = await defaultParser.parseBytes(docxBytes, ext: 'docx');

      expect(resume.personalDetails?.fullName, equals('Alice Johnson'));
      expect(resume.personalDetails?.email, equals('alice.johnson@example.com'));
      expect(resume.skills.map((s) => s.name), contains('Kubernetes'));
    });

    test('Test 8 — OCR Email & Link Spacing Repair', () async {
      const ocrRawWithSpaces = '''
Bob Vance
Engineering Manager
bob.vance @ refrigeration.com
+1 555 987 6543
linkedin. com / in / bobvance

PROFESSIONAL SUMMARY
Experienced engineering manager with 10+ years leading hardware and software teams.

EXPERIENCE
VP of Refrigeration Operations
Vance Refrigeration
Managed cross-functional product development.

SKILLS
Leadership, Product Strategy, Agile
''';

      final resume = await defaultParser.parseText(ocrRawWithSpaces);

      expect(resume.personalDetails?.fullName, equals('Bob Vance'));
      expect(resume.personalDetails?.email, equals('bob.vance@refrigeration.com'));
      expect(resume.personalDetails?.linkedinUrl, contains('linkedin.com/in/bobvance'));
    });
  });
}
