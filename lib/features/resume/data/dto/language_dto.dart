/// Immutable Data Transfer Object for Language.
class LanguageDto {
  final String id;
  final String name;
  final String proficiencyLevel;

  const LanguageDto({
    required this.id,
    required this.name,
    required this.proficiencyLevel,
  });

  LanguageDto copyWith({
    String? id,
    String? name,
    String? proficiencyLevel,
  }) {
    return LanguageDto(
      id: id ?? this.id,
      name: name ?? this.name,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'proficiencyLevel': proficiencyLevel,
    };
  }

  factory LanguageDto.fromJson(Map<String, dynamic> json) {
    return LanguageDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      proficiencyLevel: json['proficiencyLevel'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          proficiencyLevel == other.proficiencyLevel;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ proficiencyLevel.hashCode;
}
