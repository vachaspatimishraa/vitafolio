import 'package:isar/isar.dart';

part 'professional_summary.g.dart';

@embedded
class ProfessionalSummary {
  String? summary;

  ProfessionalSummary({this.summary});

  ProfessionalSummary copyWith({String? summary}) {
    return ProfessionalSummary(summary: summary ?? this.summary);
  }
}
