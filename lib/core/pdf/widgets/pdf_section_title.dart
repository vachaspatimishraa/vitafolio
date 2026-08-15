import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfSectionTitle extends pw.StatelessWidget {
  final String title;
  final PdfColor? color;

  PdfSectionTitle(this.title, {this.color});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: color ?? PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Divider(thickness: 1, color: color ?? PdfColors.black),
        pw.SizedBox(height: 8),
      ],
    );
  }
}
