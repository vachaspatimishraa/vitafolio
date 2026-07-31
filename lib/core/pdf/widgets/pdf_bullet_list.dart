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
                pw.Text(" • ", style: pw.TextStyle(fontSize: fontSize)),
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
