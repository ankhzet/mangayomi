import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class ChapterGroup<T> {
  Manga manga;
  List<Chapter> chapters;
  T group;

  ChapterGroup.fromChapters(this.chapters, this.group)
    : manga = chapters.first.manga.value!;

  static T groupBy<T>(ChapterGroup<T> element) => element.group;

  static List<ChapterGroup<T>> groupChapters<T>(
    Iterable<Chapter> items,
    T Function(Chapter item) groupBy,
  ) {
    final List<ChapterGroup<T>> list = [];

    for (final chapter in items) {
      final mangaId = chapter.mangaId!;
      final group = groupBy(chapter);
      final bucket = list.firstWhereOrNull(
        (item) => (item.group == group) && (item.manga.id == mangaId),
      );

      if (bucket != null) {
        bucket.chapters.add(chapter);
      } else {
        list.add(ChapterGroup.fromChapters([chapter], group));
      }
    }

    return list;
  }

  int get mangaId => manga.id;

  String get label {
    final indexes = chapters
        .sorted((a, b) => -a.compareTo(b))
        .map((chapter) => chapter.compositeOrder)
        .toList(growable: false);
    final volumes = indexes.map((index) => index.$1).toUnique(growable: false);

    if (volumes.length > 1) {
      final volumesMap = indexes.fold<Map<int, List<ChapterCompositeNumber>>>(
        {},
        (map, index) {
          final bucket = map[index.$1];
          if (bucket != null) {
            bucket.add(index);
          } else {
            map[index.$1] = [index];
          }
          return map;
        },
      );
      return volumesMap.entries
          .map((entry) => 'Vol. ${entry.key}: ${indexesToStr(entry.value)}')
          .join(', ');
    }

    return 'Ch. ${indexesToStr(indexes)}';
  }

  late bool isRead = chapters.every(ChapterExtension.isChapterRead);
  late bool isAnyRead = chapters.any(ChapterExtension.isChapterRead);
  late bool isAnyBookmarked = chapters.any(
    ChapterExtension.isChapterBookmarked,
  );
  late bool hasAnyScanlators = chapters.any(
    ChapterExtension.hasChapterScanlators,
  );
  late DateTime? dateUpload = ChapterExtension.firstUpload(chapters);
  late String fullTitle = ChapterExtension.fullTitle(chapters);

  late Chapter firstOrRead = chapters.firstWhere(
    ChapterExtension.isChapterRead,
    orElse: () => chapters.first,
  );
  late Chapter firstOrUnread = chapters.firstWhere(
    ChapterExtension.isChapterUnread,
    orElse: () => chapters.first,
  );

  late String scanlators = chapters
      .map(
        (chapter) =>
            (chapter.scanlator?.isEmpty ?? true) ? '?' : chapter.scanlator,
      )
      .join(', ');

  int get lastUpdate =>
      manga.lastUpdate ??
      DateTime.fromMicrosecondsSinceEpoch(0).millisecondsSinceEpoch;

  int compareTo(ChapterGroup other) => lastUpdate.compareTo(other.lastUpdate);
}

List<List<String>> groupRanges(Iterable<String> indexes) {
  final indexList = indexes.toList();
  List<List<String>> groups = [];
  int pos = 0;
  int start = pos;
  int end = pos;
  int prev = double.parse(indexList[start]).floor();

  while (++pos < indexList.length) {
    final next = double.parse(indexList[pos]).floor();
    if (next.floor() != prev.floor() + 1) {
      groups.add([indexList[start], indexList[end]]);
      start = pos;
    }
    prev = next;
    end = pos;
  }

  groups.add([indexList[start], indexList[end]]);
  return groups;
}

String indexToStr(int c, int s) => s != 0 ? '$c.$s' : c.toString();

String indexesToStr(List<ChapterCompositeNumber> indexes) {
  final groups = groupRanges(
    indexes.map((index) => indexToStr(index.$2, index.$3)),
  );
  return groups
      .map((group) {
        final [start, end] = group;
        if (start == end) {
          return start;
        } else if (double.parse(start) + 1 == double.parse(end)) {
          return '$start, $end';
        }
        return '$start..$end';
      })
      .join(', ');
}
