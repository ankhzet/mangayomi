import 'dart:math';

import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';

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
  Id? id;

  int? mangaId;

  String? name;

  String? url;

  String? dateUpload;

  String? scanlator;

  bool? isBookmarked;

  bool? isRead;

  String? lastPageRead;

  ///Only for local archive Comic
  String? archivePath;

  final manga = IsarLink<Manga>();

  Chapter(
      {this.id = Isar.autoIncrement,
      required this.mangaId,
      required this.name,
      this.url = '',
      this.dateUpload = '',
      this.isBookmarked = false,
      this.scanlator = '',
      this.isRead = false,
      this.lastPageRead = '',
      this.archivePath = ''});

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
  ChapterCompositeNumber get getNumber {
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

  @Index(name: "order")
  double get order {
    final (_, chapter, fraction) = getNumber;

    if (fraction == 0) {
      return chapter.toDouble();
    }

    return chapter + fraction.toDouble() / pow(10, (log(fraction) * log10e).floor() + 1);
  }

  int compareTo(Chapter b) {
    final numbers = compareComposite(getNumber, b.getNumber);

    if (numbers != 0) {
      return numbers;
    }

    return (scanlator ?? '').compareTo(b.scanlator ?? '');
  }
}

final RegExp numberRegexp = RegExp(
  r'((v(\.|ol(\.|ume))\s*(?<v>\d+))\s*)?(c(\.|h(\.|ap(\.|t(\.|er))))\s*)?(?<c>\d+)(\.(?<s>\d+))?',
  caseSensitive: false,
);
