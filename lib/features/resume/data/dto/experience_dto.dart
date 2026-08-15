/// Immutable Data Transfer Object for Experience.
class ExperienceDto {
  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final String startDate;
  final String? endDate;
  final bool isCurrentRole;
  final String description;

  const ExperienceDto({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.startDate,
    this.endDate,
    this.isCurrentRole = false,
    required this.description,
  });

  ExperienceDto copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    bool? isCurrentRole,
    String? description,
  }) {
    return ExperienceDto(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentRole: isCurrentRole ?? this.isCurrentRole,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrentRole': isCurrentRole,
      'description': description,
    };
  }

  factory ExperienceDto.fromJson(Map<String, dynamic> json) {
    return ExperienceDto(
      id: json['id'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      company: json['company'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String?,
      isCurrentRole: json['isCurrentRole'] as bool? ?? false,
      description: json['description'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          jobTitle == other.jobTitle &&
          company == other.company &&
          location == other.location &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          isCurrentRole == other.isCurrentRole &&
          description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      jobTitle.hashCode ^
      company.hashCode ^
      location.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      isCurrentRole.hashCode ^
      description.hashCode;
}
