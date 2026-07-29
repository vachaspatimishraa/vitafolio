import 'package:pdf/widgets.dart' as pw;

class PdfContactRow extends pw.StatelessWidget {
  final String label;
  final String value;

  PdfContactRow({required this.label, required this.value});

  @override
  pw.Widget build(pw.Context context) {
    if (value.isEmpty) return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            "$label: ",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
