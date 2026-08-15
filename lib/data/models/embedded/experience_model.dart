import 'package:isar/isar.dart';
import 'package:vitafolio/data/models/enums/employment_type.dart';

part 'experience_model.g.dart';

@embedded
class ExperienceModel {
  String? id;
  String? company;
  String? position;
  String? location;

  @enumerated
  var employmentType = EmploymentType.fullTime;

  DateTime? startDate;
  DateTime? endDate;
  bool? isCurrentlyWorking;
  String? description;

  ExperienceModel({
    this.id,
    this.company,
    this.position,
    this.location,
    this.employmentType = EmploymentType.fullTime,
    this.startDate,
    this.endDate,
    this.isCurrentlyWorking,
    this.description,
  });

  ExperienceModel copyWith({
    String? id,
    String? company,
    String? position,
    String? location,
    EmploymentType? employmentType,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentlyWorking,
    String? description,
  }) {
    return ExperienceModel(
      id: id ?? this.id,
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      employmentType: employmentType ?? this.employmentType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyWorking: isCurrentlyWorking ?? this.isCurrentlyWorking,
      description: description ?? this.description,
    );
  }
}
