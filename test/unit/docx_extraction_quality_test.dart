import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DOCX Extraction Quality & Structure Tests', () {
    test('DOCX with multiple runs, tables, and hyperlinks extracts cleanly without losing spaces or fields', () async {
      // Create an OpenXML DOCX archive in memory with:
      // 1. Multiple runs in a paragraph (e.g. Flutter + Developer with spaces)
      // 2. Table with columns (e.g. Job Title on left, Company / Date on right)
      // 3. Hyperlink with relationship target
      const docXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:body>
    <w:p>
      <w:r><w:t>Vikash</w:t></w:r>
      <w:r><w:t xml:space="preserve"> </w:t></w:r>
      <w:r><w:t>Chaurasiya</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>Flutter</w:t></w:r>
      <w:r><w:t xml:space="preserve"> Developer</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>vikash@example.com</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>+91 8188801329</w:t></w:r>
    </w:p>
    <w:p>
      <w:hyperlink r:id="rId1">
        <w:r><w:t>LinkedIn Profile</w:t></w:r>
      </w:hyperlink>
    </w:p>
    <w:p>
      <w:r><w:t>PROFESSIONAL SUMMARY</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>Experienced Flutter Developer proficient in Dart, Riverpod, and clean mobile architecture.</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>EXPERIENCE</w:t></w:r>
    </w:p>
    <w:tbl>
      <w:tr>
        <w:tc>
          <w:p><w:r><w:t>Mobile Application Engineer</w:t></w:r></w:p>
          <w:p><w:r><w:t>Tech Innovations Ltd</w:t></w:r></w:p>
          <w:p><w:r><w:t>Developed scalable enterprise mobile applications.</w:t></w:r></w:p>
        </w:tc>
        <w:tc>
          <w:p><w:r><w:t>2023 - Present</w:t></w:r></w:p>
        </w:tc>
      </w:tr>
    </w:tbl>
    <w:p>
      <w:r><w:t>EDUCATION</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>Bachelor of Technology in Computer Science</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>AKTU University</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>SKILLS</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>Flutter, Dart, Riverpod, Firebase, REST APIs, Git</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>PROJECTS</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>PrepMateAi — Career Platform</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>Full-stack mobile application featuring real-time resume parsing.</w:t></w:r>
    </w:p>
  </w:body>
</w:document>''';

      const relsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink" Target="https://linkedin.com/in/vikashchaurasiyafullstack" TargetMode="External"/>
</Relationships>''';

      final archive = Archive();
      final docBytes = utf8.encode(docXml);
      final relsBytes = utf8.encode(relsXml);
      archive.addFile(ArchiveFile('word/document.xml', docBytes.length, docBytes));
      archive.addFile(ArchiveFile('word/_rels/document.xml.rels', relsBytes.length, relsBytes));

      final zipBytes = ZipEncoder().encode(archive);
      expect(zipBytes, isNotNull);

      final parser = ResumeParserImpl();
      final resume = await parser.parseBytes(zipBytes!, ext: 'docx');

      expect(resume.personalDetails?.fullName, equals('Vikash Chaurasiya'));
      expect(resume.personalDetails?.jobTitle, equals('Flutter Developer'));
      expect(resume.personalDetails?.email, equals('vikash@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+91 8188801329'));
      expect(resume.personalDetails?.linkedinUrl, contains('linkedin.com/in/vikashchaurasiyafullstack'));
      expect(resume.summary?.summaryText, contains('Experienced Flutter Developer'));
      expect(resume.experiences.length, greaterThanOrEqualTo(1));
      expect(resume.experiences.first.jobTitle, contains('Mobile Application Engineer'));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.educations.first.degree, contains('Bachelor of Technology'));
      expect(resume.skills.length, greaterThanOrEqualTo(5));
      expect(resume.projects.length, greaterThanOrEqualTo(1));
      expect(resume.projects.first.name, contains('PrepMateAi'));
    });
  });
}
