import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/templates/widgets/pdf_preview_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PdfPreviewWidget Multipage Tests', () {
    pw.Document createTestPdf(int pageCount) {
      final pdf = pw.Document();
      for (int i = 0; i < pageCount; i++) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Center(
              child: pw.Text('Page ${i + 1}', style: const pw.TextStyle(fontSize: 32)),
            ),
          ),
        );
      }
      return pdf;
    }

    testWidgets('initializes PdfPreviewWidget without crashing', (tester) async {
      final pdf = createTestPdf(1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: PdfPreviewWidget(pdf: pdf),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(PdfPreviewWidget), findsOneWidget);
    });

    testWidgets('responsive container constraints work across multiple screen widths', (tester) async {
      final screenWidths = [320.0, 375.0, 412.0, 600.0, 768.0, 1024.0, 1280.0];
      final pdf = createTestPdf(2);

      for (final width in screenWidths) {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 650),
                    child: PdfPreviewWidget(pdf: pdf),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        expect(tester.takeException(), isNull, reason: 'Failed at width: $width');
      }
    });
  });
}
