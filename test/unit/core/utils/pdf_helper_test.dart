import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/utils/pdf_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        return '.';
      },
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/share'),
      (MethodCall methodCall) async {
        return null;
      },
    );
  });

  group('PdfHelper', () {
    late pw.Document testPdf;

    setUp(() {
      testPdf = pw.Document();
      testPdf.addPage(pw.Page(build: (context) => pw.Text('Test PDF')));
    });

    test('convertToBytes should return non-empty bytes', () async {
      final bytes = await PdfHelper.convertToBytes(testPdf);

      expect(bytes, isNotNull);
      expect(bytes!.length, greaterThan(0));
    });

    test('convertToBytes should return valid PDF header', () async {
      final bytes = await PdfHelper.convertToBytes(testPdf);

      expect(bytes, isNotNull);
      final header = String.fromCharCodes(bytes!.take(4));
      expect(header, contains('%PDF'));
    });

    test('savePdf should save file successfully', () async {
      final filename = 'test_resume_${DateTime.now().millisecondsSinceEpoch}';
      final path = await PdfHelper.savePdf(testPdf, filename);

      expect(path, isNotNull);
      expect(path, contains(filename));
      expect(path, endsWith('.pdf'));
    });

    test('sharePdf should complete gracefully', () async {
      final result = await PdfHelper.sharePdf(testPdf, 'test_resume');
      expect(result, isA<bool>());
    });
  });
}
