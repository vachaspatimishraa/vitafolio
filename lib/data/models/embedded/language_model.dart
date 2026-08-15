import 'package:isar/isar.dart';
import 'package:vitafolio/data/models/enums/language_proficiency.dart';

part 'language_model.g.dart';

@embedded
class LanguageModel {
  String? id;
  String? language;

  @enumerated
  var proficiency = LanguageProficiency.beginner;

  LanguageModel({
    this.id,
    this.language,
    this.proficiency = LanguageProficiency.beginner,
  });

  LanguageModel copyWith({
    String? id,
    String? language,
    LanguageProficiency? proficiency,
  }) {
    return LanguageModel(
      id: id ?? this.id,
      language: language ?? this.language,
      proficiency: proficiency ?? this.proficiency,
    );
  }
}
