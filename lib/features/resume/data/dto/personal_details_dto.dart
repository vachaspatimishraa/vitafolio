/// Immutable Data Transfer Object for Personal Details.
class PersonalDetailsDto {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? jobTitle;
  final String? website;
  final String? linkedinUrl;
  final String? githubUrl;

  const PersonalDetailsDto({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.jobTitle,
    this.website,
    this.linkedinUrl,
    this.githubUrl,
  });

  PersonalDetailsDto copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? jobTitle,
    String? website,
    String? linkedinUrl,
    String? githubUrl,
  }) {
    return PersonalDetailsDto(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      jobTitle: jobTitle ?? this.jobTitle,
      website: website ?? this.website,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'jobTitle': jobTitle,
      'website': website,
      'linkedinUrl': linkedinUrl,
      'githubUrl': githubUrl,
    };
  }

  factory PersonalDetailsDto.fromJson(Map<String, dynamic> json) {
    return PersonalDetailsDto(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      jobTitle: json['jobTitle'] as String?,
      website: json['website'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalDetailsDto &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          address == other.address &&
          jobTitle == other.jobTitle &&
          website == other.website &&
          linkedinUrl == other.linkedinUrl &&
          githubUrl == other.githubUrl;

  @override
  int get hashCode =>
      fullName.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      address.hashCode ^
      jobTitle.hashCode ^
      website.hashCode ^
      linkedinUrl.hashCode ^
      githubUrl.hashCode;
}
