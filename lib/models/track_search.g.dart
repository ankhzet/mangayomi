// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_search.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTrackSearchCollection on Isar {
  IsarCollection<TrackSearch> get trackSearchs => this.collection();
}

const TrackSearchSchema = CollectionSchema(
  name: r'TrackSearch',
  id: 7335576978136013571,
  properties: {
    r'coverUrl': PropertySchema(
      id: 0,
      name: r'coverUrl',
      type: IsarType.string,
    ),
    r'finishedReadingDate': PropertySchema(
      id: 1,
      name: r'finishedReadingDate',
      type: IsarType.long,
    ),
    r'lastChapterRead': PropertySchema(
      id: 2,
      name: r'lastChapterRead',
      type: IsarType.long,
    ),
    r'libraryId': PropertySchema(
      id: 3,
      name: r'libraryId',
      type: IsarType.long,
    ),
    r'mediaId': PropertySchema(id: 4, name: r'mediaId', type: IsarType.long),
    r'publishingStatus': PropertySchema(
      id: 5,
      name: r'publishingStatus',
      type: IsarType.string,
    ),
    r'publishingType': PropertySchema(
      id: 6,
      name: r'publishingType',
      type: IsarType.string,
    ),
    r'score': PropertySchema(id: 7, name: r'score', type: IsarType.double),
    r'startDate': PropertySchema(
      id: 8,
      name: r'startDate',
      type: IsarType.string,
    ),
    r'startedReadingDate': PropertySchema(
      id: 9,
      name: r'startedReadingDate',
      type: IsarType.long,
    ),
    r'status': PropertySchema(id: 10, name: r'status', type: IsarType.string),
    r'summary': PropertySchema(id: 11, name: r'summary', type: IsarType.string),
    r'syncId': PropertySchema(id: 12, name: r'syncId', type: IsarType.long),
    r'title': PropertySchema(id: 13, name: r'title', type: IsarType.string),
    r'totalChapter': PropertySchema(
      id: 14,
      name: r'totalChapter',
      type: IsarType.long,
    ),
    r'trackingUrl': PropertySchema(
      id: 15,
      name: r'trackingUrl',
      type: IsarType.string,
    ),
  },

  estimateSize: _trackSearchEstimateSize,
  serialize: _trackSearchSerialize,
  deserialize: _trackSearchDeserialize,
  deserializeProp: _trackSearchDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _trackSearchGetId,
  getLinks: _trackSearchGetLinks,
  attach: _trackSearchAttach,
  version: '3.3.0',
);

int _trackSearchEstimateSize(
  TrackSearch object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.coverUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publishingStatus;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.publishingType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startDate;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.status;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.summary;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.trackingUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _trackSearchSerialize(
  TrackSearch object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.coverUrl);
  writer.writeLong(offsets[1], object.finishedReadingDate);
  writer.writeLong(offsets[2], object.lastChapterRead);
  writer.writeLong(offsets[3], object.libraryId);
  writer.writeLong(offsets[4], object.mediaId);
  writer.writeString(offsets[5], object.publishingStatus);
  writer.writeString(offsets[6], object.publishingType);
  writer.writeDouble(offsets[7], object.score);
  writer.writeString(offsets[8], object.startDate);
  writer.writeLong(offsets[9], object.startedReadingDate);
  writer.writeString(offsets[10], object.status);
  writer.writeString(offsets[11], object.summary);
  writer.writeLong(offsets[12], object.syncId);
  writer.writeString(offsets[13], object.title);
  writer.writeLong(offsets[14], object.totalChapter);
  writer.writeString(offsets[15], object.trackingUrl);
}

TrackSearch _trackSearchDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TrackSearch(
    coverUrl: reader.readStringOrNull(offsets[0]),
    finishedReadingDate: reader.readLongOrNull(offsets[1]),
    id: id,
    lastChapterRead: reader.readLongOrNull(offsets[2]),
    libraryId: reader.readLongOrNull(offsets[3]),
    mediaId: reader.readLongOrNull(offsets[4]),
    publishingStatus: reader.readStringOrNull(offsets[5]),
    publishingType: reader.readStringOrNull(offsets[6]),
    score: reader.readDoubleOrNull(offsets[7]),
    startDate: reader.readStringOrNull(offsets[8]),
    startedReadingDate: reader.readLongOrNull(offsets[9]),
    status: reader.readStringOrNull(offsets[10]),
    summary: reader.readStringOrNull(offsets[11]),
    syncId: reader.readLongOrNull(offsets[12]),
    title: reader.readStringOrNull(offsets[13]),
    totalChapter: reader.readLongOrNull(offsets[14]),
    trackingUrl: reader.readStringOrNull(offsets[15]),
  );
  return object;
}

