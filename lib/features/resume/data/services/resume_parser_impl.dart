import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/services/pdf_raster_service.dart';
import 'package:vitafolio/features/resume/domain/services/resume_ocr_service.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

enum DocumentFormat {
  pdf,
  docx,
  doc,
  image,
  txt,
  unknown,
}

/// Production Resume Parser extracting structured domain entities from real resume files/text.
class ResumeParserImpl implements ResumeParser {
  final ResumeOcrService? _ocrService;
  final PdfRasterService? _pdfRasterService;

  const ResumeParserImpl({
    ResumeOcrService? ocrService,
    PdfRasterService? pdfRasterService,
  })  : _ocrService = ocrService,
        _pdfRasterService = pdfRasterService;

  @override
  Future<Resume> parseFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    final bytes = await file.readAsBytes();
    final ext = filePath.contains('.') ? filePath.split('.').last.toLowerCase() : '';
    return parseBytes(bytes, ext: ext);
  }

  Future<Resume> parseBytes(List<int> bytes, {required String ext}) async {
    if (bytes.isEmpty) {
      throw Exception('Selected file is empty.');
    }

    final docFormat = _detectDocumentFormat(bytes, ext);
    _debugLog('[FORMAT] Detected format: $docFormat (ext: $ext, size: ${bytes.length} bytes)');

    String rawText = '';

    switch (docFormat) {
      case DocumentFormat.doc:
        _debugLog('[DOC] DOC parser invoked. Result: UNSUPPORTED_LEGACY_FORMAT');
        throw Exception(
          'This DOC file could not be read reliably.\n\n'
          'Please convert the resume to PDF or DOCX and upload it again.',
        );

      case DocumentFormat.pdf:
        _debugLog('[PDF] Native extraction started');
        rawText = await _extractPdfText(bytes);
        _debugLog('[PDF] Native extraction result length: ${rawText.length}');
        if (rawText.trim().isEmpty) {
          _debugLog('Diagnostic State: PDF_NATIVE_TEXT_EMPTY');
        }
        break;

      case DocumentFormat.docx:
        _debugLog('[DOCX] Extraction started');
        rawText = _extractDocxText(bytes);
        _debugLog('[DOCX] Extracted text length: ${rawText.length}');
        break;

      case DocumentFormat.image:
        _debugLog('[IMAGE] Image format processing started');
        if (_ocrService != null) {
          _debugLog('[IMAGE] OCR started...');
          final ocrResult = await _ocrService.extractTextFromImageBytes(bytes);
          rawText = ocrResult ?? '';
          _debugLog('[IMAGE] OCR result length: ${rawText.length}');
        } else {
          _debugLog('Diagnostic State: OCR_NOT_INVOKED (ocrService is null)');
        }
        if (rawText.trim().isEmpty) {
          _debugLog('Diagnostic State: OCR_RETURNED_EMPTY');
          throw Exception(
            'We couldn\'t read text from this resume image.\n\n'
            'Please upload a clearer resume image or a text-based PDF/DOCX file.',
          );
        }
        break;

      case DocumentFormat.txt:
        rawText = utf8.decode(bytes, allowMalformed: true);
        _debugLog('[TXT] Text length: ${rawText.length}');
        break;

      case DocumentFormat.unknown:
        _debugLog('[FORMAT] UNKNOWN format detected. Aborting.');
        throw Exception(
          'The selected file appears to be invalid, unsupported, or corrupted.',
        );
    }

    // Attempt OCR fallback for PDF if native extraction produced empty or inadequate quality text
    final nativeQualityError = _validateRawTextQuality(rawText);
    if (docFormat == DocumentFormat.pdf && nativeQualityError != null) {
      _debugLog('[PDF] Native extraction inadequate or empty ($nativeQualityError). Rasterization started');
      if (_pdfRasterService != null && _ocrService != null) {
        final pageImages = await _pdfRasterService.renderPdfPagesToImages(bytes);
        _debugLog('[PDF] Page count: ${pageImages.length}');

        if (pageImages.isEmpty) {
          _debugLog('Diagnostic State: PDF_RASTER_EMPTY');
        }

        final ocrSb = StringBuffer();
        for (int i = 0; i < pageImages.length; i++) {
          final pageImg = pageImages[i];
          _debugLog('[PDF] Page raster ${i + 1} byte count: ${pageImg.length}');
          _debugLog('[PDF] OCR started for page ${i + 1}/${pageImages.length}');
          
          try {
            final pageText = await _ocrService.extractTextFromImageBytes(pageImg);
            final len = pageText?.length ?? 0;
            _debugLog('[PDF] Page ${i + 1} OCR result length: $len');

            if (pageText != null && pageText.trim().isNotEmpty) {
              ocrSb.writeln(pageText);
            } else {
              _debugLog('[PDF] Page ${i + 1} OCR returned empty string');
            }
          } catch (e, stack) {
            _debugLog('Diagnostic Error on Page ${i + 1} OCR: $e. Code: OCR_REQUEST_FAILED');
            _debugLog('$stack');
          }
        }
        final ocrText = ocrSb.toString().trim();
        _debugLog('[PDF] Combined OCR result length: ${ocrText.length}');

        if (ocrText.isNotEmpty) {
          rawText = ocrText;
        } else {
          _debugLog('Diagnostic State: OCR_RETURNED_EMPTY');
        }
      } else {
        _debugLog('Diagnostic State: OCR_NOT_INVOKED (_pdfRasterService or _ocrService is null)');
      }
    }

    // Quality gate on raw text
    final qualityError = _validateRawTextQuality(rawText, isImage: docFormat == DocumentFormat.image);
    if (qualityError != null) {
      _debugLog('[PARSER] Quality gate: FAIL (${qualityError.replaceAll('\n', ' ')})');
      throw Exception(
        'We couldn\'t read this resume.\n\n'
        'We tried extracting text and reading the document pages with OCR.\n\n'
        'Please try a clearer PDF/image or continue manually.',
      );
    }

    _debugLog('[PARSER] Quality gate: PASS');
    return parseText(rawText);
  }

  DocumentFormat _detectDocumentFormat(List<int> bytes, String ext) {
    // 1. Check extension first if explicit
    final cleanExt = ext.toLowerCase().replaceAll('.', '').trim();
    if (cleanExt == 'pdf') return DocumentFormat.pdf;
    if (cleanExt == 'docx') return DocumentFormat.docx;
    if (cleanExt == 'doc') return DocumentFormat.doc;
    if (cleanExt == 'png' || cleanExt == 'jpg' || cleanExt == 'jpeg' || cleanExt == 'webp') return DocumentFormat.image;
    if (cleanExt == 'txt') return DocumentFormat.txt;

    // 2. Check magic bytes
    if (bytes.length >= 4) {
      // PDF Signature: %PDF anywhere in first 1024 bytes (ISO 32000-1)
      final headerLimit = bytes.length < 1024 ? bytes.length : 1024;
      for (int i = 0; i <= headerLimit - 4; i++) {
        if (bytes[i] == 0x25 && bytes[i + 1] == 0x50 && bytes[i + 2] == 0x44 && bytes[i + 3] == 0x46) {
          return DocumentFormat.pdf;
        }
      }
      // PNG Signature: 89 50 4E 47
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
        return DocumentFormat.image;
      }
      // JPEG Signature: FF D8
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
        return DocumentFormat.image;
      }
      // WEBP Signature: RIFF....WEBP
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
          bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50) {
        return DocumentFormat.image;
      }
      // ZIP Signature (used by DOCX): 50 4B
      if (bytes[0] == 0x50 && bytes[1] == 0x4B) {
        return DocumentFormat.docx;
      }
      // OLE Compound Document (used by legacy DOC): D0 CF 11 E0
      if (bytes[0] == 0xD0 && bytes[1] == 0xCF && bytes[2] == 0x11 && bytes[3] == 0xE0) {
        return DocumentFormat.doc;
      }
    }

    return DocumentFormat.unknown;
  }

  /// Quality Gate: Ensures raw extracted text contains meaningful resume content.
  String? _validateRawTextQuality(String rawText, {bool isImage = false}) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      return 'We couldn\'t extract readable text from this resume.\n\nThis may be a scanned or image-only PDF. Please try uploading a text-based PDF/DOCX or enter your information manually.';
    }

    int alphaCount = 0;
    int digitCount = 0;
    int controlCount = 0;

    for (int i = 0; i < trimmed.length; i++) {
      final charCode = trimmed.codeUnitAt(i);
      if ((charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122)) {
        alphaCount++;
      } else if (charCode >= 48 && charCode <= 57) {
        digitCount++;
      } else if (charCode < 32 && charCode != 10 && charCode != 13 && charCode != 9) {
        controlCount++;
      }
    }

    final total = trimmed.length;
    final alphaRatio = alphaCount / total;
    final words = trimmed.split(RegExp(r'\s+')).where((w) => w.length >= 2).toList();
    final wordCount = words.length;

    // Check for section heading presence
    int sectionSignalCount = 0;
    final upperText = trimmed.toUpperCase();
    if (upperText.contains('SUMMARY') || upperText.contains('PROFILE') || upperText.contains('OBJECTIVE')) sectionSignalCount++;
    if (upperText.contains('EXPERIENCE') || upperText.contains('EMPLOYMENT') || upperText.contains('WORK')) sectionSignalCount++;
    if (upperText.contains('EDUCATION') || upperText.contains('ACADEMIC') || upperText.contains('DEGREE')) sectionSignalCount++;
    if (upperText.contains('SKILLS') || upperText.contains('TECHNOLOGIES') || upperText.contains('EXPERTISE')) sectionSignalCount++;

    // Check for contact candidates
    final hasEmail = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}').hasMatch(trimmed);
    final hasPhone = RegExp(r'(\+\d{1,4}[\s-]?)?\(?\d{2,5}\)?[\s-]?\d{3,4}[\s-]?\d{3,4}').hasMatch(trimmed);

    _debugLog('Quality stats — total: $total, alpha: $alphaCount (${(alphaRatio * 100).toStringAsFixed(1)}%), digits: $digitCount, words: $wordCount, sections: $sectionSignalCount, email: $hasEmail, phone: $hasPhone');

    final minTotal = isImage ? 10 : 15;
    final minWords = isImage ? 5 : 10;
    if (total < minTotal || wordCount < minWords) {
      return 'The extracted text is too short to construct a valid resume.';
    }

    // Reject short strings like "John 9876543210" if no section headers or contact information exist
    if (!isImage && wordCount < 15 && sectionSignalCount == 0 && !hasEmail && !hasPhone) {
      return 'The extracted text does not contain sufficient resume structure.';
    }

    if (alphaRatio < 0.20 || controlCount > (total * 0.10)) {
      return 'The file text appears corrupted or unreadable.\n\nPlease upload a valid text-based PDF or DOCX file.';
    }

    return null;
  }

  /// Extract readable text from PDF bytes.
  /// Decompresses /FlateDecode streams using zlib and parses uncompressed operators.
  Future<String> _extractPdfText(List<int> bytes) async {
    try {
      final sb = StringBuffer();

      // 1. Locate all stream...endstream byte boundaries
      final streamSlices = _findPdfStreamByteSlices(bytes);
      _debugLog('[PDF] Found ${streamSlices.length} stream objects');

      for (final streamSlice in streamSlices) {
        final decompressed = _decompressPdfStream(streamSlice);
        if (decompressed.isNotEmpty) {
          final streamStr = utf8.decode(decompressed, allowMalformed: true);
          final text = _extractTextFromPdfStream(streamStr);
          if (text.trim().isNotEmpty) {
            sb.writeln(text);
          }
        }
      }

      // 2. Also check uncompressed text strings outside streams or fallback for uncompressed PDFs
      if (sb.length < 50 && bytes.length <= 1024 * 1024) {
        final latin1Str = String.fromCharCodes(bytes);
        final tjReg = RegExp(r'\(([^)]+)\)\s*(?:Tj|\x27|\x22)');
        for (final m in tjReg.allMatches(latin1Str)) {
          final t = m.group(1);
          if (t != null && _isReadablePdfTextString(t)) {
            sb.write('${_decodePdfString(t)} ');
          }
        }
      }

      final result = sb.toString().trim();
      return _normalizeText(result);
    } catch (e) {
      _debugLog('Error extracting PDF text: $e');
      return '';
    }
  }

  /// Locates byte sublists for all streams in a PDF file.
  List<List<int>> _findPdfStreamByteSlices(List<int> bytes) {
    final slices = <List<int>>[];
    final n = bytes.length;
    int i = 0;

    // Pattern: 'stream' is [115, 116, 114, 101, 97, 109]
    while (i + 6 < n) {
      if (bytes[i] == 115 &&
          bytes[i + 1] == 116 &&
          bytes[i + 2] == 114 &&
          bytes[i + 3] == 101 &&
          bytes[i + 4] == 97 &&
          bytes[i + 5] == 109) {
        // Ensure 'stream' is a keyword, not part of another word (e.g. 'Downstream')
        if (i > 0) {
          final prev = bytes[i - 1];
          if ((prev >= 65 && prev <= 90) || (prev >= 97 && prev <= 122)) {
            i += 6;
            continue;
          }
        }

        // Skip whitespace after 'stream' (CR, LF, space, tab)
        int streamStart = i + 6;
        if (streamStart < n && bytes[streamStart] == 13) streamStart++;
        if (streamStart < n && bytes[streamStart] == 10) streamStart++;
        while (streamStart < n && (bytes[streamStart] == 32 || bytes[streamStart] == 9)) {
          streamStart++;
        }

        // Inspect preceding dictionary to check for images or declared direct length
        final dictStart = i > 400 ? i - 400 : 0;
        final precedingStr = String.fromCharCodes(bytes.sublist(dictStart, i));

        // Skip image streams (pure pixel data, not text)
        if (precedingStr.contains('/Subtype /Image') ||
            precedingStr.contains('/Subtype/Image') ||
            (precedingStr.contains('/Type /XObject') && precedingStr.contains('/Subtype /Image'))) {
          final endIdx = _findEndstream(bytes, streamStart, n);
          if (endIdx != -1) {
            i = endIdx + 9;
            continue;
          }
        }

        // Try reading declared direct /Length (must not be an indirect reference like /Length 12 0 R)
        int? declaredLength;
        final lenMatch = RegExp(r'/Length\s+(\d+)\b(?!\s+\d+\s+R)').firstMatch(precedingStr);
        if (lenMatch != null) {
          final parsed = int.tryParse(lenMatch.group(1)!);
          // Verify declared length by checking if 'endstream' exists at streamStart + parsed
          if (parsed != null && parsed > 0 && streamStart + parsed <= n) {
            int cs = streamStart + parsed;
            if (cs < n && bytes[cs] == 13) cs++;
            if (cs < n && bytes[cs] == 10) cs++;
            if (cs + 9 <= n &&
                bytes[cs] == 101 &&
                bytes[cs + 1] == 110 &&
                bytes[cs + 2] == 100 &&
                bytes[cs + 3] == 115 &&
                bytes[cs + 4] == 116 &&
                bytes[cs + 5] == 114 &&
                bytes[cs + 6] == 101 &&
                bytes[cs + 7] == 97 &&
                bytes[cs + 8] == 109) {
              declaredLength = parsed;
            }
          }
        }

        if (declaredLength != null) {
          slices.add(bytes.sublist(streamStart, streamStart + declaredLength));
          i = streamStart + declaredLength;
          continue;
        }

        // Fallback: Look for 'endstream' [101, 110, 100, 115, 116, 114, 101, 97, 109]
        final streamEnd = _findEndstream(bytes, streamStart, n);
        if (streamEnd > streamStart) {
          int trimmedEnd = streamEnd;
          while (trimmedEnd > streamStart &&
              (bytes[trimmedEnd - 1] == 13 || bytes[trimmedEnd - 1] == 10)) {
            trimmedEnd--;
          }
          if (trimmedEnd > streamStart) {
            slices.add(bytes.sublist(streamStart, trimmedEnd));
          }
          i = streamEnd + 9;
          continue;
        }
      }
      i++;
    }

    return slices;
  }

  int _findEndstream(List<int> bytes, int start, int n) {
    int endSearch = start;
    while (endSearch + 9 <= n) {
      if (bytes[endSearch] == 101 &&
          bytes[endSearch + 1] == 110 &&
          bytes[endSearch + 2] == 100 &&
          bytes[endSearch + 3] == 115 &&
          bytes[endSearch + 4] == 116 &&
          bytes[endSearch + 5] == 114 &&
          bytes[endSearch + 6] == 101 &&
          bytes[endSearch + 7] == 97 &&
          bytes[endSearch + 8] == 109) {
        return endSearch;
      }
      endSearch++;
    }
    return -1;
  }

  /// Attempts to decompress PDF stream with zlib or ZLibDecoder; falls back to raw bytes.
  List<int> _decompressPdfStream(List<int> streamBytes) {
    if (streamBytes.isEmpty) return streamBytes;
    try {
      return zlib.decode(streamBytes);
    } catch (_) {
      try {
        return ZLibDecoder().decodeBytes(streamBytes);
      } catch (_) {
        return streamBytes;
      }
    }
  }

  String _decodePdfString(String input) {
    var s = input;
    s = s.replaceAllMapped(RegExp(r'\\([0-7]{1,3})'), (m) {
      final octal = int.tryParse(m.group(1)!, radix: 8);
      return octal != null ? String.fromCharCode(octal) : '';
    });
    return s
        .replaceAll(r'\(', '(')
        .replaceAll(r'\)', ')')
        .replaceAll(r'\\', '\\')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r', '\r')
        .replaceAll(r'\t', '\t')
        .replaceAll(r'\b', '')
        .replaceAll(r'\f', '');
  }

  String _decodePdfHex(String hex) {
    final clean = hex.replaceAll(RegExp(r'\s'), '');
    final bytes = <int>[];
    for (int i = 0; i < clean.length; i += 2) {
      if (i + 1 < clean.length) {
        final b = int.tryParse(clean.substring(i, i + 2), radix: 16);
        if (b != null) bytes.add(b);
      } else {
        final b = int.tryParse('${clean[i]}0', radix: 16);
        if (b != null) bytes.add(b);
      }
    }
    if (bytes.isEmpty) return '';

    // Check for UTF-16BE BOM (FE FF)
    if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
      final chars = <int>[];
      for (int i = 2; i + 1 < bytes.length; i += 2) {
        chars.add((bytes[i] << 8) | bytes[i + 1]);
      }
      return String.fromCharCodes(chars);
    }

    // Check for UTF-16BE without BOM (alternating zero bytes, e.g. 00 48 00 65)
    if (bytes.length >= 4 && bytes[0] == 0x00 && bytes[2] == 0x00) {
      final chars = <int>[];
      for (int i = 0; i + 1 < bytes.length; i += 2) {
        chars.add((bytes[i] << 8) | bytes[i + 1]);
      }
      return String.fromCharCodes(chars);
    }

    try {
      return utf8.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }

  bool _isReadablePdfTextString(String t) {
    final trimmed = t.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.startsWith('%') || trimmed.startsWith('/') || RegExp(r'^\d{12,}$').hasMatch(trimmed)) {
      return false;
    }
    return true;
  }

  String _extractTextFromPdfStream(String stream) {
    final sb = StringBuffer();
    // 1. Bracket TJ arrays: [ (str1) -10 (str2) ] TJ or [ <hex1> 20 <hex2> ] TJ
    final bracketReg = RegExp(r'\[\s*([\s\S]*?)\s*\]\s*TJ');

    for (final bMatch in bracketReg.allMatches(stream)) {
      final inner = bMatch.group(1) ?? '';
      final lineSb = StringBuffer();

      int offset = 0;
      while (offset < inner.length) {
        final code = inner.codeUnitAt(offset);

        // String: (...)
        if (code == 40 /* ( */) {
          int depth = 1;
          int pEnd = offset + 1;
          while (pEnd < inner.length && depth > 0) {
            final c = inner.codeUnitAt(pEnd);
            if (c == 92 /* \ */) {
              pEnd += 2;
              continue;
            }
            if (c == 40 /* ( */) depth++;
            if (c == 41 /* ) */) depth--;
            pEnd++;
          }
          if (pEnd - 1 > offset + 1) {
            final rawParen = inner.substring(offset + 1, pEnd - 1);
            final t = _decodePdfString(rawParen);
            if (_isReadablePdfTextString(t)) {
              lineSb.write(t);
            }
          }
          offset = pEnd;
          continue;
        }

        // Hex: <...>
        if (code == 60 /* < */) {
          final hEnd = inner.indexOf('>', offset + 1);
          if (hEnd != -1) {
            final hex = inner.substring(offset + 1, hEnd);
            final t = _decodePdfHex(hex);
            if (_isReadablePdfTextString(t)) {
              lineSb.write(t);
            }
            offset = hEnd + 1;
            continue;
          }
        }

        // Spacing adjustment number (negative number introduces space, e.g. -120 or -250)
        if (code == 45 /* - */ || (code >= 48 && code <= 57)) {
          int numEnd = offset + 1;
          while (numEnd < inner.length) {
            final c = inner.codeUnitAt(numEnd);
            if ((c >= 48 && c <= 57) || c == 46 /* . */) {
              numEnd++;
            } else {
              break;
            }
          }
          final numVal = double.tryParse(inner.substring(offset, numEnd)) ?? 0.0;
          if (numVal <= -80 && lineSb.isNotEmpty && !lineSb.toString().endsWith(' ')) {
            lineSb.write(' ');
          }
          offset = numEnd;
          continue;
        }

        offset++;
      }

      final lineText = lineSb.toString().trim();
      if (lineText.isNotEmpty) {
        sb.writeln(lineText);
      }
    }

    // 2. Direct string Tj, ', "
    final tjReg = RegExp(r'\(([^)]*)\)\s*(?:Tj|\x27|\x22)');
    for (final m in tjReg.allMatches(stream)) {
      final t = _decodePdfString(m.group(1) ?? '');
      if (t.trim().isNotEmpty && _isReadablePdfTextString(t)) {
        sb.writeln(t.trim());
      }
    }

    // 3. Direct hex string <...> Tj
    final hexTjReg = RegExp(r'<([0-9a-fA-F]+)>\s*(?:Tj|\x27|\x22)');
    for (final m in hexTjReg.allMatches(stream)) {
      final t = _decodePdfHex(m.group(1) ?? '');
      if (t.trim().isNotEmpty && _isReadablePdfTextString(t)) {
        sb.writeln(t.trim());
      }
    }

    return sb.toString();
  }

  /// Extracts text from DOCX bytes, unpacking OpenXML zip archive and preserving paragraphs/tables.
  String _extractDocxText(List<int> bytes) {
    try {
      final xmlContents = <String>[];

      // 1. Try unpacking ZIP archive containing OpenXML document
      try {
        final archive = ZipDecoder().decodeBytes(bytes);

        // Extract header parts (often contains candidate name and contact info)
        for (final file in archive.files) {
          final fname = file.name.toLowerCase();
          if (fname.startsWith('word/header') && fname.endsWith('.xml')) {
            final content = file.content;
            if (content is List<int>) {
              xmlContents.add(utf8.decode(content, allowMalformed: true));
            } else if (content is String) {
              xmlContents.add(content);
            }
          }
        }

        // Extract main document body
        final docFile = archive.findFile('word/document.xml');
        if (docFile != null) {
          final content = docFile.content;
          if (content is List<int>) {
            xmlContents.add(utf8.decode(content, allowMalformed: true));
          } else if (content is String) {
            xmlContents.add(content);
          }
        }
      } catch (e) {
        _debugLog('[DOCX] ZipDecoder note: $e. Falling back to direct XML string analysis');
      }

      // Fallback if not a zip archive (e.g. uncompressed raw xml string)
      if (xmlContents.isEmpty) {
        xmlContents.add(String.fromCharCodes(bytes));
      }

      final sb = StringBuffer();

      // OpenXML regex patterns (using [\s\S]*? to span multiple lines)
      final wtReg = RegExp(r'<w:t[^>]*>([\s\S]*?)</w:t>');
      final blockReg = RegExp(r'<(?:w:p|w:tc)[^>]*>([\s\S]*?)</(?:w:p|w:tc)>');
      final brReg = RegExp(r'<w:br[^>]*/>');
      final tabReg = RegExp(r'<w:tab[^>]*/>');

      for (final rawXml in xmlContents) {
        for (final blockMatch in blockReg.allMatches(rawXml)) {
          var blockXml = blockMatch.group(1) ?? '';
          blockXml = blockXml.replaceAll(brReg, '\n');
          blockXml = blockXml.replaceAll(tabReg, '\t');

          final lineSb = StringBuffer();
          for (final tMatch in wtReg.allMatches(blockXml)) {
            final textNode = tMatch.group(1) ?? '';
            lineSb.write(_decodeXmlEntities(textNode));
          }

          final lineText = lineSb.toString().trim();
          if (lineText.isNotEmpty) {
            sb.writeln(lineText);
          }
        }

        if (sb.isEmpty) {
          for (final m in wtReg.allMatches(rawXml)) {
            final text = _decodeXmlEntities(m.group(1) ?? '').trim();
            if (text.isNotEmpty) {
              sb.writeln(text);
            }
          }
        }
      }

      return _normalizeText(sb.toString());
    } catch (e) {
      _debugLog('[DOCX] Extraction error: $e');
      return '';
    }
  }

  String _decodeXmlEntities(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'");
  }

  /// Advanced text normalization layer repairing OCR artifacts, email spacing, phone formats, and multiline symbols.
  String _normalizeText(String input) {
    var cleaned = input
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .replaceAll(RegExp(r'[ \t]+'), ' ');

    // 1. Repair OCR email spacing (e.g. `john.smith @ gmail.com` -> `john.smith@gmail.com`)
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'([a-zA-Z0-9._%+-]+)\s*@\s*([a-zA-Z0-9.-]+)\s*\.\s*([a-zA-Z]{2,})'),
      (match) => '${match[1]}@${match[2]}.${match[3]}',
    );

    // 2. Repair OCR LinkedIn / GitHub URL spacing (e.g. `linkedin. com / in / username` -> `linkedin.com/in/username`)
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'linkedin\s*\.\s*com\s*\/\s*in\s*\/\s*([a-zA-Z0-9_-]+)', caseSensitive: false),
      (m) => 'linkedin.com/in/${m[1]}',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'github\s*\.\s*com\s*\/\s*([a-zA-Z0-9_-]+)', caseSensitive: false),
      (m) => 'github.com/${m[1]}',
    );

    return cleaned
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .join('\n');
  }

  @override
  Future<Resume> parseText(String rawText) async {
    final cleanText = _normalizeText(rawText);
    _debugLog('Parsing normalized text. Character count: ${cleanText.length}');

    final personal = _extractPersonalDetails(cleanText);
    final summaryStr = _extractSummary(cleanText);
    final summaryObj = summaryStr.trim().isNotEmpty
        ? ProfessionalSummary(summaryText: summaryStr.trim())
        : null;
    final experiences = _extractExperiences(cleanText);
    final educations = _extractEducations(cleanText);
    final projects = _extractProjects(cleanText);
    final skills = _extractSkills(cleanText);
    final certs = _extractCertifications(cleanText);
    final languages = _extractLanguages(cleanText);

    // Minimum Parse Quality check: Ensure at least one strong field is present
    final hasValidName = personal.fullName.isNotEmpty;
    final hasValidEmail = personal.email.isNotEmpty;
    final hasValidPhone = personal.phoneNumber.isNotEmpty;
    final hasSummary = summaryObj != null;
    final hasExperiences = experiences.isNotEmpty;
    final hasEducation = educations.isNotEmpty;
    final hasSkills = skills.isNotEmpty;

    final strongFieldCount = (hasValidName ? 1 : 0) +
        (hasValidEmail ? 1 : 0) +
        (hasValidPhone ? 1 : 0) +
        (hasSummary ? 1 : 0) +
        (hasExperiences ? 1 : 0) +
        (hasEducation ? 1 : 0) +
        (hasSkills ? 1 : 0);

    if (strongFieldCount == 0) {
      throw Exception(
        'We couldn\'t reliably extract structured resume information from this document.\n\n'
        'Please upload a clearer PDF/DOCX file or enter your information manually.',
      );
    }

    final jobRoleStr = personal.jobTitle;
    final title = (jobRoleStr != null && jobRoleStr.isNotEmpty)
        ? jobRoleStr
        : (personal.fullName.isNotEmpty
            ? '${personal.fullName}\'s Resume'
            : 'Imported Resume');

    return Resume(
      id: const ResumeId(''),
      title: title,
      selectedTemplateId: const TemplateId('ats'),
      personalDetails: personal,
      summary: summaryObj,
      experiences: experiences,
      educations: educations,
      projects: projects,
      skills: skills,
      certifications: certs,
      languages: languages,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  PersonalDetails _extractPersonalDetails(String text) {
    // Valid Email Regex
    final emailReg = RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    
    // Strict Phone Regex — match valid formats like +91 9876543210, +1 (555) 019-2834, 9876543210.
    // Rejects long arbitrary numbers like 3247687638375438.
    final phoneReg = RegExp(r'(\+\d{1,4}[\s-]?)?\(?\d{2,5}\)?[\s-]?\d{3,4}[\s-]?\d{3,4}');

    final linkedinReg = RegExp(r'linkedin\.com\/in\/[a-zA-Z0-9_-]+', caseSensitive: false);
    final githubReg = RegExp(r'github\.com\/[a-zA-Z0-9_-]+', caseSensitive: false);

    final emailMatch = emailReg.firstMatch(text)?.group(0) ?? '';
    
    String phoneMatch = '';
    for (final m in phoneReg.allMatches(text)) {
      final cand = m.group(0)?.trim() ?? '';
      final digitsOnly = cand.replaceAll(RegExp(r'\D'), '');
      // Valid phone length should be between 7 and 14 digits. Reject strings like 3247687638375438 (16 digits).
      if (digitsOnly.length >= 7 && digitsOnly.length <= 14) {
        phoneMatch = cand;
        break;
      }
    }

    final linkedinMatch = linkedinReg.firstMatch(text)?.group(0) ?? '';
    final githubMatch = githubReg.firstMatch(text)?.group(0) ?? '';

    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    String fullName = '';
    String jobTitle = '';

    for (int i = 0; i < lines.length && i < 6; i++) {
      final line = lines[i];
      if (line.contains('@') ||
          line.contains('http') ||
          line.contains('github') ||
          line.contains('linkedin') ||
          _isSectionHeader(line)) {
        continue;
      }

      if (_isValidNameCandidate(line)) {
        if (fullName.isEmpty) {
          fullName = line;
        } else if (jobTitle.isEmpty && _isValidJobTitleCandidate(line)) {
          jobTitle = line;
          break;
        }
      }
    }

    return PersonalDetails(
      fullName: fullName,
      jobTitle: jobTitle,
      email: emailMatch,
      phoneNumber: phoneMatch,
      address: '',
      linkedinUrl: linkedinMatch.isNotEmpty ? 'https://$linkedinMatch' : '',
      githubUrl: githubMatch.isNotEmpty ? 'https://$githubMatch' : '',
      website: '',
    );
  }

  bool _isValidNameCandidate(String str) {
    if (str.isEmpty || str.length > 55) return false;
    if (str.contains('@') || str.contains('http') || str.contains('%') || str.contains('{') || str.contains('}')) {
      return false;
    }
    // Reject lines that are purely digits or contains long digit sequences (>6 digits)
    if (RegExp(r'\d{6,}').hasMatch(str)) return false;

    final cleanAlpha = str.replaceAll(RegExp(r'[^a-zA-Z\s._-]'), '').trim();
    if (cleanAlpha.length < 2) return false;

    return true;
  }

  bool _isValidJobTitleCandidate(String str) {
    if (str.isEmpty || str.length > 55) return false;
    if (str.contains('@') || str.contains('http') || str.contains('%')) return false;
    final digitCount = str.replaceAll(RegExp(r'\D'), '').length;
    return digitCount <= 3;
  }

  bool _isSectionHeader(String line) {
    final upper = line.toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '').trim();
    return upper == 'SUMMARY' ||
        upper == 'PROFESSIONAL SUMMARY' ||
        upper == 'PROFILE' ||
        upper == 'CAREER OBJECTIVE' ||
        upper == 'OBJECTIVE' ||
        upper == 'EXPERIENCE' ||
        upper == 'WORK EXPERIENCE' ||
        upper == 'EMPLOYMENT' ||
        upper == 'EMPLOYMENT HISTORY' ||
        upper == 'WORK HISTORY' ||
        upper == 'EDUCATION' ||
        upper == 'ACADEMIC BACKGROUND' ||
        upper == 'SKILLS' ||
        upper == 'TECHNICAL SKILLS' ||
        upper == 'CORE SKILLS' ||
        upper == 'CORE COMPETENCIES' ||
        upper == 'ADDITIONAL STRENGTHS' ||
        upper == 'STRENGTHS' ||
        upper == 'AREAS OF EXPERTISE' ||
        upper == 'PROJECTS' ||
        upper == 'KEY PROJECTS' ||
        upper == 'CERTIFICATIONS' ||
        upper == 'CERTIFICATES' ||
        upper == 'LICENSES' ||
        upper == 'LANGUAGES';
  }

  String _extractSummary(String text) {
    final summaryReg = RegExp(
      r'(?:SUMMARY|PROFESSIONAL SUMMARY|PROFILE SUMMARY|CAREER SUMMARY|PROFILE|ABOUT ME|CAREER OBJECTIVE|OBJECTIVE)\s*[:\n]+([\s\S]*?)(?=\n\s*(?:EXPERIENCE|WORK EXPERIENCE|EMPLOYMENT|EDUCATION|SKILLS|TECHNICAL SKILLS|PROJECTS|CERTIFICATIONS|LANGUAGES)\b|$)',
      caseSensitive: false,
    );
    final match = summaryReg.firstMatch(text);
    if (match != null) {
      final body = match.group(1) ?? '';
      return body.replaceAll('\n', ' ').trim();
    }
    return '';
  }

  List<Experience> _extractExperiences(String text) {
    final expReg = RegExp(
      r'(?:EXPERIENCE|WORK EXPERIENCE|PROFESSIONAL EXPERIENCE|EMPLOYMENT HISTORY|CAREER HISTORY)[\s\S]*?(?=\n\s*(?:EDUCATION|ACADEMIC BACKGROUND|SKILLS|TECHNICAL SKILLS|PROJECTS|KEY PROJECTS|CERTIFICATIONS|LICENSES|LANGUAGES)\b|$)',
      caseSensitive: false,
    );
    final match = expReg.firstMatch(text);
    if (match == null) return [];

    final block = match.group(0) ?? '';
    final lines = block.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (lines.length <= 1) return [];

    final list = <Experience>[];
    String currentTitle = '';
    String currentCompany = '';
    String currentDesc = '';

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i];
      final isRoleLine = RegExp(
        r'(developer|engineer|manager|lead|specialist|architect|designer|consultant|analyst|intern|administrator|director|executive|programmer|officer|scientist|associate|coordinator|head|assistant)',
        caseSensitive: false,
      ).hasMatch(line) || (currentTitle.isEmpty && line.length < 60 && !line.startsWith('•') && !line.startsWith('-'));

      if (isRoleLine && line.length < 60) {
        if (currentTitle.isNotEmpty && (currentCompany.isNotEmpty || currentDesc.isNotEmpty)) {
          list.add(Experience(
            id: 'exp_${list.length + 1}',
            jobTitle: currentTitle,
            company: currentCompany,
            location: '',
            startDate: '',
            endDate: '',
            description: currentDesc.trim(),
          ));
        }
        currentTitle = line;
        currentCompany = '';
        currentDesc = '';
      } else if (currentCompany.isEmpty && currentTitle.isNotEmpty && line.length < 60) {
        currentCompany = line;
      } else {
        currentDesc += '\n$line';
      }
    }

    if (currentTitle.isNotEmpty && (currentCompany.isNotEmpty || currentDesc.isNotEmpty)) {
      list.add(Experience(
        id: 'exp_${list.length + 1}',
        jobTitle: currentTitle,
        company: currentCompany,
        location: '',
        startDate: '',
        endDate: '',
        description: currentDesc.trim(),
      ));
    }

    return list;
  }

  List<Education> _extractEducations(String text) {
    final eduReg = RegExp(
      r'(?:EDUCATION|ACADEMIC BACKGROUND|EDUCATIONAL QUALIFICATION|EDUCATION & TRAINING)[\s\S]*?(?=\n\s*(?:SKILLS|TECHNICAL SKILLS|PROJECTS|KEY PROJECTS|CERTIFICATIONS|LICENSES|LANGUAGES|EXPERIENCE)\b|$)',
      caseSensitive: false,
    );
    final match = eduReg.firstMatch(text);
    if (match == null) return [];

    final lines = match.group(0)!.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (lines.length <= 1) return [];

    final list = <Education>[];
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i];
      final isDegree = RegExp(
        r'(bachelor|master|b\.tech|m\.tech|b\.s|b\.a|degree|phd|diploma|b\.e|m\.e|b\.sc|m\.sc|mba)',
        caseSensitive: false,
      ).hasMatch(line) || (list.isEmpty && line.length < 80 && !line.startsWith('•') && !line.startsWith('-'));

      if (isDegree && line.length < 80) {
        list.add(Education(
          id: 'edu_${list.length + 1}',
          degree: line,
          fieldOfStudy: '',
          institution: (i + 1 < lines.length && lines[i + 1].length < 80) ? lines[i + 1] : '',
          location: '',
          startYear: '',
          endYear: '',
        ));
      }
    }
    return list;
  }

  List<Project> _extractProjects(String text) {
    final projReg = RegExp(
      r'(?:PROJECTS|KEY PROJECTS|SELECTED PROJECTS|ACADEMIC PROJECTS|PERSONAL PROJECTS)[\s\S]*?(?=\n\s*(?:SKILLS|TECHNICAL SKILLS|CERTIFICATIONS|LICENSES|LANGUAGES|EDUCATION|EXPERIENCE)\b|$)',
      caseSensitive: false,
    );
    final match = projReg.firstMatch(text);
    if (match == null) return [];

    final lines = match.group(0)!.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (lines.length <= 1) return [];

    final list = <Project>[];
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (line.length < 60 && !line.startsWith('•') && !line.startsWith('-')) {
        list.add(Project(
          id: 'proj_${list.length + 1}',
          name: line,
          role: '',
          description: i + 1 < lines.length ? lines[i + 1] : '',
        ));
      }
    }
    return list;
  }

  List<Skill> _extractSkills(String text) {
    final lines = text.split('\n').map((l) => l.trim()).toList();
    int startIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      final lineUpper = lines[i].toUpperCase().replaceAll(RegExp(r'[^A-Z\s]'), '').trim();
      if (lineUpper == 'SKILLS' ||
          lineUpper == 'TECHNICAL SKILLS' ||
          lineUpper == 'CORE SKILLS' ||
          lineUpper == 'CORE COMPETENCIES' ||
          lineUpper == 'ADDITIONAL STRENGTHS' ||
          lineUpper == 'STRENGTHS' ||
          lineUpper == 'KEY STRENGTHS' ||
          lineUpper == 'AREAS OF EXPERTISE' ||
          lineUpper.startsWith('SKILLS')) {
        startIndex = i + 1;
        break;
      }
    }
    if (startIndex == -1 || startIndex >= lines.length) return [];

    final skillNames = <String>[];
    for (int i = startIndex; i < lines.length; i++) {
      final line = lines[i];
      if (line.isEmpty) continue;
      if (_isSectionHeader(line)) {
        break;
      }
      final parts = line.split(RegExp(r'[,•|;\t]'));
      for (final p in parts) {
        final cleaned = p.trim();
        if (cleaned.isNotEmpty && cleaned.length < 50 && !skillNames.contains(cleaned)) {
          skillNames.add(cleaned);
        }
      }
    }

    return skillNames.map((s) => Skill(id: 'skill_${skillNames.indexOf(s) + 1}', name: s)).toList();
  }

  List<Certification> _extractCertifications(String text) {
    final certReg = RegExp(
      r'(?:CERTIFICATIONS|CERTIFICATES|LICENSES|CERTIFICATIONS & LICENSES)[\s\S]*?(?=\n\s*(?:LANGUAGES|SKILLS|PROJECTS|EDUCATION|EXPERIENCE)\b|$)',
      caseSensitive: false,
    );
    final match = certReg.firstMatch(text);
    if (match == null) return [];

    final lines = match.group(0)!.split('\n').sublist(1).map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final list = <Certification>[];
    for (final line in lines) {
      if (line.isNotEmpty && line.length < 80) {
        list.add(Certification(
          id: 'cert_${list.length + 1}',
          name: line,
          organization: '',
          issueDate: '',
        ));
      }
    }
    return list;
  }

  List<Language> _extractLanguages(String text) {
    final langReg = RegExp(r'(?:LANGUAGES|LANGUAGE SKILLS)[\s\S]*$', caseSensitive: false);
    final match = langReg.firstMatch(text);
    if (match == null) return [];

    final lines = match.group(0)!.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    if (lines.length <= 1) return [];

    final list = <Language>[];
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i];
      if (line.isNotEmpty && line.length < 40) {
        final parts = line.split(RegExp(r'[-—:]'));
        final name = parts.first.trim();
        final prof = parts.length > 1 ? parts[1].trim() : 'Proficient';
        list.add(Language(
          id: 'lang_${list.length + 1}',
          name: name,
          proficiencyLevel: prof,
        ));
      }
    }
    return list;
  }

  void _debugLog(String msg) {
    if (kDebugMode) {
      // Print debug logs in debug mode only
      print('[ResumeParserImpl] $msg');
    }
  }
}
