import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/eval/dart/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_manga_detail_providers.g.dart';

@riverpod
Future<dynamic> updateMangaDetail(Ref ref, {required int? mangaId, required bool isInit}) async {
  final manga = isar.mangas.getSync(mangaId!)!;

  if (manga.chapters.isNotEmpty && isInit) {
    return;
  }

  final source = getSource(manga.lang!, manga.source!);

  try {
    MManga getManga = await ref.watch(getDetailProvider(url: manga.link!, source: source!).future);

    final genre = getManga.genre?.map((e) => e.normalize()).toUnique() ?? [];

    manga
      ..imageUrl = getManga.imageUrl ?? manga.imageUrl
      ..name = getManga.name?.normalize() ?? manga.name
      ..genre = (genre.isEmpty ? null : genre) ?? manga.genre ?? []
      ..author = getManga.author?.normalize() ?? manga.author ?? ""
      ..artist = getManga.artist?.normalize() ?? manga.artist ?? ""
      ..status = getManga.status == Status.unknown ? manga.status : getManga.status!
      ..description = getManga.description?.normalize() ?? manga.description ?? ""
      ..link = getManga.link?.normalize() ?? manga.link
      ..source = manga.source
      ..lang = manga.lang
      ..isManga = source.isManga
      ..lastUpdate = DateTime.now().millisecondsSinceEpoch;

    final hadChapters = isar.mangas.getSync(mangaId)!.chapters.isNotEmpty;

    if (hadChapters && isInit) {
      return;
    }

    isar.writeTxnSync(() {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final timeString = timestamp.toString();
      final List<Chapter> chapters = [];
      final List<Chapter> deleted = [];
      final List<Chapter> added = [];
      final oldChaptersList = manga.chapters;
      final updatedChaptersList = getManga.chapters;

      isar.mangas.putSync(manga);
      manga.lastUpdate = timestamp;

      if (updatedChaptersList != null && updatedChaptersList.isNotEmpty) {
        final mapped = updatedChaptersList.map((data) => Chapter(
              name: data.name!.normalize(),
              url: data.url!.normalize(),
              dateUpload: data.dateUpload ?? timeString,
              scanlator: data.scanlator ?? '',
              mangaId: mangaId,
            ));

        for (var chapter in mapped) {
          final similar = oldChaptersList.firstWhereOrNull((item) => item.isSame(chapter));

          if (similar == null) {
            chapter.manga.value = manga;
            chapters.add(chapter);
            added.add(chapter);
          } else if (similar.isUpdated(chapter) &&
              (null == chapters.firstWhereOrNull((item) => item.isSame(similar)))) {
            chapters.add(similar);
          }
        }

        for (var old in oldChaptersList) {
          if (null == mapped.firstWhereOrNull((item) => old.isSame(item))) {
            // old.isDeleted = true;
            deleted.add(old);
          }
        }
      }

      if (chapters.isEmpty) {
        return;
      }

      final notifier = ref.read(changedItemsManagerProvider(managerId: 1).notifier);
      manga.lastUpdate = timestamp;

      for (var chap in chapters.reversed.toList()) {
        notifier.addUpdatedChapter(chap, deleted.contains(chap), false);
      }

      isar.chapters.putAllSync(chapters);

      if (hadChapters) {
        // not first update AND has new chapters
        final List<Update> updateBacklog = [];

        for (var chap in chapters.reversed.toList()) {
          if (deleted.contains(chap) || !added.contains(chap)) {
            continue;
          }

          final update = Update(
            mangaId: mangaId,
            chapterName: chap.name,
            date: timeString,
          )..chapter.value = chap;
          updateBacklog.add(update);
        }

        isar.updates.putAllSync(updateBacklog);
      }
    });
  } catch (e) {
    botToast(e.toString());

    if (kDebugMode) {
      print(e.toString());
    }
  }
}
