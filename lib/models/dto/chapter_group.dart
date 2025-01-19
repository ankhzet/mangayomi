import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/group.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';

bool isRead(Chapter chapter) => chapter.isRead ?? false;

class ChapterGroup<T> extends Group<Chapter, T> {
  Manga manga;

  ChapterGroup.fromItems(super.items, super.group) : manga = items.first.manga.value!;

  static T groupBy<T>(ChapterGroup<T> element) => element.group;

  static List<ChapterGroup<T>> groupChapters<T>(Iterable<Chapter> items, T Function(Chapter item) groupBy) {
    return Group.groupItems(
      items,
      groupBy,
      (items, group) => ChapterGroup.fromItems(items, group),
      belongsTo: (chapter, group) => group.mangaId == chapter.mangaId,
    );
  }

  int get mangaId => manga.id;

  @override
  String get label {
    final List<ChapterCompositeNumber> indexes = items.mapToList((chapter) => chapter.compositeOrder);
    final volumes = indexes.map((index) => index.$1).toUnique(growable: false)..sort((a, b) => a - b);

    if (volumes.length > 1) {
      final volumes = indexes.fold<Map<int, List<double>>>({}, (map, index) {
        final bucket = map[index.$1];

        if (bucket != null) {
          bucket.add(index.toDouble());
        } else {
          map[index.$1] = [index.toDouble()];
        }

        return map;
      });

      return volumes.entries.map((entry) => 'Vol. ${entry.key}: ${indexesToStr(entry.value)}').join(', ');
    }

    return 'Ch. ${indexesToStr(indexes.map((index) => index.toDouble()))}';
  }

  late bool isRead = items.every(Chapter.isChapterRead);
  late bool isAnyRead = items.any(Chapter.isChapterRead);
  late bool isAnyBookmarked = items.any(Chapter.isChapterBookmarked);
  late bool hasAnyScanlators = items.any(Chapter.hasChapterScanlators);
  late DateTime? dateUpload = Chapter.firstUpload(items);
  late String fullTitle = Chapter.fullTitle(items);

  late Chapter firstOrRead = items.firstWhere(Chapter.isChapterRead, orElse: () => items.first);
  late Chapter firstOrUnread = items.firstWhere(Chapter.isChapterUnread, orElse: () => items.first);

  late String scanlators =
      items.map((chapter) => (chapter.scanlator?.isEmpty ?? true) ? '?' : chapter.scanlator).join(', ');

  int get lastUpdate => manga.lastUpdate ?? DateTime.fromMicrosecondsSinceEpoch(0).millisecondsSinceEpoch;

  int compareTo(ChapterGroup other) => lastUpdate.compareTo(other.lastUpdate);
}

List<(double, double)> groupRanges(List<double> indexes) {
  List<(double, double)> groups = [];
  int pos = 0;
  int start = pos;
  int end = pos;
  int prev = indexes[start].floor();

  while (++pos < indexes.length) {
    final next = indexes[pos].floor();

    if (next != prev + 1) {
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
