/// Pure Dart immutable entity representing a Certification.
class Certification {
  final String id;
  final String name;
  final String organization;
  final String issueDate;
  final String? expiryDate;
  final String? credentialId;

  const Certification({
    required this.id,
    required this.name,
    required this.organization,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
  });

  Certification copyWith({
    String? id,
    String? name,
    String? organization,
    String? issueDate,
    String? expiryDate,
    String? credentialId,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      organization: organization ?? this.organization,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Certification &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          organization == other.organization &&
          issueDate == other.issueDate &&
          expiryDate == other.expiryDate &&
          credentialId == other.credentialId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      organization.hashCode ^
      issueDate.hashCode ^
      expiryDate.hashCode ^
      credentialId.hashCode;
}
