import 'package:flutter/foundation.dart';

/// Pure Dart immutable entity representing a Project.
class Project {
  final String id;
  final String name;
  final String role;
  final String description;
  final List<String> technologies;
  final String projectUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isOngoing;

  const Project({
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

  Project copyWith({
    String? id,
    String? name,
    String? role,
    String? description,
    List<String>? technologies,
    String? projectUrl,
    DateTime? startDate,
    DateTime? endDate,
    bool? isOngoing,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      projectUrl: projectUrl ?? this.projectUrl,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isOngoing: isOngoing ?? this.isOngoing,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          role == other.role &&
          description == other.description &&
          listEquals(technologies, other.technologies) &&
          projectUrl == other.projectUrl &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          isOngoing == other.isOngoing;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      role.hashCode ^
      description.hashCode ^
      Object.hashAll(technologies) ^
      projectUrl.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      isOngoing.hashCode;
}
