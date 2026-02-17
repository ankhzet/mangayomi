import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/m_downloader.dart';

extension ChapterExtension on Chapter {
  Future<void> pushToReaderView(
    BuildContext context, {
    bool ignoreIsRead = false,
  }) async {
    if (ignoreIsRead || !isRead!) {
      await pushMangaReaderView(context: context, chapter: this);
    } else {
      final filteredChaps = manga.value!.getFilteredChapterList();
      bool exist = false;
      for (var filteredChap in filteredChaps.reversed) {
        if (filteredChap.toJson().toString() == toJson().toString()) {
          exist = true;
        }
        if (exist && !filteredChap.isRead!) {
          await pushMangaReaderView(context: context, chapter: filteredChap);
          break;
        }
      }
    }
  }

  void cancelDownloads(int? downloadId) {
    DownloadIsolatePool.instance.cancelTask('$id');
    DownloadIsolatePool.instance.cancelTask('m3u8_$id');

    isolateChapsSendPorts.remove('$id');

    isar.writeTxnSync(() {
      isar.downloads.deleteSync(id!);
      if (downloadId != null) {
        isar.downloads.deleteSync(downloadId);
      }
    });
  }

  static bool isChapterRead(Chapter chapter) => chapter.isRead ?? false;
  static bool isChapterUnread(Chapter chapter) => !(chapter.isRead ?? false);
  static bool isChapterBookmarked(Chapter chapter) =>
      chapter.isBookmarked ?? false;
  static bool hasChapterScanlators(Chapter chapter) =>
      chapter.scanlator?.isNotEmpty ?? false;

  static DateTime? firstUpload(List<Chapter> chapters) {
    if (chapters.isEmpty) return null;
    DateTime? earliest;
    for (var chapter in chapters) {
      if (chapter.dateUpload != null && chapter.dateUpload!.isNotEmpty) {
        final timestamp = int.tryParse(chapter.dateUpload!);
        if (timestamp != null) {
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
          if (earliest == null || date.isBefore(earliest)) {
            earliest = date;
          }
        }
      }
    }
    return earliest;
  }

  static String fullTitle(List<Chapter> chapters) {
    if (chapters.isEmpty) return '';
    final first = chapters.first;
    return first.name ?? '';
  }

  String progress() {
    if (lastPageRead == null || lastPageRead!.isEmpty || lastPageRead == '1') {
      return '';
    }
    return lastPageRead!;
  }
}
