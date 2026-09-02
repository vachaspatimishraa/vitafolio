// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_information.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PersonalInformationSchema = Schema(
  name: r'PersonalInformation',
  id: -722308265752307796,
  properties: {
    r'email': PropertySchema(
      id: 0,
      name: r'email',
      type: IsarType.string,
    ),
    r'fullName': PropertySchema(
      id: 1,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'github': PropertySchema(
      id: 2,
      name: r'github',
      type: IsarType.string,
    ),
    r'jobTitle': PropertySchema(
      id: 3,
      name: r'jobTitle',
      type: IsarType.string,
    ),
    r'linkedIn': PropertySchema(
      id: 4,
      name: r'linkedIn',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 5,
      name: r'phone',
      type: IsarType.string,
    ),
    r'portfolioWebsite': PropertySchema(
      id: 6,
      name: r'portfolioWebsite',
      type: IsarType.string,
    ),
    r'profileImagePath': PropertySchema(
      id: 7,
      name: r'profileImagePath',
      type: IsarType.string,
    )
  },
  estimateSize: _personalInformationEstimateSize,
  serialize: _personalInformationSerialize,
  deserialize: _personalInformationDeserialize,
  deserializeProp: _personalInformationDeserializeProp,
);

int _personalInformationEstimateSize(
  PersonalInformation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.fullName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.github;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.jobTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.linkedIn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.portfolioWebsite;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.profileImagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _personalInformationSerialize(
  PersonalInformation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.email);
  writer.writeString(offsets[1], object.fullName);
  writer.writeString(offsets[2], object.github);
  writer.writeString(offsets[3], object.jobTitle);
  writer.writeString(offsets[4], object.linkedIn);
  writer.writeString(offsets[5], object.phone);
  writer.writeString(offsets[6], object.portfolioWebsite);
  writer.writeString(offsets[7], object.profileImagePath);
}

PersonalInformation _personalInformationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalInformation(
    email: reader.readStringOrNull(offsets[0]),
    fullName: reader.readStringOrNull(offsets[1]),
    github: reader.readStringOrNull(offsets[2]),
    jobTitle: reader.readStringOrNull(offsets[3]),
    linkedIn: reader.readStringOrNull(offsets[4]),
    phone: reader.readStringOrNull(offsets[5]),
    portfolioWebsite: reader.readStringOrNull(offsets[6]),
    profileImagePath: reader.readStringOrNull(offsets[7]),
  );
  return object;
}

P _personalInformationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PersonalInformationQueryFilter on QueryBuilder<PersonalInformation,
    PersonalInformation, QFilterCondition> {
  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullName',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'fullName',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullName',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'github',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'github',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'github',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'github',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'github',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'github',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'github',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'github',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'github',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'github',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'github',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      githubIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'github',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jobTitle',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jobTitle',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jobTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jobTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jobTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jobTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jobTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jobTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jobTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jobTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jobTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      jobTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jobTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedIn',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedIn',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedIn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'linkedIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'linkedIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'linkedIn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'linkedIn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedIn',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      linkedInIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'linkedIn',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phone',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'portfolioWebsite',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'portfolioWebsite',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioWebsite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'portfolioWebsite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'portfolioWebsite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'portfolioWebsite',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'portfolioWebsite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'portfolioWebsite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'portfolioWebsite',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'portfolioWebsite',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'portfolioWebsite',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      portfolioWebsiteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'portfolioWebsite',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profileImagePath',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profileImagePath',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileImagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileImagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      profileImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileImagePath',
        value: '',
      ));
    });
  }
}

extension PersonalInformationQueryObject on QueryBuilder<PersonalInformation,
    PersonalInformation, QFilterCondition> {}
