import 'package:isar/isar.dart';
import '../enums/employment_type.dart';

part 'experience_model.g.dart';

@embedded
class ExperienceModel {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
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
    this.company,
    this.position,
    this.location,
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
    final model = ExperienceModel(
      company: company ?? this.company,
      position: position ?? this.position,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentlyWorking: isCurrentlyWorking ?? this.isCurrentlyWorking,
      description: description ?? this.description,
    );
    model.id = id ?? this.id;
    model.employmentType = employmentType ?? this.employmentType;
    return model;
  }
}
