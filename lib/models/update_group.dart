import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class UpdateGroup {
  Manga manga;
  List<Chapter> chapters;
  String timestamp;

  UpdateGroup.fromChapters(this.chapters, this.timestamp): manga = chapters.first.manga.value!;

  int get mangaId => manga.id;

  String get label {
    final indexes = chapters.sorted((a, b) => a.compareTo(b)).map((chapter) => chapter.getNumber).toList(growable: false);
    final volumes = indexes.map((index) => index.$1).toUnique(growable: false);


    if (volumes.length > 1) {
      final volumes = indexes.fold<Map<int, List<(int, int, int)>>>({}, (map, index) {
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

  int compareTo(UpdateGroup other) => lastUpdate.compareTo(other.lastUpdate);
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
String indexesToStr(List<(int, int, int)> indexes) {
  final groups = groupRanges(
      indexes.map((index) => indexToStr(index.$2, index.$3)).toUnique(growable: false)
  );

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