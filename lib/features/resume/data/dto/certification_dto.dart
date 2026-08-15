/// Immutable Data Transfer Object for Certification.
class CertificationDto {
  final String id;
  final String name;
  final String organization;
  final String issueDate;
  final String? expiryDate;
  final String? credentialId;

  const CertificationDto({
    required this.id,
    required this.name,
    required this.organization,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
  });

  CertificationDto copyWith({
    String? id,
    String? name,
    String? organization,
    String? issueDate,
    String? expiryDate,
    String? credentialId,
  }) {
    return CertificationDto(
      id: id ?? this.id,
      name: name ?? this.name,
      organization: organization ?? this.organization,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organization': organization,
      'issueDate': issueDate,
      'expiryDate': expiryDate,
      'credentialId': credentialId,
    };
  }

  factory CertificationDto.fromJson(Map<String, dynamic> json) {
    return CertificationDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      issueDate: json['issueDate'] as String? ?? '',
      expiryDate: json['expiryDate'] as String?,
      credentialId: json['credentialId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertificationDto &&
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
