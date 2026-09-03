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

  @ignore
  String? startYear;
  @ignore
  String? endYear;

  EducationModel({
    this.id,
    this.school,
    this.degree,
    this.fieldOfStudy,
    this.grade,
    this.startDate,
    this.endDate,
    this.isCurrentlyStudying,
    this.startYear,
    this.endYear,
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
