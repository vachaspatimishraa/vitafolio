/// Strongly typed immutable Value Object for Template ID.
class TemplateId {
  final String value;

  const TemplateId(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateId &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'TemplateId($value)';
}
