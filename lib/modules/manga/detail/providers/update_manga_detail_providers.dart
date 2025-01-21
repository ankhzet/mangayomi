import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_manga_detail_providers.g.dart';

void setError(int mangaId, String? error) {
  final instance = isar.mangas.getSync(mangaId)!;

  if (error != null) {
    if (kDebugMode) {
      print('Manga ${instance.name} ($mangaId) update error: $error');
    }
  }

  isar.writeTxnSync(() {
    isar.mangas.putSync(instance
      ..lastUpdate = (instance.lastUpdate ?? 0) + 1
      ..updateError = error);
  });
}

@riverpod
Future<void> updateMangaDetail(Ref ref, {required int mangaId, required bool isInit}) async {
  final manga = isar.mangas.getSync(mangaId)!;
  final oldChapters = manga.chapters;
  final hadChapters = oldChapters.isNotEmpty;

  if (hadChapters && isInit) {
    return;
  }

  final source = getSource(manga.lang!, manga.source!);

  if (source == null || !(source.isActive ?? false)) {
    return;
  }

  try {
    Future<MManga> fetch = ref.watch(getDetailProvider(url: manga.link!, source: source).future);
    final MManga? details = await Duration(milliseconds: 100).waitFor(() async {
      try {
        return await fetch;
      } catch (_) {
        final others = await getExtensionService(source).search(manga.name!, 1, []);
        final duplicate = others.list.firstWhereOrNull((dto) => dto.name == manga.name);
        final link = duplicate?.link ?? manga.link!;

        try {
          final other = await ref.watch(getDetailProvider(url: link, source: source).future);

          return other..link = link;
        } catch (e) {
          setError(mangaId, '${source.name!} extension details update returns error (${e.toString()})');
          return null;
        }
      }
    });

    if (details == null) {
      return;
    }

    if (!details.isValid) {
      setError(
          mangaId, '${source.name!} extension details update returns invalid data (${details.toJson().toString()})');

      return;
    }

    final genre = details.genre?.map((e) => e.normalize()).toUnique() ?? [];
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    manga
      ..imageUrl = details.imageUrl ?? manga.imageUrl
      ..name = details.name?.normalize() ?? manga.name
      ..genre = (genre.isEmpty ? null : genre) ?? manga.genre ?? []
      ..author = details.author?.normalize() ?? manga.author ?? ""
      ..artist = details.artist?.normalize() ?? manga.artist ?? ""
      ..status = details.status == Status.unknown ? manga.status : details.status!
      ..description = details.description?.normalize() ?? manga.description ?? ""
      ..link = details.link?.normalize() ?? manga.link
      ..source = manga.source
      ..lang = manga.lang
      ..isManga = source.isManga
      ..updateError = null
      ..lastUpdate = timestamp;

    final timeString = timestamp.toString();
    final mapped = (details.chapters ?? []).map((data) => Chapter(
          name: data.name!.normalize(),
          url: data.url!.normalize(),
          dateUpload: data.dateUpload ?? timeString,
          scanlator: data.scanlator ?? '',
          mangaId: mangaId,
        ));

    final List<Chapter> chapters = [];
    final List<Chapter> deleted = [];
    final List<Chapter> added = [];
    final read = oldChapters.where((chapter) => chapter.isRead == true);
    final lastRead = read.fold<Chapter?>(null, (last, chapter) => (last?.compareTo(chapter) == -1 ? last : chapter));

    if (mapped.isNotEmpty) {
      for (var chapter in mapped) {
        final similar = oldChapters.firstWhereOrNull((item) => item.isSame(chapter));

        if (similar == null) {
          chapter.manga.value = manga;

          if (lastRead?.compareTo(chapter) == -1) {
            chapter.isRead = true;
          }

          chapters.add(chapter);
          added.add(chapter);
        } else if (similar.isUpdated(chapter) && (null == chapters.firstWhereOrNull((item) => item.isSame(similar)))) {
          chapters.add(similar);
        }
      }

      for (var old in oldChapters) {
        if (null == mapped.firstWhereOrNull((item) => old.isSame(item))) {
          // old.isDeleted = true;
          deleted.add(old);
        }
      }
    }

    isar.writeTxnSync(() {
      isar.mangas.putSync(manga);

      if (chapters.isEmpty) {
        return;
      }

      // final notifier = ref.read(changedItemsManagerProvider(managerId: 1).notifier);
      //
      // for (var chap in chapters.reversed.toList()) {
      //   notifier.addUpdatedChapter(chap, deleted.contains(chap), false);
      // }

      isar.chapters.putAllSync(chapters);

      if (hadChapters) {
        // not first update AND has new chapters
        final List<Update> updateBacklog = [];

        for (var chap in chapters.toList()) {
          if (deleted.contains(chap) || !added.contains(chap) || (chap.isRead ?? false)) {
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
  } catch (e, trace) {
    botToast('Update error (${manga.name}): ${e.toString()}');
    await Future.delayed(const Duration(seconds: 5));

    if (kDebugMode) {
      print(e.toString());
      print(trace);
    }
  }
}
