import 'package:isar/isar.dart';

part 'project_model.g.dart';

@embedded
class ProjectModel {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  String? projectName;
  String? description;
  String? technologies;
  String? githubUrl;
  String? liveDemoUrl;

  ProjectModel({
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
    final model = ProjectModel(
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      githubUrl: githubUrl ?? this.githubUrl,
      liveDemoUrl: liveDemoUrl ?? this.liveDemoUrl,
    );
    model.id = id ?? this.id;
    return model;
  }
}
