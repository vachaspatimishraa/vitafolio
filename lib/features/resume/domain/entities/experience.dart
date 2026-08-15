/// Pure Dart immutable entity representing Work Experience.
class Experience {
  final String id;
  final String jobTitle;
  final String company;
  final String location;
  final String startDate;
  final String? endDate;
  final bool isCurrentRole;
  final String description;

  const Experience({
    required this.id,
    required this.jobTitle,
    required this.company,
    required this.location,
    required this.startDate,
    this.endDate,
    this.isCurrentRole = false,
    required this.description,
  });

  Experience copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    bool? isCurrentRole,
    String? description,
  }) {
    return Experience(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Experience &&
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
