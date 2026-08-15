/// Placeholder pure Dart Data Model representing a Template.
class TemplateModel {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final bool isAtsFriendly;
  final bool isPremium;

  const TemplateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.isAtsFriendly = true,
    this.isPremium = false,
  });

  TemplateModel copyWith({
    String? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    bool? isAtsFriendly,
    bool? isPremium,
  }) {
    return TemplateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isAtsFriendly: isAtsFriendly ?? this.isAtsFriendly,
      isPremium: isPremium ?? this.isPremium,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemplateModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          thumbnailUrl == other.thumbnailUrl &&
          isAtsFriendly == other.isAtsFriendly &&
          isPremium == other.isPremium;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      thumbnailUrl.hashCode ^
      isAtsFriendly.hashCode ^
      isPremium.hashCode;
}
