import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';

bool isTrue(bool? value) => value == true;

bool isFalse(bool? value) => value == false;

bool Function(bool? value)? filter(FilterType index) {
  return switch (index) {
    FilterType.include => isTrue,
    FilterType.exclude => isFalse,
    _ => null,
  };
}

int compareStrings(String? a, String? b) {
  if (a == null || b == null) {
    return 0;
  }

  return a.toLowerCase().compareTo(b.toLowerCase());
}

int compareTimestamps(String? a, String? b) {
  if (a == null || b == null) {
    return 0;
  }

  int i1 = int.parse(a);
  int i2 = int.parse(b);

  return switch (i1 - i2) {
    > 0 => 1,
    < 0 => -1,
    _ => 0,
  };
}

int compareOrder(Chapter a, Chapter b) => a.order.compareTo(b.order);

enum SortType {
  scanlator,
  number,
  timestamp,
  name,
}

class ChapterFilterModel {
  FilterType filterUnread;
  FilterType filterBookmarked;
  FilterType filterDownloaded;
  List<String> filterScanlator;

  ChapterFilterModel({
    required this.filterUnread,
    required this.filterBookmarked,
    required this.filterDownloaded,
    required this.filterScanlator,
  });

  bool Function(Chapter chapter) build() {
    final unread = filter(filterUnread);
    final bookmarked = filter(filterBookmarked);
    final downloaded = filter(filterDownloaded);

    return (Chapter chapter) {
      if (unread != null && !unread(chapter.isRead != true)) {
        return false;
      }

      if (bookmarked != null && !bookmarked(chapter.isBookmarked)) {
        return false;
      }

      if (downloaded != null) {
        final modelChapDownload = isar.downloads.filter().idIsNotNull().chapterIdEqualTo(chapter.id).findAllSync();

        if (!downloaded(modelChapDownload.firstOrNull?.isDownload ?? false)) {
          return false;
        }
      }

      return !filterScanlator.contains(chapter.scanlator);
    };
  }
}

class ChapterSortModel {
  SortType sort;
  bool reverse;

  ChapterSortModel({
    required this.sort,
    this.reverse = false,
  });

  Comparator<Chapter> build() {
    return switch (sort) {
      SortType.scanlator => (a, b) => switch (compareStrings(a.scanlator, b.scanlator)) {
            0 => compareOrder(a, b),
            var cmp => cmp,
          },
      SortType.number => (a, b) => switch (compareOrder(a, b)) {
            0 => compareStrings(a.scanlator, b.scanlator),
            var cmp => cmp,
          },
      SortType.timestamp => (a, b) => compareTimestamps(a.dateUpload, b.dateUpload),
      SortType.name => (a, b) => compareStrings(a.name, b.name),
    };
  }
}

class ChaptersListModel {
  List<Chapter> chapters;

  ChaptersListModel({
    required this.chapters,
  });

  List<Chapter> build({required ChapterFilterModel filter, required ChapterSortModel sort}) {
    return chapters.where(filter.build()).toList(growable: false)..sort(sort.build());
  }
}
