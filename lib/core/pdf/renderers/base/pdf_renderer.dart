import 'package:pdf/widgets.dart' as pw;
import '../../../../data/models/resume_model.dart';

abstract class PdfRenderer {
  Future<pw.Document> render(ResumeModel resume);
}
