import 'package:isar/isar.dart';

part 'education_model.g.dart';

@embedded
class EducationModel {
  String? id;
  String? school;
  String? degree;
  String? fieldOfStudy;
  String? grade;
  DateTime? startDate;
  DateTime? endDate;
  bool? isCurrentlyStudying;

  EducationModel({
    this.id,
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
    return EducationModel(
      id: id ?? this.id,
      school: school ?? this.school,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      grade: grade ?? this.grade,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyStudying: isCurrentlyStudying ?? this.isCurrentlyStudying,
    );
  }
}
