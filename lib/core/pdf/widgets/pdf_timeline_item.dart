import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfTimelineItem extends pw.StatelessWidget {
  final String title;
  final String? subtitle;
  final String? date;
  final String? location;
  final String? description;

  PdfTimelineItem({
    required this.title,
    this.subtitle,
    this.date,
    this.location,
    this.description,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      title,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (subtitle != null)
                      pw.Text(
                        subtitle!,
                        style: pw.TextStyle(
                          fontStyle: pw.FontStyle.italic,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  if (date != null)
                    pw.Text(date!, style: const pw.TextStyle(fontSize: 10)),
                  if (location != null)
                    pw.Text(
                      location!,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
            ],
          ),
          if (description != null && description!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 4),
              child: pw.Text(
                description!,
                style: const pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.justify,
              ),
            ),
        ],
      ),
    );
  }
}
