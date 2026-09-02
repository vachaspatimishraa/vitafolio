import 'package:isar/isar.dart';

part 'resume_model.g.dart';

@collection
class ResumeDbModel {
  Id? id; // Isar auto-increment ID

  late String title;
  bool? isTitleManuallySet;
  late String selectedTemplateId;
  String? fontFamily;

  PersonalDetailsModel? personalDetails;
  ProfessionalSummaryModel? summary;

  List<ExperienceModel>? experiences;
  List<ProjectDbModel>? projects;
  List<EducationModel>? educations;
  List<SkillModel>? skills;
  List<CertificationModel>? certifications;
  List<LanguageModel>? languages;

  late DateTime createdAt;
  late DateTime updatedAt;

  // We store the domain String ID as well to maintain consistency if needed
  String? domainId;
}

@embedded
class PersonalDetailsModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? address;
  String? jobTitle;
  String? website;
  String? linkedinUrl;
  String? githubUrl;
  String? profileImagePath;
}

@embedded
class ProfessionalSummaryModel {
  String? summaryText;
}

@embedded
class ExperienceModel {
  String? id;
  String? jobTitle;
  String? company;
  String? location;
  String? startDate;
  String? endDate;
  bool? isCurrentRole;
  String? description;
}

@embedded
class ProjectDbModel {
  String? id;
  String? name;
  String? role;
  String? description;
  List<String>? technologies;
  String? projectUrl;
  DateTime? startDate;
  DateTime? endDate;
  bool? isOngoing;
}

@embedded
class EducationModel {
  String? id;
  String? degree;
  String? fieldOfStudy;
  String? institution;
  String? location;
  String? startYear;
  String? endYear;
  bool? isCurrentlyStudying;
  String? grade;
  String? description;
}

@embedded
class SkillModel {
  String? id;
  String? name;
  String? level;
}

@embedded
class CertificationModel {
  String? id;
  String? name;
  String? organization;
  String? issueDate;
  String? expiryDate;
  String? credentialId;
}

@embedded
class LanguageModel {
  String? id;
  String? name;
  String? proficiencyLevel;
}

