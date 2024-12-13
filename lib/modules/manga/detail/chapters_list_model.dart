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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChapterFilterModel &&
        filterUnread == other.filterUnread &&
        filterBookmarked == other.filterBookmarked &&
        filterDownloaded == other.filterDownloaded &&
        filterScanlator == other.filterScanlator;
  }

  @override
  int get hashCode =>
      filterUnread.hashCode ^ filterBookmarked.hashCode ^ filterDownloaded.hashCode ^ filterScanlator.hashCode;
}

class ChapterSortModel {
  final SortOptionModel sort;

  const ChapterSortModel(this.sort);

  Comparator<Chapter> compareOrder(Iterable<Chapter> chapters) {
    final Map<int, ChapterCompositeNumber> cache = {};
    final int multiplier = sort.inReverse ? -1 : 1;

    for (var chapter in chapters) {
      cache[chapter.id!] = chapter.getNumber;
    }

    return (Chapter a, Chapter b) {
      final (_, ac, af) = cache[a.id!]!;
      final (_, bc, bf) = cache[b.id!]!;

      if (ac != bc) {
        return multiplier * (ac < bc ? 1 : -1);
      }

      return ((af == bf) //
          ? 0
          : multiplier * (af < bf ? 1 : -1));
    };
  }

  Comparator<Chapter> compareName(Iterable<Chapter> chapters) {
    final Map<int, String> cache = {};
    final int multiplier = sort.inReverse ? -1 : 1;

    for (var chapter in chapters) {
      cache[chapter.id!] = chapter.name?.toLowerCase() ?? '';
    }

    return (Chapter a, Chapter b) => multiplier * cache[a.id!]!.compareTo(cache[b.id!]!);
  }

  Comparator<Chapter> compareScanlator(Iterable<Chapter> chapters) {
    final Map<int, String> cache = {};
    final int multiplier = sort.inReverse ? -1 : 1;

    for (var chapter in chapters) {
      cache[chapter.id!] = chapter.scanlator?.toLowerCase() ?? '';
    }

    return (Chapter a, Chapter b) => multiplier * cache[a.id!]!.compareTo(cache[b.id!]!);
  }

  Comparator<Chapter> compareDateUpload(Iterable<Chapter> chapters) {
    final Map<int, int> cache = {};
    final int multiplier = sort.inReverse ? -1 : 1;

    for (var chapter in chapters) {
      cache[chapter.id!] = chapter.dateUpload != null ? multiplier * int.parse(chapter.dateUpload!) : 0;
    }

    return (Chapter a, Chapter b) {
      int i1 = cache[a.id!]!;
      int i2 = cache[b.id!]!;

      return switch (i1 - i2) {
        > 0 => 1,
        < 0 => -1,
        _ => 0,
      };
    };
  }

  Iterable<Chapter> build(Iterable<Chapter> chapters) {
    final list = chapters is List<Chapter> ? chapters : chapters.toList(growable: false);
    final order = compareOrder(chapters);
    final name = compareName(chapters);
    final scanlator = compareScanlator(chapters);
    final timestamp = compareDateUpload(chapters);

    return list
      ..sort(switch (sort.sort) {
        SortType.scanlator => (a, b) => switch (scanlator(a, b)) {
              0 => order(a, b),
              var cmp => cmp,
            },
        SortType.number => (a, b) => switch (order(a, b)) {
              0 => scanlator(a, b),
              var cmp => cmp,
            },
        SortType.timestamp => timestamp,
        SortType.name => name,
      });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChapterSortModel && (sort == other.sort);
  }

  @override
  int get hashCode => sort.hashCode;
}

class ChaptersListModel {
  final ChapterFilterModel filter;
  final ChapterSortModel sort;

  const ChaptersListModel({required this.filter, required this.sort});

  List<Chapter> build(Iterable<Chapter> chapters) {
    return sort
        .build(
          chapters.where(filter.build()),
        )
        .toList(growable: false);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChaptersListModel && (filter == other.filter && sort == other.sort);
  }

  @override
  int get hashCode => filter.hashCode ^ sort.hashCode;
}
