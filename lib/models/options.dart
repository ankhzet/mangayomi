import 'package:isar/isar.dart';

abstract interface class OfManga {
  static bool Function(T element) isManga<T extends OfManga>(int id) => (T element) => id == element.mangaId;

  static bool Function(T element) isNotManga<T extends OfManga>(int id) => (T element) => id != element.mangaId;

  int? get mangaId;
}

abstract interface class OfChapter {
  static bool Function(T element) isChapter<T extends OfChapter>(int id) => (T element) => id == element.chapterId;

  static bool Function(T element) isNotChapter<T extends OfChapter>(int id) => (T element) => id != element.chapterId;

  int? get chapterId;
}

abstract interface class SortOptionModel extends OfManga {
  late int? index;
  late bool? reverse;

  @ignore
  SortType get sort;

  @ignore
  bool get inReverse;
}

enum ChapterFilterOption {
  download,
  unread,
  bookmark,
  sort,
}

enum SortType {
  scanlator,
  number,
  timestamp,
  name,
}

enum FilterType {
  keep,
  include,
  exclude,
}

abstract interface class FilterOptionModel extends OfManga {
  late int? type;

  @ignore
  FilterType get filter;
}

mixin FilterModel implements FilterOptionModel {
  @ignore
  @override
  get filter => FilterType.values[type ?? 0];
}
