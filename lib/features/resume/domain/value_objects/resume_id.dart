/// Strongly typed immutable Value Object for Resume ID.
class ResumeId {
  final String value;

  const ResumeId(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ResumeId($value)';
}
