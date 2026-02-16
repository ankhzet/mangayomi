// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_queue_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetViewQueueItemCollection on Isar {
  IsarCollection<ViewQueueItem> get viewQueueItems => this.collection();
}

const ViewQueueItemSchema = CollectionSchema(
  name: r'ViewQueueItem',
  id: 1730741324739681890,
  properties: {
    r'chapterId': PropertySchema(
      id: 0,
      name: r'chapterId',
      type: IsarType.long,
    ),
    r'mangaId': PropertySchema(id: 1, name: r'mangaId', type: IsarType.long),
    r'timestamp': PropertySchema(
      id: 2,
      name: r'timestamp',
      type: IsarType.long,
    ),
  },

  estimateSize: _viewQueueItemEstimateSize,
  serialize: _viewQueueItemSerialize,
  deserialize: _viewQueueItemDeserialize,
  deserializeProp: _viewQueueItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'mangaId': IndexSchema(
      id: 7466570075891278896,
      name: r'mangaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mangaId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'chapterId': IndexSchema(
      id: -1917949875430644359,
      name: r'chapterId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chapterId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _viewQueueItemGetId,
  getLinks: _viewQueueItemGetLinks,
  attach: _viewQueueItemAttach,
  version: '3.3.0',
);

int _viewQueueItemEstimateSize(
  ViewQueueItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _viewQueueItemSerialize(
  ViewQueueItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapterId);
  writer.writeLong(offsets[1], object.mangaId);
  writer.writeLong(offsets[2], object.timestamp);
}

ViewQueueItem _viewQueueItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ViewQueueItem(
    chapterId: reader.readLong(offsets[0]),
    id: id,
    mangaId: reader.readLong(offsets[1]),
    timestamp: reader.readLong(offsets[2]),
  );
  return object;
}

P _viewQueueItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _viewQueueItemGetId(ViewQueueItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _viewQueueItemGetLinks(ViewQueueItem object) {
  return [];
}

void _viewQueueItemAttach(
  IsarCollection<dynamic> col,
  Id id,
  ViewQueueItem object,
) {
  object.id = id;
}

extension ViewQueueItemQueryWhereSort
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QWhere> {
  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhere> anyMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'mangaId'),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhere> anyChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'chapterId'),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension ViewQueueItemQueryWhere
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QWhereClause> {
  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> mangaIdEqualTo(
    int mangaId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'mangaId', value: [mangaId]),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  mangaIdNotEqualTo(int mangaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [],
                upper: [mangaId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [mangaId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [mangaId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'mangaId',
                lower: [],
                upper: [mangaId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  mangaIdGreaterThan(int mangaId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [mangaId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> mangaIdLessThan(
    int mangaId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [],
          upper: [mangaId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> mangaIdBetween(
    int lowerMangaId,
    int upperMangaId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'mangaId',
          lower: [lowerMangaId],
          includeLower: includeLower,
          upper: [upperMangaId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  chapterIdEqualTo(int chapterId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'chapterId', value: [chapterId]),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  chapterIdNotEqualTo(int chapterId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'chapterId',
                lower: [],
                upper: [chapterId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'chapterId',
                lower: [chapterId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'chapterId',
                lower: [chapterId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'chapterId',
                lower: [],
                upper: [chapterId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  chapterIdGreaterThan(int chapterId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'chapterId',
          lower: [chapterId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  chapterIdLessThan(int chapterId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'chapterId',
          lower: [],
          upper: [chapterId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  chapterIdBetween(
    int lowerChapterId,
    int upperChapterId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'chapterId',
          lower: [lowerChapterId],
          includeLower: includeLower,
          upper: [upperChapterId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  timestampEqualTo(int timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'timestamp', value: [timestamp]),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  timestampNotEqualTo(int timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [timestamp],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'timestamp',
                lower: [],
                upper: [timestamp],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  timestampGreaterThan(int timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [timestamp],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  timestampLessThan(int timestamp, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [],
          upper: [timestamp],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause>
  timestampBetween(
    int lowerTimestamp,
    int upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'timestamp',
          lower: [lowerTimestamp],
          includeLower: includeLower,
          upper: [upperTimestamp],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ViewQueueItemQueryFilter
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QFilterCondition> {
  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  chapterIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'chapterId', value: value),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  chapterIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  chapterIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'chapterId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  chapterIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'chapterId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  mangaIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mangaId', value: value),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  mangaIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  mangaIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mangaId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  mangaIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mangaId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  timestampEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timestamp', value: value),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  timestampGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  timestampLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timestamp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterFilterCondition>
  timestampBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timestamp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ViewQueueItemQueryObject
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QFilterCondition> {}

extension ViewQueueItemQueryLinks
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QFilterCondition> {}

extension ViewQueueItemQuerySortBy
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QSortBy> {
  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> sortByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy>
  sortByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> sortByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> sortByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy>
  sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension ViewQueueItemQuerySortThenBy
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QSortThenBy> {
  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> thenByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy>
  thenByChapterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterId', Sort.desc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> thenByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> thenByMangaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mangaId', Sort.desc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterSortBy>
  thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension ViewQueueItemQueryWhereDistinct
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QDistinct> {
  QueryBuilder<ViewQueueItem, ViewQueueItem, QDistinct> distinctByChapterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterId');
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QDistinct> distinctByMangaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mangaId');
    });
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension ViewQueueItemQueryProperty
    on QueryBuilder<ViewQueueItem, ViewQueueItem, QQueryProperty> {
  QueryBuilder<ViewQueueItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ViewQueueItem, int, QQueryOperations> chapterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterId');
    });
  }

  QueryBuilder<ViewQueueItem, int, QQueryOperations> mangaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mangaId');
    });
  }

  QueryBuilder<ViewQueueItem, int, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
