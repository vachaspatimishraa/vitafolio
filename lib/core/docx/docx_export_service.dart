import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';

/// Production-ready service that generates Microsoft Word compatible `.docx`
/// files using OpenXML standards.
class DocxExportService {
  const DocxExportService();

  /// Generates a valid `.docx` file as binary bytes from a domain [Resume].
  Uint8List generateDocx(Resume resume) {
    final archive = Archive();

    // 1. [Content_Types].xml
    final contentTypesXml = _buildContentTypesXml();
    archive.addFile(
      ArchiveFile(
        '[Content_Types].xml',
        contentTypesXml.length,
        utf8.encode(contentTypesXml),
      ),
    );

    // 2. _rels/.rels
    final relsXml = _buildRelsXml();
    archive.addFile(
      ArchiveFile('_rels/.rels', relsXml.length, utf8.encode(relsXml)),
    );

    // 3. word/_rels/document.xml.rels
    final docRelsXml = _buildDocumentRelsXml();
    archive.addFile(
      ArchiveFile(
        'word/_rels/document.xml.rels',
        docRelsXml.length,
        utf8.encode(docRelsXml),
      ),
    );

    // 4. word/styles.xml
    final stylesXml = _buildStylesXml();
    archive.addFile(
      ArchiveFile(
        'word/styles.xml',
        stylesXml.length,
        utf8.encode(stylesXml),
      ),
    );

    // 5. word/document.xml
    final documentXml = _buildDocumentXml(resume);
    archive.addFile(
      ArchiveFile(
        'word/document.xml',
        documentXml.length,
        utf8.encode(documentXml),
      ),
    );

    // Encode to ZIP (.docx)
    final zipEncoder = ZipEncoder();
    final encoded = zipEncoder.encode(archive);
    return Uint8List.fromList(encoded ?? <int>[]);
  }

  String _buildContentTypesXml() {
    return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
        '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\n'
        '  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\n'
        '  <Default Extension="xml" ContentType="application/xml"/>\n'
        '  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>\n'
        '  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>\n'
        '</Types>';
  }

  String _buildRelsXml() {
    return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        '  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>\n'
        '</Relationships>';
  }

  String _buildDocumentRelsXml() {
    return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\n'
        '  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>\n'
        '</Relationships>';
  }

  String _buildStylesXml() {
    return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
        '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">\n'
        '  <w:docDefaults>\n'
        '    <w:rPrDefault>\n'
        '      <w:rPr>\n'
        '        <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Calibri"/>\n'
        '        <w:sz w:val="21"/>\n'
        '        <w:color w:val="222222"/>\n'
        '      </w:rPr>\n'
        '    </w:rPrDefault>\n'
        '    <w:pPrDefault>\n'
        '      <w:pPr>\n'
        '        <w:spacing w:after="120" w:line="260" w:lineRule="auto"/>\n'
        '      </w:pPr>\n'
        '    </w:pPrDefault>\n'
        '  </w:docDefaults>\n'
        '  <w:style w:type="paragraph" w:styleId="Heading1">\n'
        '    <w:name w:val="Heading 1"/>\n'
        '    <w:pPr>\n'
        '      <w:spacing w:before="240" w:after="80"/>\n'
        '      <w:pBdr>\n'
        '        <w:bottom w:val="single" w:sz="6" w:space="4" w:color="1B365D"/>\n'
        '      </w:pBdr>\n'
        '    </w:pPr>\n'
        '    <w:rPr>\n'
        '      <w:b/>\n'
        '      <w:color w:val="1B365D"/>\n'
        '      <w:sz w:val="24"/>\n'
        '    </w:rPr>\n'
        '  </w:style>\n'
        '  <w:style w:type="paragraph" w:styleId="Heading2">\n'
        '    <w:name w:val="Heading 2"/>\n'
        '    <w:pPr>\n'
        '      <w:spacing w:before="140" w:after="40"/>\n'
        '    </w:pPr>\n'
        '    <w:rPr>\n'
        '      <w:b/>\n'
        '      <w:color w:val="333333"/>\n'
        '      <w:sz w:val="22"/>\n'
        '    </w:rPr>\n'
        '  </w:style>\n'
        '</w:styles>';
  }

