/// Pure Dart immutable entity representing Professional Summary.
class ProfessionalSummary {
  final String summaryText;

  const ProfessionalSummary({
    required this.summaryText,
  });

  ProfessionalSummary copyWith({
    String? summaryText,
  }) {
    return ProfessionalSummary(
      summaryText: summaryText ?? this.summaryText,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionalSummary &&
          runtimeType == other.runtimeType &&
          summaryText == other.summaryText;

  @override
  int get hashCode => summaryText.hashCode;
}
