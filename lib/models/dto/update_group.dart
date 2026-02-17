import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class UpdateGroup<T> {
  Manga manga;
  List<Chapter> chapters;
  T group;

  UpdateGroup.fromChapters(this.chapters, this.group)
    : manga = chapters.first.manga.value!;

  static T groupBy<T>(UpdateGroup<T> element) => element.group;

  static List<UpdateGroup<T>> groupUpdates<T>(
    Iterable<Update> updates,
    T Function(Update update) groupBy,
  ) {
    final List<UpdateGroup<T>> list = [];

    for (var update in updates) {
      final chapter = update.chapter.value;
      if (chapter == null) continue;

      final mangaId = chapter.mangaId!;
      final group = groupBy(update);
      final bucket = list.firstWhereOrNull(
        (item) => (item.group == group) && (item.manga.id == mangaId),
      );

      if (bucket != null) {
        bucket.chapters.add(chapter);
      } else {
        list.add(UpdateGroup.fromChapters([chapter], group));
      }
    }

    return list;
  }

  int get mangaId => manga.id;

  String get label {
    if (chapters.length == 1) {
      final idx = chapters.first.compositeOrder;
      return 'Ch. ${indexToStr(idx.$2, idx.$3)}';
    }

    final indexes = chapters
        .sorted((a, b) => a.compareTo(b))
        .map((chapter) => chapter.compositeOrder)
        .toList(growable: false);

    // when volumes data is inconsistent, this clutters the label needlessly
    // final volumes = indexes.map((index) => index.$1).toUnique(growable: false);
    //
    // if (volumes.length > 1) {
    //   final volumesMap = indexes.fold<Map<int, List<ChapterCompositeNumber>>>(
    //     {},
    //     (map, index) {
    //       final bucket = map[index.$1];
    //       if (bucket != null) {
    //         bucket.add(index);
    //       } else {
    //         map[index.$1] = [index];
    //       }
    //       return map;
    //     },
    //   );
    //   return volumesMap.entries
    //       .map((entry) => 'Vol. ${entry.key}: ${indexesToStr(entry.value)}')
    //       .join(', ');
    // }

    return 'Ch. ${indexesToStr(indexes)}';
  }

  bool get isRead => chapters.every((chapter) => chapter.isRead ?? false);

  Chapter get firstOrUnread {
    return chapters.firstWhere(
      (chapter) => chapter.isRead ?? false,
      orElse: () => chapters.first,
    );
  }

  int get lastUpdate =>
      manga.lastUpdate ??
      DateTime.fromMicrosecondsSinceEpoch(0).millisecondsSinceEpoch;

  int compareTo(UpdateGroup other) => lastUpdate.compareTo(other.lastUpdate);
}

List<List<String>> groupRanges(Iterable<String> indexes) {
  final idxList = indexes.toList();
  if (idxList.isEmpty) return [];

  List<List<String>> groups = [];
  int start = 0;
  int end = 0;

  for (int pos = 1; pos < idxList.length; pos++) {
    final prev = double.parse(idxList[pos - 1]);
    final curr = double.parse(idxList[pos]);

    if ((curr - prev).abs() > 1.01) {
      groups.add([idxList[start], idxList[end]]);
      start = pos;
    }
    end = pos;
  }

  groups.add([idxList[start], idxList[end]]);
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