P _trackSearchDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLongOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _trackSearchGetId(TrackSearch object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _trackSearchGetLinks(TrackSearch object) {
  return [];
}

void _trackSearchAttach(
  IsarCollection<dynamic> col,
  Id id,
  TrackSearch object,
) {
  object.id = id;
}

extension TrackSearchQueryWhereSort
    on QueryBuilder<TrackSearch, TrackSearch, QWhere> {
  QueryBuilder<TrackSearch, TrackSearch, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TrackSearchQueryWhere
    on QueryBuilder<TrackSearch, TrackSearch, QWhereClause> {
  QueryBuilder<TrackSearch, TrackSearch, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension TrackSearchQueryFilter
    on QueryBuilder<TrackSearch, TrackSearch, QFilterCondition> {
  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'coverUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'coverUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> coverUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> coverUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'coverUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'coverUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> coverUrlMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'coverUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'coverUrl', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  coverUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'coverUrl', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'finishedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'finishedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'finishedReadingDate', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'finishedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'finishedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  finishedReadingDateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'finishedReadingDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastChapterRead'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastChapterRead'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastChapterRead', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastChapterRead',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastChapterRead',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  lastChapterReadBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastChapterRead',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'libraryId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'libraryId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'libraryId', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'libraryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'libraryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  libraryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'libraryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  mediaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mediaId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  mediaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mediaId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> mediaIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mediaId', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  mediaIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mediaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> mediaIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mediaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> mediaIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mediaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'publishingStatus'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'publishingStatus'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'publishingStatus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'publishingStatus',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'publishingStatus',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'publishingStatus', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingStatusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'publishingStatus', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'publishingType'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'publishingType'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'publishingType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'publishingType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'publishingType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'publishingType', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  publishingTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'publishingType', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'score'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  scoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'score'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  scoreGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> scoreBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'startDate',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'startDate',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'startDate', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startedReadingDate'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedReadingDate', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedReadingDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  startedReadingDateBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedReadingDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'status'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'status'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'summary'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'summary',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'summary',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> summaryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'summary',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'summary', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  syncIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'syncId'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncId', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  syncIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> syncIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'title'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'title'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'totalChapter'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'totalChapter'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalChapter', value: value),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalChapter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalChapter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  totalChapterBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalChapter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'trackingUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'trackingUrl'),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'trackingUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'trackingUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'trackingUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'trackingUrl', value: ''),
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterFilterCondition>
  trackingUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'trackingUrl', value: ''),
      );
    });
  }
}

extension TrackSearchQueryObject
    on QueryBuilder<TrackSearch, TrackSearch, QFilterCondition> {}

extension TrackSearchQueryLinks
    on QueryBuilder<TrackSearch, TrackSearch, QFilterCondition> {}

extension TrackSearchQuerySortBy
    on QueryBuilder<TrackSearch, TrackSearch, QSortBy> {
  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByFinishedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByFinishedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByLastChapterRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByLastChapterReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByLibraryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByLibraryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByPublishingStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingStatus', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByPublishingStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingStatus', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByPublishingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingType', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByPublishingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingType', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByStartedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByStartedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  sortByTotalChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByTrackingUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> sortByTrackingUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.desc);
    });
  }
}

extension TrackSearchQuerySortThenBy
    on QueryBuilder<TrackSearch, TrackSearch, QSortThenBy> {
  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByFinishedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByFinishedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finishedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByLastChapterRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByLastChapterReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastChapterRead', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByLibraryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByLibraryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'libraryId', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByMediaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaId', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByPublishingStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingStatus', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByPublishingStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingStatus', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByPublishingType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingType', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByPublishingTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publishingType', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByStartedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByStartedReadingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedReadingDate', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenBySyncIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncId', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy>
  thenByTotalChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChapter', Sort.desc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByTrackingUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.asc);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QAfterSortBy> thenByTrackingUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trackingUrl', Sort.desc);
    });
  }
}

extension TrackSearchQueryWhereDistinct
    on QueryBuilder<TrackSearch, TrackSearch, QDistinct> {
  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByCoverUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct>
  distinctByFinishedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finishedReadingDate');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct>
  distinctByLastChapterRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastChapterRead');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByLibraryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'libraryId');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByMediaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaId');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByPublishingStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'publishingStatus',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByPublishingType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'publishingType',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByStartDate({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct>
  distinctByStartedReadingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedReadingDate');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctBySummary({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctBySyncId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncId');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByTotalChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChapter');
    });
  }

  QueryBuilder<TrackSearch, TrackSearch, QDistinct> distinctByTrackingUrl({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trackingUrl', caseSensitive: caseSensitive);
    });
  }
}

extension TrackSearchQueryProperty
    on QueryBuilder<TrackSearch, TrackSearch, QQueryProperty> {
  QueryBuilder<TrackSearch, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations> coverUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverUrl');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations>
  finishedReadingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finishedReadingDate');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations> lastChapterReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastChapterRead');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations> libraryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'libraryId');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations> mediaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaId');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations>
  publishingStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publishingStatus');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations>
  publishingTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publishingType');
    });
  }

  QueryBuilder<TrackSearch, double?, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations>
  startedReadingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedReadingDate');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations> syncIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncId');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TrackSearch, int?, QQueryOperations> totalChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChapter');
    });
  }

  QueryBuilder<TrackSearch, String?, QQueryOperations> trackingUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trackingUrl');
    });
  }
}
