import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/data/models/embedded/personal_information.dart';

class PdfHeader extends pw.StatelessWidget {
  final PersonalInformation info;
  final PdfColor? color;

  PdfHeader({required this.info, this.color});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          info.fullName ?? '',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: color ?? PdfColors.black,
          ),
        ),
        if (info.jobTitle != null && info.jobTitle!.isNotEmpty)
          pw.Text(
            info.jobTitle!,
            style: pw.TextStyle(
              fontSize: 16,
              color: color ?? PdfColors.grey700,
            ),
          ),
        pw.SizedBox(height: 10),
      ],
    );
  }
}
