import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfSkillChip extends pw.StatelessWidget {
  final String skill;
  final PdfColor? color;

  PdfSkillChip(this.skill, {this.color});

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: color != null
            ? PdfColor(color!.red, color!.green, color!.blue, 0.15).flatten()
            : PdfColors.grey200,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: color ?? PdfColors.grey400, width: 0.5),
      ),
      child: pw.Text(
        skill,
        style: pw.TextStyle(fontSize: 9, color: color ?? PdfColors.black),
      ),
    );
  }
}
