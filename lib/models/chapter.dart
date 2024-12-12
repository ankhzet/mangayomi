import 'dart:math';

import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';
part 'chapter.g.dart';

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
    return (mangaId == other.mangaId) && (
        (url == other.url) || (scanlator == other.scanlator && name == other.name)
    );
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
  (int, int, int) get getNumber {
    if ((name ?? '').isNotEmpty) {
      final match = RegExp(r'((v(\.|ol(\.|ume))\s*(?<v>\d+))\s*)?(c(\.|h(\.|ap(\.|t(\.|er))))\s*)?(?<c>\d+)(\.(?<s>\d+))?', caseSensitive: false).firstMatch(name!);

      if (match != null) {
        final v = match.namedGroup('v');
        final c = match.namedGroup('c');
        final s = match.namedGroup('s');

        return (
          (v ?? '').isNotEmpty ? int.parse(v!) : 0,
          (c ?? '').isNotEmpty ? int.parse(c!) : 0,
          (s ?? '').isNotEmpty ? int.parse(s!) : 0,
        );
      }
    }

    return (0, 0, 0);
  }

  @Index(name: "order")
  double get order {
    (int, int, int) aNumber = getNumber;
    int chapter = aNumber.$2;
    int fraction = aNumber.$3;

    if (fraction == 0) {
      return chapter.toDouble();
    }

    return chapter + fraction.toDouble() / pow(10, (log(fraction) * log10e).floor() + 1);
  }

  int compareTo(Chapter b) {
    (int, int, int) aNumber = getNumber;
    (int, int, int) bNumber = b.getNumber;

    if (aNumber.$2 != bNumber.$2) {
      return aNumber.$2 > bNumber.$2 ? 1 : -1;
    }

    if (aNumber.$3 != bNumber.$3) {
      return aNumber.$3 > bNumber.$3 ? 1 : -1;
    }

    return (scanlator ?? '').compareTo(b.scanlator ?? '');
  }
}
