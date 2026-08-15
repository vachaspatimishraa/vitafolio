// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_model.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const EducationModelSchema = Schema(
  name: r'EducationModel',
  id: -8132313263457369463,
  properties: {
    r'degree': PropertySchema(
      id: 0,
      name: r'degree',
      type: IsarType.string,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'fieldOfStudy': PropertySchema(
      id: 2,
      name: r'fieldOfStudy',
      type: IsarType.string,
    ),
    r'grade': PropertySchema(
      id: 3,
      name: r'grade',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'isCurrentlyStudying': PropertySchema(
      id: 5,
      name: r'isCurrentlyStudying',
      type: IsarType.bool,
    ),
    r'school': PropertySchema(
      id: 6,
      name: r'school',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 7,
      name: r'startDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _educationModelEstimateSize,
  serialize: _educationModelSerialize,
  deserialize: _educationModelDeserialize,
  deserializeProp: _educationModelDeserializeProp,
);

int _educationModelEstimateSize(
  EducationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.degree;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fieldOfStudy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.grade;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.school;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _educationModelSerialize(
  EducationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.degree);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeString(offsets[2], object.fieldOfStudy);
  writer.writeString(offsets[3], object.grade);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isCurrentlyStudying);
  writer.writeString(offsets[6], object.school);
  writer.writeDateTime(offsets[7], object.startDate);
}

EducationModel _educationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EducationModel(
    degree: reader.readStringOrNull(offsets[0]),
    endDate: reader.readDateTimeOrNull(offsets[1]),
    fieldOfStudy: reader.readStringOrNull(offsets[2]),
    grade: reader.readStringOrNull(offsets[3]),
    id: reader.readStringOrNull(offsets[4]),
    isCurrentlyStudying: reader.readBoolOrNull(offsets[5]),
    school: reader.readStringOrNull(offsets[6]),
    startDate: reader.readDateTimeOrNull(offsets[7]),
  );
  return object;
}

P _educationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension EducationModelQueryFilter
    on QueryBuilder<EducationModel, EducationModel, QFilterCondition> {
  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'degree',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'degree',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'degree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'degree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'degree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'degree',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'degree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'degree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'degree',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'degree',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'degree',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      degreeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'degree',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      endDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      endDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDate',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      endDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      endDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      endDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      endDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fieldOfStudy',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fieldOfStudy',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fieldOfStudy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fieldOfStudy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fieldOfStudy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fieldOfStudy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fieldOfStudy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fieldOfStudy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fieldOfStudy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fieldOfStudy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fieldOfStudy',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      fieldOfStudyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fieldOfStudy',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'grade',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'grade',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'grade',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'grade',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      gradeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'grade',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition> idEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition> idBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      isCurrentlyStudyingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isCurrentlyStudying',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      isCurrentlyStudyingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isCurrentlyStudying',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      isCurrentlyStudyingEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCurrentlyStudying',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'school',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'school',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'school',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'school',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'school',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'school',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'school',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'school',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'school',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'school',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'school',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      schoolIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'school',
        value: '',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startDate',
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      startDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      startDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      startDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<EducationModel, EducationModel, QAfterFilterCondition>
      startDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EducationModelQueryObject
    on QueryBuilder<EducationModel, EducationModel, QFilterCondition> {}
