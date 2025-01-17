import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class ChapterGroup<T> {
  Manga manga;
  List<Chapter> chapters;
  T group;

  ChapterGroup.fromChapters(this.chapters, this.group) : manga = chapters.first.manga.value!;

  static T groupBy<T>(ChapterGroup<T> element) => element.group;

  static List<ChapterGroup<T>> groupUpdates<T>(Iterable<Chapter> items, T Function(Chapter item) groupBy) {
    final List<ChapterGroup<T>> list = [];

    for (final chapter in items) {
      final mangaId = chapter.mangaId!;
      final group = groupBy(chapter);
      final bucket = list.firstWhereOrNull((item) => (item.group == group) && (item.manga.id == mangaId));

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
    final indexes =
        chapters.sorted((a, b) => -a.compareTo(b)).map((chapter) => chapter.getNumber).toList(growable: false);
    final volumes = indexes.map((index) => index.$1).toUnique(growable: false);

    if (volumes.length > 1) {
      final volumes = indexes.fold<Map<int, List<ChapterCompositeNumber>>>({}, (map, index) {
        final bucket = map[index.$1];

        if (bucket != null) {
          bucket.add(index);
        } else {
          map[index.$1] = [index];
        }

        return map;
      });

      return volumes.entries.map((entry) => 'Vol. ${entry.key}: ${indexesToStr(entry.value)}').join(', ');
    }

    return 'Ch. ${indexesToStr(indexes)}';
  }

  bool get isRead => chapters.every((chapter) => chapter.isRead ?? false);

  Chapter get firstOrUnread {
    return chapters.firstWhere((chapter) => chapter.isRead ?? false, orElse: () => chapters.first);
  }

  int get lastUpdate => manga.lastUpdate ?? DateTime.fromMicrosecondsSinceEpoch(0).millisecondsSinceEpoch;

  int compareTo(ChapterGroup other) => lastUpdate.compareTo(other.lastUpdate);
}

List<List<String>> groupRanges(List<String> indexes) {
  List<List<String>> groups = [];
  int pos = 0;
  int start = pos;
  int end = pos;
  int prev = double.parse(indexes[start]).floor();

  while (++pos < indexes.length) {
    final next = double.parse(indexes[pos]).floor();

    if (next.floor() != prev.floor() + 1) {
      groups.add([indexes[start], indexes[end]]);
      start = pos;
    }

    prev = next;
    end = pos;
  }

  groups.add([indexes[start], indexes[end]]);

  return groups;
}

String indexToStr(int c, int s) => s != 0 ? '$c.$s' : c.toString();

String indexesToStr(List<ChapterCompositeNumber> indexes) {
  final groups = groupRanges(indexes.map((index) => indexToStr(index.$2, index.$3)).toUnique(growable: false));

  return groups.map((group) {
    final [start, end] = group;

    if (start == end) {
      return start;
    } else if (double.parse(start) + 1 == double.parse(end)) {
      return '$start, $end';
    }

    return '$start..$end';
  }).join(', ');
}
