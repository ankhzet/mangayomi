import 'dart:math';

import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';

part 'chapter.g.dart';

typedef ChapterCompositeNumber = (int, int, int);

int compareComposite(ChapterCompositeNumber a, ChapterCompositeNumber b) {
  final (_, ac, af) = a;
  final (_, bc, bf) = b;

  if (ac != bc) {
    return ac < bc ? 1 : -1;
  }

  if (af != bf) {
    return af < bf ? 1 : -1;
  }

  return 0;
}

@collection
@Name("Chapter")
class Chapter {
  @ignore ChapterCompositeNumber? _order;
  @ignore String? _name;

  Id? id;

  int? mangaId;

  String? get name => _name;

  set name(String? value) {
    _name = value;
    _order = null;
  }

  String? url;

  String? dateUpload;

  String? scanlator;

  bool? isBookmarked;

  bool? isRead;

  String? lastPageRead;

  ///Only for local archive Comic
  String? archivePath;

  final manga = IsarLink<Manga>();

  static bool isChapterBookmarked(Chapter chapter) => chapter.isBookmarked ?? false;
  static bool isChapterRead(Chapter chapter) => chapter.isRead ?? false;
  static bool isChapterUnread(Chapter chapter) => !(chapter.isRead ?? false);
  static bool hasChapterScanlators(Chapter chapter) => chapter.scanlator?.isNotEmpty ?? false;
  static DateTime? firstUpload(Iterable<Chapter> chapters) {
    DateTime? min;

    for (final chapter in chapters) {
      final time = chapter.datetimeUpload();

      if (time != null && (min == null || time.millisecondsSinceEpoch < min.millisecondsSinceEpoch)) {
        min = time;
      }
    }

    return min;
  }

  static String fullTitle(Iterable<Chapter> chapters) {
    for (final chapter in chapters) {
      final name = chapter.name;

      if (name?.contains(':') ?? false) {
        return name!;
      }
    }

    final (v, c, s) = chapters.first.compositeOrder;
    final chapter = (s > 0) ? '$c.$s' : '$c';

    if (v > 0) {
      return 'Vol. $v, Chap. $chapter';
    }

    return 'Chapter $chapter';
  }

  Chapter(
      {this.id = Isar.autoIncrement,
      required this.mangaId,
      required String? name,
      this.url = '',
      this.dateUpload = '',
      this.isBookmarked = false,
      this.scanlator = '',
      this.isRead = false,
      this.lastPageRead = '',
      this.archivePath = ''}): _name = name;

  Chapter.fromJson(Map<String, dynamic> json) {
    archivePath = json['archivePath'];
    dateUpload = json['dateUpload'];
    id = json['id'];
    isBookmarked = json['isBookmarked'];
    isRead = json['isRead'];
    lastPageRead = json['lastPageRead'];
    mangaId = json['mangaId'];
    name = json['name'];
    scanlator = json['scanlator'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() => {
        'archivePath': archivePath,
        'dateUpload': dateUpload,
        'id': id,
        'isBookmarked': isBookmarked,
        'isRead': isRead,
        'lastPageRead': lastPageRead,
        'mangaId': mangaId,
        'name': name,
        'scanlator': scanlator,
        'url': url
      };

  bool isSameNumber(Chapter other) {
    return 0 == compareComposite(compositeOrder, other.compositeOrder);
  }

  bool isSame(Chapter other) {
    if (mangaId != other.mangaId) {
      return false;
    }

    if ((url?.isNotEmpty ?? false) && url == other.url) {
      return true;
    } else if ((archivePath?.isNotEmpty ?? false) && archivePath == other.archivePath) {
      return true;
    }

    return scanlator == other.scanlator && name == other.name;
  }

  bool isUpdated(Chapter other) {
    bool updated = false;

    if (updated |= (other.url != null) && other.url!.isNotEmpty && (other.url != url)) {
      url = other.url;
    }

    if (updated |= (scanlator != other.scanlator)) {
      scanlator = other.scanlator;
    }

    if (updated |= (dateUpload != other.dateUpload)) {
      dateUpload = other.dateUpload;
    }

    if (updated |= (name != other.name)) {
      name = other.name;
    }

    return updated;
  }

  @ignore
  int get samenessHash => Object.hash(mangaId, scanlator, name);

  @ignore
  ChapterCompositeNumber get compositeOrder {
    return (_order ??= calculateOrder());
  }

  @Index(name: "order")
  double get order {
    final (_, chapter, fraction) = compositeOrder;

    if (fraction == 0) {
      return chapter.toDouble();
    }

    return chapter + fraction.toDouble() / pow(10, (log(fraction) * log10e).floor() + 1);
  }

  int compareTo(Chapter b) {
    final numbers = compareComposite(compositeOrder, b.compositeOrder);

    if (numbers != 0) {
      return numbers;
    }

    return (scanlator ?? '').compareTo(b.scanlator ?? '');
  }

  ChapterCompositeNumber calculateOrder() {
    if ((name ?? '').isNotEmpty) {
      final match = numberRegexp.firstMatch(name!);

      if (match != null) {
        final v = match.namedGroup('v');
        final c = match.namedGroup('c');
        final s = match.namedGroup('s');

        return (
        (v != null) && v.isNotEmpty ? int.parse(v) : 0,
        (c != null) && c.isNotEmpty ? int.parse(c) : 0,
        (s != null) && s.isNotEmpty ? int.parse(s) : 0,
        );
      }
    }

    return (0, 0, 0);
  }
}

final RegExp numberRegexp = RegExp(
  r'((v(\.|ol(\.|ume))\s*(?<v>\d+))\s*)?(c(\.|h(\.|ap(\.|t(\.|er))))\s*)?(?<c>\d+)(\.(?<s>\d+))?',
  caseSensitive: false,
);
