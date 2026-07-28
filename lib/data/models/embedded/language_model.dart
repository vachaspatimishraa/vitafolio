import 'package:isar/isar.dart';
import '../enums/language_proficiency.dart';

part 'language_model.g.dart';

@embedded
class LanguageModel {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  String? language;
  
  @enumerated
  var proficiency = LanguageProficiency.beginner;

  LanguageModel({
    this.language,
  });

  LanguageModel copyWith({
    String? id,
    String? language,
    LanguageProficiency? proficiency,
  }) {
    final model = LanguageModel(
      language: language ?? this.language,
    );
    model.id = id ?? this.id;
    model.proficiency = proficiency ?? this.proficiency;
    return model;
  }
}
