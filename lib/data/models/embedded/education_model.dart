import 'package:isar/isar.dart';

part 'education_model.g.dart';

@embedded
class EducationModel {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  String? school;
  String? degree;
  String? fieldOfStudy;
  String? grade;
  DateTime? startDate;
  DateTime? endDate;
  bool? isCurrentlyStudying;

  EducationModel({
    this.school,
    this.degree,
    this.fieldOfStudy,
    this.grade,
    this.startDate,
    this.endDate,
    this.isCurrentlyStudying,
  });

  EducationModel copyWith({
    String? id,
    String? school,
    String? degree,
    String? fieldOfStudy,
    String? grade,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyStudying,
  }) {
    final model = EducationModel(
      school: school ?? this.school,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      grade: grade ?? this.grade,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyStudying: isCurrentlyStudying ?? this.isCurrentlyStudying,
    );
    model.id = id ?? this.id;
    return model;
  }
}
