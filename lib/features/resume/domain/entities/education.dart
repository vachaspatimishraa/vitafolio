/// Pure Dart immutable entity representing Education.
class Education {
  final String id;
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String location;
  final String startYear;
  final String endYear;
  final bool isCurrentlyStudying;
  final String? grade;
  final String? description;

  const Education({
    required this.id,
    required this.degree,
    required this.fieldOfStudy,
    required this.institution,
    required this.location,
    required this.startYear,
    required this.endYear,
    this.isCurrentlyStudying = false,
    this.grade,
    this.description,
  });

  Education copyWith({
    String? id,
    String? degree,
    String? fieldOfStudy,
    String? institution,
    String? location,
    String? startYear,
    String? endYear,
    bool? isCurrentlyStudying,
    String? grade,
    String? description,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      institution: institution ?? this.institution,
      location: location ?? this.location,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      isCurrentlyStudying: isCurrentlyStudying ?? this.isCurrentlyStudying,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Education &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          degree == other.degree &&
          fieldOfStudy == other.fieldOfStudy &&
          institution == other.institution &&
          location == other.location &&
          startYear == other.startYear &&
          endYear == other.endYear &&
          isCurrentlyStudying == other.isCurrentlyStudying &&
          grade == other.grade &&
          description == other.description;

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
      grade.hashCode ^
      description.hashCode;
}
