/// Immutable Data Transfer Object for Skill.
class SkillDto {
  final String id;
  final String name;
  final String? level;

  const SkillDto({
    required this.id,
    required this.name,
    this.level,
  });

  SkillDto copyWith({
    String? id,
    String? name,
    String? level,
  }) {
    return SkillDto(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
    };
  }

  factory SkillDto.fromJson(Map<String, dynamic> json) {
    return SkillDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      level: json['level'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillDto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          level == other.level;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ level.hashCode;
}
