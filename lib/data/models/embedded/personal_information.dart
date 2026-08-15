import 'package:isar/isar.dart';

part 'personal_information.g.dart';

@embedded
class PersonalInformation {
  String? fullName;
  String? jobTitle;
  String? email;
  String? phone;
  String? linkedIn;
  String? github;
  String? portfolioWebsite;
  String? profileImagePath;

  PersonalInformation({
    this.fullName,
    this.jobTitle,
    this.email,
    this.phone,
    this.linkedIn,
    this.github,
    this.portfolioWebsite,
    this.profileImagePath,
  });

  PersonalInformation copyWith({
    String? fullName,
    String? jobTitle,
    String? email,
    String? phone,
    String? linkedIn,
    String? github,
    String? portfolioWebsite,
    String? profileImagePath,
  }) {
    return PersonalInformation(
      fullName: fullName ?? this.fullName,
      jobTitle: jobTitle ?? this.jobTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      portfolioWebsite: portfolioWebsite ?? this.portfolioWebsite,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}
