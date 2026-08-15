import 'package:vitafolio/features/resume/data/dto/certification_dto.dart';
import 'package:vitafolio/features/resume/data/dto/education_dto.dart';
import 'package:vitafolio/features/resume/data/dto/experience_dto.dart';
import 'package:vitafolio/features/resume/data/dto/language_dto.dart';
import 'package:vitafolio/features/resume/data/dto/personal_details_dto.dart';
import 'package:vitafolio/features/resume/data/dto/project_dto.dart';
import 'package:vitafolio/features/resume/data/dto/skill_dto.dart';

/// Immutable Data Transfer Object for complete Resume.
class ResumeDto {
  final String id;
  final String title;
  final String selectedTemplateId;
  final PersonalDetailsDto? personalDetails;
  final String? summaryText;
  final List<ExperienceDto> experiences;
  final List<ProjectDto> projects;
  final List<EducationDto> educations;
  final List<SkillDto> skills;
  final List<CertificationDto> certifications;
  final List<LanguageDto> languages;
  final String createdAt;
  final String updatedAt;

  const ResumeDto({
    required this.id,
    required this.title,
    required this.selectedTemplateId,
    this.personalDetails,
    this.summaryText,
    this.experiences = const [],
    this.projects = const [],
    this.educations = const [],
    this.skills = const [],
    this.certifications = const [],
    this.languages = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  ResumeDto copyWith({
    String? id,
    String? title,
    String? selectedTemplateId,
    PersonalDetailsDto? personalDetails,
    String? summaryText,
    List<ExperienceDto>? experiences,
    List<ProjectDto>? projects,
    List<EducationDto>? educations,
    List<SkillDto>? skills,
    List<CertificationDto>? certifications,
    List<LanguageDto>? languages,
    String? createdAt,
    String? updatedAt,
  }) {
    return ResumeDto(
      id: id ?? this.id,
      title: title ?? this.title,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      personalDetails: personalDetails ?? this.personalDetails,
      summaryText: summaryText ?? this.summaryText,
      experiences: experiences ?? this.experiences,
      projects: projects ?? this.projects,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'selectedTemplateId': selectedTemplateId,
      'personalDetails': personalDetails?.toJson(),
      'summaryText': summaryText,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills.map((e) => e.toJson()).toList(),
      'certifications': certifications.map((e) => e.toJson()).toList(),
      'languages': languages.map((e) => e.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ResumeDto.fromJson(Map<String, dynamic> json) {
    return ResumeDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      selectedTemplateId: json['selectedTemplateId'] as String? ?? '',
      personalDetails: json['personalDetails'] != null
          ? PersonalDetailsDto.fromJson(
              json['personalDetails'] as Map<String, dynamic>)
          : null,
      summaryText: json['summaryText'] as String?,
      experiences: (json['experiences'] as List<dynamic>?)
              ?.map((e) => ExperienceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ProjectDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      educations: (json['educations'] as List<dynamic>?)
              ?.map((e) => EducationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => SkillDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => CertificationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => LanguageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          selectedTemplateId == other.selectedTemplateId &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      selectedTemplateId.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

