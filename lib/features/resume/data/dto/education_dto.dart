/// Immutable Data Transfer Object for Education.
class EducationDto {
  final String id;
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String location;
  final String startYear;
  final String endYear;
  final bool isCurrentlyStudying;
  final String? grade;

  const EducationDto({
    required this.id,
    required this.degree,
    required this.fieldOfStudy,
    required this.institution,
    required this.location,
    required this.startYear,
    required this.endYear,
    this.isCurrentlyStudying = false,
    this.grade,
  });

  EducationDto copyWith({
    String? id,
    String? degree,
    String? fieldOfStudy,
    String? institution,
    String? location,
    String? startYear,
    String? endYear,
    bool? isCurrentlyStudying,
    String? grade,
  }) {
    return EducationDto(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      institution: institution ?? this.institution,
      location: location ?? this.location,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      isCurrentlyStudying: isCurrentlyStudying ?? this.isCurrentlyStudying,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'institution': institution,
      'location': location,
      'startYear': startYear,
      'endYear': endYear,
      'isCurrentlyStudying': isCurrentlyStudying,
      'grade': grade,
    };
  }

  factory EducationDto.fromJson(Map<String, dynamic> json) {
    return EducationDto(
      id: json['id'] as String? ?? '',
      degree: json['degree'] as String? ?? '',
      fieldOfStudy: json['fieldOfStudy'] as String? ?? '',
      institution: json['institution'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startYear: json['startYear'] as String? ?? '',
      endYear: json['endYear'] as String? ?? '',
      isCurrentlyStudying: json['isCurrentlyStudying'] as bool? ?? false,
      grade: json['grade'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          degree == other.degree &&
          fieldOfStudy == other.fieldOfStudy &&
          institution == other.institution &&
          location == other.location &&
          startYear == other.startYear &&
          endYear == other.endYear &&
          isCurrentlyStudying == other.isCurrentlyStudying &&
          grade == other.grade;

  @override
  int get hashCode =>
      id.hashCode ^
      degree.hashCode ^
      fieldOfStudy.hashCode ^
      institution.hashCode ^
      location.hashCode ^
      startYear.hashCode ^
      endYear.hashCode ^
      isCurrentlyStudying.hashCode ^
      grade.hashCode;
}
