import 'dart:math';

import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_manga_detail_providers.g.dart';

@riverpod
Future<dynamic> updateMangaDetail(Ref ref, {required int? mangaId, required bool isInit, bool showToast = true}) async {
  try {
    final manga = isar.mangas.getSync(mangaId!);

    if ((manga!.isLocalArchive ?? false) || (manga.chapters.isNotEmpty && isInit)) {
      return;
    }

    final source = getSource(manga.lang!, manga.source!, manga.sourceId, installedOnly: true);

    if (source == null || source.isActive != true) {
      return;
    }

    MManga getManga = await ref.read(getDetailProvider(url: manga.link!, source: source).future);

    final shouldBail = isInit && isar.chapters.where().mangaIdEqualTo(mangaId).isNotEmptySync();

    if (shouldBail) {
      return;
    }

    final genre = getManga.genre?.map((e) => e.trim()).toUnique();
    final imgUrl = getManga.imageUrl.trimmedOrDefault(manga.imageUrl);
    final now = DateTime.now().millisecondsSinceEpoch;

    manga
      ..imageUrl = imgUrl == null
          ? null
          : imgUrl.startsWith('http')
          ? imgUrl
          : '${source.baseUrl ?? ''}/${imgUrl.getUrlWithoutDomain}'
      ..name = getManga.name.trimmedOrDefault(manga.name)
      ..genre = (genre?.isNotEmpty == true ? genre : manga.genre) ?? []
      ..author = getManga.author.trimmedOrDefault(manga.author) ?? ""
      ..artist = getManga.artist.trimmedOrDefault(manga.artist) ?? ""
      ..status = getManga.status == Status.unknown ? manga.status : getManga.status ?? Status.unknown
      ..description = getManga.description.trimmedOrDefault(manga.description) ?? ""
      ..link = getManga.link.trimmedOrDefault(manga.link)
      ..source = manga.source
      ..lang = manga.lang
      ..itemType = source.itemType
      ..lastUpdate = now
      ..updatedAt = now;

    return isar.writeTxnSync(() {
      final mangaId = isar.mangas.putSync(manga);
      final wasEmpty = manga.chapters.isEmpty;
      final chaps = getManga.chapters ?? [];

      manga.lastUpdate = now;

      List<Chapter> added = [];
      List<Chapter> updated = [];

      if (chaps.isNotEmpty) {
        if (wasEmpty) {
          added = chaps.map((fetched) => fetched.toChapter(mangaId, manga)).toList(growable: false);
        } else {
          void fallbackMatch() {
            // try to reconcile based on chapter number
            List<Chapter> existing = manga.chapters.toList();

            for (var fetched in chaps.reversed) {
              final candidate = fetched.toChapter(mangaId, manga);
              final found = existing.where((chapter) => chapter.isSameNumber(candidate));
              final resolved = switch (found.length) {
                0 => null,
                1 => found.first,
                _ => (() {
                  // multiple scanlators or chapter number collision
                  final match = found.firstWhereOrNull(
                    (chapter) => (fetched.url == chapter.url) || (fetched.legacyUrl == chapter.url),
                  );
                  final resolved = match ?? found.first;

                  existing.remove(resolved);

                  return resolved;
                })(),
              };

              if (resolved != null) {
                if (resolved.apply(candidate)) {
                  updated.add(resolved);
                }
              } else {
                added.add(candidate);
              }
            }
          }

          final hasUids = chaps.any((chapter) => chapter.hasUid());

          if (hasUids) {
            final bool storedUids = manga.chapters.any((chapter) => chapter.hasUid());

            if (storedUids) {
              // already uid-ed
              for (var fetched in chaps.reversed) {
                final candidate = fetched.toChapter(mangaId, manga);
                final uid = fetched.uid;
                final found = manga.chapters.where((chapter) => chapter.uid == uid);

                if (found.isNotEmpty) {
                  final resolved = found.first;

                  if (resolved.apply(candidate)) {
                    updated.add(resolved);
                  }

                  if (found.length > 1) {
                    isar.chapters.deleteAllSync(found.skip(1).map((i) => i.id).toList());
                  }

                  final candidates = manga.chapters.where((chapter) => chapter.isSameNumber(candidate));

                  if (candidates.isNotEmpty) {
                    final duplicates = candidates
                        .map((chapter) => ({ chapter.scanlator: [chapter] }))
                        .reduce((acc, map) {
                          final MapEntry(:key, :value) = map.entries.first;
                          final bucket = acc[key];

                          if (bucket == null) {
                            acc[key] = value;
                          } else {
                            bucket.addAll(value);
                          }

                          return acc;
                        })
                        .values
                        .where((list) => list.length > 1);

                    for (final chapters in duplicates) {
                      isar.chapters.deleteAllSync(chapters.skip(1).map((i) => i.id).toList());
                    }
                  }
                } else {
                  added.add(candidate);
                }
              }
            } else {
              fallbackMatch();
            }
          } else {
            fallbackMatch();
          }
        }
      }

      final allChanged = updated.followedBy(added).toList();
      isar.chapters.putAllSync(allChanged);

      for (var chapter in added) {
        chapter.manga.saveSync();
      }

      if (!wasEmpty) {
        final date = now.toString();
        // skip creating updates if:
        final skip = manga.chapters
            // 1. chapter already read
            .where((chapter) => chapter.isRead == true)
            // 2. update already registered
            .followedBy(
              isar.updates
                  .where()
                  .mangaIdEqualTo(mangaId)
                  .findAllSync()
                  .map((update) => update.chapter.value)
                  .whereType<Chapter>(),
            )
            .toSet();

        final updates = added.reversed
            .where((chapter) => !skip.any((other) => other.isSameNumber(chapter)))
            .map((chapter) => (
              Update(mangaId: mangaId, chapterName: chapter.name, date: date, updatedAt: now)
                ..chapter.value = chapter
            ))
            .toList(growable: false);

        isar.updates.putAllSync(updates);

        for (var update in updates) {
          update.chapter.saveSync();
        }
      }

      if (allChanged.isNotEmpty) { // no need to recalculate if nothing changed
        final withDates = chaps.where((chapter) => chapter.dateUpload != null);
        final intervals = withDates.length - 1;

        if (intervals > 0) {
          final dates = withDates
              .map((chapter) => int.parse(chapter.dateUpload!))
              .sorted()
              .map((timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp))
              .toList(growable: false);
          final daysBetweenUploads = dates
              .take(intervals)
              .indexed
              .map((i) => -i.$2.difference(dates[i.$1 + 1]).inDays);

          if (daysBetweenUploads.isNotEmpty) {
            final diffs = daysBetweenUploads.toList(growable: false);
            final median = diffs.median();
            final smartUpdateDays = max(median, diffs.arithmeticMean());

            if (manga.smartUpdateDays != smartUpdateDays) {
              isar.mangas.putSync(
                manga
                  ..id = mangaId
                  ..smartUpdateDays = smartUpdateDays,
              );
            }
          }
        }
      }

      return true;
    });
  } catch (e, s) {
    if (showToast) {
      botToast('$e\n$s');
    } else {
      rethrow;
    }

    return;
  }
}

