import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/group.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';

bool isRead(Chapter chapter) => chapter.isRead ?? false;

class ChapterGroup<T> extends Group<Chapter, T> {
  ChapterGroup(super.state, super.group);

  static T groupBy<T>(ChapterGroup<T> element) => element.group;

  static List<ChapterGroup<T>> groupChapters<T>(Iterable<Chapter> items, T Function(Chapter item) groupBy) {
    return Group.groupItems(
      items,
      groupBy,
      (items, group) => ChapterGroup(items, group),
      belongsTo: (chapter, group) => group.mangaId == chapter.mangaId,
    );
  }

  late Manga manga = state.first.manga.value!;
  int get mangaId => manga.id;

  @override
  String get label {
    final List<ChapterCompositeNumber> indexes = state.mapToList((chapter) => chapter.compositeOrder);

    return 'Ch. ${indexesToStr(indexes.map((index) => index.toDouble()))}';
  }

  bool get isRead => state.every(Chapter.isChapterRead);
  bool get isAnyRead => state.any(Chapter.isChapterRead);
  bool get isAnyBookmarked => state.any(Chapter.isChapterBookmarked);
  bool get hasAnyScanlators => state.any(Chapter.hasChapterScanlators);
  DateTime? get dateUpload => Chapter.firstUpload(state);
  String get fullTitle => Chapter.fullTitle(state);

  Chapter get firstOrRead => state.firstWhere(Chapter.isChapterRead, orElse: () => state.first);
  Chapter get firstOrUnread => state.firstWhere(Chapter.isChapterUnread, orElse: () => state.first);

  late String scanlators =
      state.map((chapter) => (chapter.scanlator?.isEmpty ?? true) ? '?' : chapter.scanlator).join(', ');

  int get lastUpdate => manga.lastUpdate ?? DateTime.fromMicrosecondsSinceEpoch(0).millisecondsSinceEpoch;

  int compareTo(ChapterGroup other) => lastUpdate.compareTo(other.lastUpdate);

  void removeByIds(Iterable<int> ids) {
    state = state.where((item) => !ids.contains(item.id)).toList(growable: false);
  }
}

List<(double, double)> groupRanges(List<double> indexes) {
  List<(double, double)> groups = [];
  int pos = 0;
  int start = pos;
  int end = pos;
  int prev = indexes[start].floor();

  while (++pos < indexes.length) {
    final next = indexes[pos].floor();

    if ((next != prev) && (next != prev + 1)) {
      groups.add((indexes[start], indexes[end]));
      start = pos;
    }

    prev = next;
    end = pos;
  }

  groups.add((indexes[start], indexes[end]));

  return groups;
}

String indexToStr(double number) {
  final floor = number.floor();
  final ceil = number.ceil();

  return ceil != floor ? number.toString() : floor.toString();
}

String indexesToStr(Iterable<double> indexes) {
  final groups = groupRanges(indexes.toUnique(growable: false)..sort((a, b) => a.compareTo(b)));

  return groups.map((group) {
    final (start, end) = group;
    final first = indexToStr(start);

    if (start == end) {
      return first;
    }

    final last = indexToStr(end);

    if (start + 1 == end) {
      return '$first, $last';
    }

    return '$first..$last';
  }).join(', ');
}
