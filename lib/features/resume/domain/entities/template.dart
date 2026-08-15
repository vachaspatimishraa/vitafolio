import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

/// Pure Dart immutable entity representing a Resume Template.
class ResumeTemplate {
  final TemplateId id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final bool isAtsFriendly;
  final bool isPremium;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    this.isAtsFriendly = true,
    this.isPremium = false,
  });

  ResumeTemplate copyWith({
    TemplateId? id,
    String? name,
    String? description,
    String? thumbnailUrl,
    bool? isAtsFriendly,
    bool? isPremium,
  }) {
    return ResumeTemplate(
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
      other is ResumeTemplate &&
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