extension DefaultValueExtension on String? {
  String? trimmedOrDefault(String? defaultValue) {
    final trimmed = this?.trim();

    return trimmed?.isNotEmpty == true ? trimmed : defaultValue;
  }
}

extension MUidUtils on MChapter {
  bool hasUid() {
    return uid?.isNotEmpty == true;
  }

  Chapter toChapter(int mangaId, Manga manga) {
    return Chapter(
      name: name!,
      url: url!.trim(),
      dateUpload: dateUpload == null ? DateTime.now().millisecondsSinceEpoch.toString() : dateUpload.toString(),
      scanlator: scanlator ?? '',
      mangaId: mangaId,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      isFiller: isFiller,
      thumbnailUrl: thumbnailUrl,
      description: description,
      downloadSize: downloadSize,
      duration: duration,
      uid: uid ?? '',
    )..manga.value = manga;
  }
}

extension ChapterUtils on Chapter {
  bool hasUid() {
    return uid?.isNotEmpty == true;
  }

  bool isNotEqual(Chapter other) {
    return (name != other.name ||
        url != other.url ||
        scanlator != other.scanlator ||
        dateUpload != other.dateUpload ||
        (isFiller ?? false) != (other.isFiller ?? false) ||
        thumbnailUrl != other.thumbnailUrl ||
        description != other.description ||
        downloadSize != other.downloadSize ||
        duration != other.duration ||
        uid != other.uid);
  }

  bool apply(Chapter update) {
    if (isNotEqual(update)) {
      name = update.name;
      url = update.url;
      scanlator = update.scanlator;
      dateUpload = update.dateUpload;
      isFiller = update.isFiller;
      thumbnailUrl = update.thumbnailUrl;
      description = update.description;
      downloadSize = update.downloadSize;
      duration = update.duration;
      uid = update.uid;
      updatedAt = DateTime.now().millisecondsSinceEpoch;

      return true;
    }

    return false;
  }
}
