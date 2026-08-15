/// Pure Dart immutable entity representing a Skill.
class Skill {
  final String id;
  final String name;
  final String? level;

  const Skill({
    required this.id,
    required this.name,
    this.level,
  });

  Skill copyWith({
    String? id,
    String? name,
    String? level,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Skill &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          level == other.level;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ level.hashCode;
}