  String _buildDocumentXml(Resume resume) {
    final buffer = StringBuffer();
    buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    buffer.writeln(
      '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">',
    );
    buffer.writeln('<w:body>');

    final info = resume.personalDetails;
    final fullName = (info != null && info.fullName.trim().isNotEmpty)
        ? info.fullName.trim()
        : resume.title;
    final jobTitle = info?.jobTitle?.trim();

    // 1. Header: Full Name
    buffer.writeln('<w:p>');
    buffer.writeln('<w:pPr><w:jc w:val="center"/><w:spacing w:after="40"/></w:pPr>');
    buffer.writeln('<w:r>');
    buffer.writeln(
      '<w:rPr><w:b/><w:sz w:val="44"/><w:color w:val="1B365D"/></w:rPr>',
    );
    buffer.writeln('<w:t>${_escapeXml(fullName)}</w:t>');
    buffer.writeln('</w:r>');
    buffer.writeln('</w:p>');

    // 2. Job Title
    if (jobTitle != null && jobTitle.isNotEmpty) {
      buffer.writeln('<w:p>');
      buffer.writeln('<w:pPr><w:jc w:val="center"/><w:spacing w:after="60"/></w:pPr>');
      buffer.writeln('<w:r>');
      buffer.writeln(
        '<w:rPr><w:b/><w:sz w:val="24"/><w:color w:val="555555"/></w:rPr>',
      );
      buffer.writeln('<w:t>${_escapeXml(jobTitle)}</w:t>');
      buffer.writeln('</w:r>');
      buffer.writeln('</w:p>');
    }

    // 3. Contact Info
    final contactItems = <String>[
      if (info != null && info.phoneNumber.trim().isNotEmpty) info.phoneNumber.trim(),
      if (info != null && info.email.trim().isNotEmpty) info.email.trim(),
      if (info?.linkedinUrl?.trim().isNotEmpty == true) info!.linkedinUrl!.trim(),
      if (info?.githubUrl?.trim().isNotEmpty == true) info!.githubUrl!.trim(),
      if (info?.website?.trim().isNotEmpty == true) info!.website!.trim(),
    ];

    if (contactItems.isNotEmpty) {
      buffer.writeln('<w:p>');
      buffer.writeln('<w:pPr><w:jc w:val="center"/><w:spacing w:after="180"/></w:pPr>');
      buffer.writeln('<w:r>');
      buffer.writeln(
        '<w:rPr><w:sz w:val="19"/><w:color w:val="555555"/></w:rPr>',
      );
      buffer.writeln('<w:t>${_escapeXml(contactItems.join('   |   '))}</w:t>');
      buffer.writeln('</w:r>');
      buffer.writeln('</w:p>');
    }

    // 4. Professional Summary
    final summary = resume.summary?.summaryText.trim();
    if (summary != null && summary.isNotEmpty) {
      _writeHeading1(buffer, 'PROFESSIONAL SUMMARY');
      _writeParagraph(buffer, summary);
    }

    // 5. Work Experience
    if (resume.experiences.isNotEmpty) {
      _writeHeading1(buffer, 'WORK EXPERIENCE');
      for (final exp in resume.experiences) {
        final position = exp.jobTitle.trim();
        final company = exp.company.trim();
        final location = exp.location.trim();
        final dateRange = DateRangeFormatter.formatExperience(
          startDateStr: exp.startDate,
          endDateStr: exp.endDate,
          isCurrentRole: exp.isCurrentRole,
          separator: ' - ',
        );

        final headerLine = [
          if (position.isNotEmpty) position,
          if (company.isNotEmpty) company,
          if (location.isNotEmpty) location,
        ].join('  •  ');

        _writeHeading2(buffer, headerLine, rightText: dateRange);

        if (exp.description.trim().isNotEmpty) {
          final lines = exp.description.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              final cleanBullet = trimmed.replaceFirst(RegExp(r'^[\•\-]\s*'), '');
              _writeBulletItem(buffer, cleanBullet);
            }
          }
        }
      }
    }

    // 6. Projects
    if (resume.projects.isNotEmpty) {
      _writeHeading1(buffer, 'PROJECTS');
      for (final proj in resume.projects) {
        final name = proj.name.trim();
        final tech = proj.technologies.join(', ').trim();
        _writeHeading2(
          buffer,
          name,
          rightText: tech.isNotEmpty ? 'Tech: $tech' : null,
        );

        if (proj.description.trim().isNotEmpty) {
          final lines = proj.description.split('\n');
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.isNotEmpty) {
              final cleanBullet = trimmed.replaceFirst(RegExp(r'^[\•\-]\s*'), '');
              _writeBulletItem(buffer, cleanBullet);
            }
          }
        }
      }
    }

    // 7. Education
    if (resume.educations.isNotEmpty) {
      _writeHeading1(buffer, 'EDUCATION');
      for (final edu in resume.educations) {
        final school = edu.institution.trim();
        final degree = [
          if (edu.degree.trim().isNotEmpty) edu.degree.trim(),
          if (edu.fieldOfStudy.trim().isNotEmpty) edu.fieldOfStudy.trim(),
        ].join(' in ');
        final dateRange = DateRangeFormatter.formatEducation(
          startYear: edu.startYear,
          endYear: edu.endYear,
          isCurrentlyStudying: edu.isCurrentlyStudying,
          separator: ' - ',
        );

        _writeHeading2(
          buffer,
          degree.isNotEmpty ? '$degree, $school' : school,
          rightText: dateRange,
        );

        if (edu.grade != null && edu.grade!.trim().isNotEmpty) {
          _writeParagraph(buffer, 'Grade/GPA: ${edu.grade!.trim()}');
        }
      }
    }

    // 8. Skills
    if (resume.skills.isNotEmpty) {
      _writeHeading1(buffer, 'SKILLS');
      final skillNames = resume.skills.map((s) => s.name.trim()).join(', ');
      _writeParagraph(buffer, skillNames);
    }

    // 9. Certifications
    if (resume.certifications.isNotEmpty) {
      _writeHeading1(buffer, 'CERTIFICATIONS');
      for (final cert in resume.certifications) {
        final certName = cert.name.trim();
        final org = cert.organization.trim();
        final date = cert.issueDate.trim();
        final text = [
          if (certName.isNotEmpty) certName,
          if (org.isNotEmpty) org,
        ].join('  -  ');
        _writeBulletItem(
          buffer,
          date.isNotEmpty ? '$text ($date)' : text,
        );
      }
    }

    // 10. Languages
    if (resume.languages.isNotEmpty) {
      _writeHeading1(buffer, 'LANGUAGES');
      final langList = resume.languages.map((l) {
        final name = l.name.trim();
        final level = l.proficiencyLevel.trim();
        return level.isNotEmpty ? '$name ($level)' : name;
      }).join(', ');
      _writeParagraph(buffer, langList);
    }

    // Page Margins (A4)
    buffer.writeln(
      '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/></w:sectPr>',
    );
    buffer.writeln('</w:body>');
    buffer.writeln('</w:document>');

    return buffer.toString();
  }

  void _writeHeading1(StringBuffer buffer, String title) {
    buffer.writeln('<w:p>');
    buffer.writeln('<w:pPr><w:pStyle w:val="Heading1"/></w:pPr>');
    buffer.writeln('<w:r>');
    buffer.writeln('<w:t>${_escapeXml(title)}</w:t>');
    buffer.writeln('</w:r>');
    buffer.writeln('</w:p>');
  }

  void _writeHeading2(StringBuffer buffer, String title, {String? rightText}) {
    buffer.writeln('<w:p>');
    buffer.writeln('<w:pPr><w:pStyle w:val="Heading2"/></w:pPr>');
    buffer.writeln('<w:r>');
    buffer.writeln('<w:t>${_escapeXml(title)}</w:t>');
    buffer.writeln('</w:r>');
    if (rightText != null && rightText.isNotEmpty) {
      buffer.writeln('<w:r>');
      buffer.writeln(
        '<w:rPr><w:i/><w:sz w:val="18"/><w:color w:val="666666"/></w:rPr>',
      );
      buffer.writeln('<w:t>  (${_escapeXml(rightText)})</w:t>');
      buffer.writeln('</w:r>');
    }
    buffer.writeln('</w:p>');
  }

  void _writeParagraph(StringBuffer buffer, String text) {
    buffer.writeln('<w:p>');
    buffer.writeln('<w:r>');
    buffer.writeln('<w:t>${_escapeXml(text)}</w:t>');
    buffer.writeln('</w:r>');
    buffer.writeln('</w:p>');
  }

  void _writeBulletItem(StringBuffer buffer, String text) {
    buffer.writeln('<w:p>');
    buffer.writeln(
      '<w:pPr><w:ind w:left="360"/><w:spacing w:after="60"/></w:pPr>',
    );
    buffer.writeln('<w:r>');
    buffer.writeln('<w:rPr><w:b/></w:rPr>');
    buffer.writeln('<w:t>• </w:t>');
    buffer.writeln('</w:r>');
    buffer.writeln('<w:r>');
    buffer.writeln('<w:t>${_escapeXml(text)}</w:t>');
    buffer.writeln('</w:r>');
    buffer.writeln('</w:p>');
  }

  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
