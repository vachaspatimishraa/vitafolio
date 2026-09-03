import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfBulletList extends pw.StatelessWidget {
  final List<String> items;
  final double fontSize;

  PdfBulletList({required this.items, this.fontSize = 10});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: items
          .map(
            (item) => pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: fontSize * 0.35,
                  height: fontSize * 0.35,
                  margin: pw.EdgeInsets.only(top: fontSize * 0.35, right: 6, left: 2),
                  decoration: const pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: PdfColors.black,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(item, style: pw.TextStyle(fontSize: fontSize)),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
