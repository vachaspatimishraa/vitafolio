import 'package:isar/isar.dart';

part 'project_model.g.dart';

@embedded
class ProjectModel {
  String? id;
  String? projectName;
  String? description;
  String? technologies;
  String? githubUrl;
  String? liveDemoUrl;

  ProjectModel({
    this.id,
    this.projectName,
    this.description,
    this.technologies,
    this.githubUrl,
    this.liveDemoUrl,
  });

  ProjectModel copyWith({
    String? id,
    String? projectName,
    String? description,
    String? technologies,
    String? githubUrl,
    String? liveDemoUrl,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      githubUrl: githubUrl ?? this.githubUrl,
      liveDemoUrl: liveDemoUrl ?? this.liveDemoUrl,
    );
  }
}
