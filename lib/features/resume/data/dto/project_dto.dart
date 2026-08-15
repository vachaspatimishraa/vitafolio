import 'package:vitafolio/features/resume/domain/entities/project.dart';

/// Immutable Data Transfer Object for Project.
class ProjectDto {
  final String id;
  final String name;
  final String role;
  final String description;
  final List<String> technologies;
  final String projectUrl;
  final String? startDate;
  final String? endDate;
  final bool isOngoing;

  const ProjectDto({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    this.technologies = const [],
    this.projectUrl = '',
    this.startDate,
    this.endDate,
    this.isOngoing = false,
  });

  factory ProjectDto.fromDomain(Project domain) {
    return ProjectDto(
      id: domain.id,
      name: domain.name,
      role: domain.role,
      description: domain.description,
      technologies: domain.technologies,
      projectUrl: domain.projectUrl,
      startDate: domain.startDate?.toIso8601String(),
      endDate: domain.endDate?.toIso8601String(),
      isOngoing: domain.isOngoing,
    );
  }

  Project toDomain() {
    return Project(
      id: id,
      name: name,
      role: role,
      description: description,
      technologies: technologies,
      projectUrl: projectUrl,
      startDate: startDate != null ? DateTime.tryParse(startDate!) : null,
      endDate: endDate != null ? DateTime.tryParse(endDate!) : null,
      isOngoing: isOngoing,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'description': description,
      'technologies': technologies,
      'projectUrl': projectUrl,
      'startDate': startDate,
      'endDate': endDate,
      'isOngoing': isOngoing,
    };
  }

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      description: json['description'] as String? ?? '',
      technologies: (json['technologies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      projectUrl: json['projectUrl'] as String? ?? '',
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      isOngoing: json['isOngoing'] as bool? ?? false,
    );
  }
}
