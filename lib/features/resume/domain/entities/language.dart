/// Pure Dart immutable entity representing a Language.
class Language {
  final String id;
  final String name;
  final String proficiencyLevel;

  const Language({
    required this.id,
    required this.name,
    required this.proficiencyLevel,
  });

  Language copyWith({
    String? id,
    String? name,
    String? proficiencyLevel,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          proficiencyLevel == other.proficiencyLevel;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ proficiencyLevel.hashCode;
}
