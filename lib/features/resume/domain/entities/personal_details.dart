/// Pure Dart immutable entity representing Personal Details.
class PersonalDetails {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? jobTitle;
  final String? website;
  final String? linkedinUrl;
  final String? githubUrl;

  final String? profileImagePath;

  const PersonalDetails({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.jobTitle,
    this.website,
    this.linkedinUrl,
    this.githubUrl,
    this.profileImagePath,
  });

  PersonalDetails copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? jobTitle,
    String? website,
    String? linkedinUrl,
    String? githubUrl,
    String? profileImagePath,
  }) {
    return PersonalDetails(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      jobTitle: jobTitle ?? this.jobTitle,
      website: website ?? this.website,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalDetails &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          address == other.address &&
          jobTitle == other.jobTitle &&
          website == other.website &&
          linkedinUrl == other.linkedinUrl &&
          githubUrl == other.githubUrl &&
          profileImagePath == other.profileImagePath;

  @override
  int get hashCode =>
      fullName.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      address.hashCode ^
      jobTitle.hashCode ^
      website.hashCode ^
      linkedinUrl.hashCode ^
      githubUrl.hashCode ^
      profileImagePath.hashCode;
}
