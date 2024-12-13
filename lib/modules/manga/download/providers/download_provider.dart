import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/background_downloader/background_downloader.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_provider.g.dart';

@riverpod
Future<List<PageUrl>> downloadChapter(
  Ref ref, {
  required Chapter chapter,
  bool? useWifi,
}) async {
  final manga = chapter.manga.value!;
  final isManga = chapter.manga.value!.isManga!;
  await StorageProvider.requestPermission();
  final tempDir = await getTemporaryDirectory();
  final mangaDir = await StorageProvider.getMangaMainDirectory(manga);
  final path1 = await StorageProvider.getDownloadsDirectory();
  final finalPath = StorageProvider.getChapterDirectoryRelativePath(chapter);
  final chapterName = chapter.name!.replaceForbiddenCharacters(' ');
  final onlyOnWifi = useWifi ?? ref.watch(onlyOnWifiStateProvider) ?? false;

  List<PageUrl> pageUrls = [];
  List<DownloadTask> tasks = [];
  Directory directory = Directory("$path1$finalPath");
  bool isOk = false;
  Map<String, String> videoHeader = {};
  bool hasM3U8File = false;
  bool nonM3U8File = false;
  M3u8Downloader? m3u8Downloader;
  Uint8List? tsKey;
  Uint8List? tsIv;
  int? m3u8MediaSequence;

  Future<void> processConvert() async {
    if (hasM3U8File) {
      await m3u8Downloader?.mergeTsToMp4("${directory.path}/$chapterName.mp4", "${directory.path}/$chapterName");
    } else {
      if (ref.watch(saveAsCBZArchiveStateProvider)) {
        await ref.watch(
            convertToCBZProvider(directory.path, mangaDir, chapter.name!, pageUrls.map((e) => e.url).toList()).future);
      }
    }
  }

  void savePageUrls() {
    final settings = isar.settings.first;
    List<ChapterPageurls>? chapterPageUrls = [];
    for (var chapterPageUrl in settings.chapterPageUrlsList ?? []) {
      if (chapterPageUrl.chapterId != chapter.id) {
        chapterPageUrls.add(chapterPageUrl);
      }
    }
    final chapterPageHeaders = pageUrls.map((e) => e.headers == null ? null : jsonEncode(e.headers)).toList();
    chapterPageUrls.add(ChapterPageurls()
      ..chapterId = chapter.id
      ..urls = pageUrls.map((e) => e.url).toList()
      ..headers = chapterPageHeaders.first != null ? chapterPageHeaders.map((e) => e.toString()).toList() : null);
    isar.writeTxnSync(() => isar.settings.putSync(settings..chapterPageUrlsList = chapterPageUrls));
  }

  if (isManga) {
    ref.read(getChapterPagesProvider(chapter: chapter).future).then((value) {
      if (value.pageUrls.isNotEmpty) {
        pageUrls = value.pageUrls;
        isOk = true;
      }
    });
  } else {
    ref.read(getVideoListProvider(episode: chapter).future).then((value) async {
      final m3u8Urls = value.$1
          .where((element) => element.originalUrl.endsWith(".m3u8") || element.originalUrl.endsWith(".m3u"))
          .toList();
      final nonM3u8Urls = value.$1.where((element) => element.originalUrl.isMediaVideo()).toList();
      nonM3U8File = nonM3u8Urls.isNotEmpty;
      hasM3U8File = nonM3U8File ? false : m3u8Urls.isNotEmpty;
      final videosUrls = nonM3U8File ? nonM3u8Urls : m3u8Urls;
      if (videosUrls.isNotEmpty) {
        List<TsInfo> tsList = [];
        if (hasM3U8File) {
          m3u8Downloader = M3u8Downloader(
              m3u8Url: videosUrls.first.url,
              downloadDir: "${directory.path}/$chapterName",
              headers: videosUrls.first.headers ?? {});
          (tsList, tsKey, tsIv, m3u8MediaSequence) = await m3u8Downloader!.getTsList();
        }
        pageUrls = hasM3U8File ? [...tsList.map((e) => PageUrl(e.url))] : [PageUrl(videosUrls.first.url)];
        videoHeader.addAll(videosUrls.first.headers ?? {});
        isOk = true;
      }
    });
  }

  await Future.doWhile(() async {
    await Future.delayed(const Duration(seconds: 1));
    if (isOk == true) {
      return false;
    }
    return true;
  });

  if (pageUrls.isNotEmpty) {
    bool shouldLoad = (isManga
        ? !(ref.watch(saveAsCBZArchiveStateProvider) && await File("$mangaDir${chapter.name}.cbz").exists())
        : !(await File("$mangaDir$chapterName.mp4").exists()));

    if (shouldLoad) {
      await directory.create(recursive: true);

      for (var index = 0; index < pageUrls.length; index++) {
        final page = pageUrls[index];
        final cookie = MClient.getCookiesPref(page.url);
        final headers = isManga ? ref.watch(headersProvider(source: manga.source!, lang: manga.lang!)) : videoHeader;

        if (cookie.isNotEmpty) {
          final userAgent = isar.settings.first.userAgent!;
          headers.addAll(cookie);
          headers[HttpHeaders.userAgentHeader] = userAgent;
        }

        headers.addAll(page.headers ?? {});

        Future<void> scheduleLoad(String filename) async {
          final uri = 'Mangayomi/$finalPath/$filename';
          final tmp = File('${tempDir.path}/$uri');
          final target = File('${directory.path}/$filename');

          target.parent.createSync(recursive: true);

          if (tmp.existsSync()) {
            await tmp.copy(target.path);
            await tmp.delete();
          } else if (!target.existsSync()) {
            tasks.add(DownloadTask(
              taskId: page.url,
              headers: headers,
              url: page.url.normalize(),
              baseDirectory: BaseDirectory.temporary,
              updates: Updates.statusAndProgress,
              allowPause: true,
              retries: 3,
              requiresWiFi: onlyOnWifi,
              directory: path.dirname(uri),
              filename: path.basename(uri),
            ));
          }
        }

        if (isManga) {
          await scheduleLoad(UChapDataPreload.filename(index));
        } else {
          await scheduleLoad('$chapterName.mp4');

          if (hasM3U8File) {
            await scheduleLoad('$chapterName/TS_${index + 1}.ts');
          }
        }
      }
    }

    if (tasks.isEmpty && pageUrls.isNotEmpty) {
      await processConvert();
      savePageUrls();
      final download = Download(
          succeeded: 0,
          failed: 0,
          total: 0,
          isDownload: true,
          taskIds: pageUrls.map((e) => e.url).toList(),
          isStartDownload: false,
          chapterId: chapter.id,
          mangaId: manga.id);

      isar.writeTxnSync(() {
        isar.downloads.putSync(download..chapter.value = chapter);
      });
    } else {
      if (hasM3U8File) {
        await Directory("${directory.path}/$chapterName").create(recursive: true);
      }
      savePageUrls();
      await FileDownloader().downloadBatch(
        tasks,
        batchProgressCallback: (succeeded, failed) async {
          if (isManga || hasM3U8File) {
            if (succeeded == tasks.length) {
              await processConvert();
            }
            bool isEmpty = isar.downloads.filter().chapterIdEqualTo(chapter.id!).isEmptySync();
            if (isEmpty) {
              final download = Download(
                  succeeded: succeeded,
                  failed: failed,
                  total: tasks.length,
                  isDownload: (succeeded == tasks.length),
                  taskIds: pageUrls.map((e) => e.url).toList(),
                  isStartDownload: true,
                  chapterId: chapter.id,
                  mangaId: manga.id);
              isar.writeTxnSync(() {
                isar.downloads.putSync(download..chapter.value = chapter);
              });
            } else {
              final download = isar.downloads.filter().chapterIdEqualTo(chapter.id!).findFirstSync()!;
              isar.writeTxnSync(() {
                isar.downloads.putSync(download
                  ..succeeded = succeeded
                  ..failed = failed
                  ..isDownload = (succeeded == tasks.length));
              });
            }
          }
        },
        taskProgressCallback: (taskProgress) async {
          final progress = taskProgress.progress;
          if (!isManga && !hasM3U8File) {
            bool isEmpty = isar.downloads.filter().chapterIdEqualTo(chapter.id!).isEmptySync();
            if (isEmpty) {
              final download = Download(
                  succeeded: (progress * 100).toInt(),
                  failed: 0,
                  total: 100,
                  isDownload: (progress == 1.0),
                  taskIds: pageUrls.map((e) => e.url).toList(),
                  isStartDownload: true,
                  chapterId: chapter.id,
                  mangaId: manga.id);
              isar.writeTxnSync(() {
                isar.downloads.putSync(download..chapter.value = chapter);
              });
            } else {
              final download = isar.downloads.filter().chapterIdEqualTo(chapter.id!).findFirstSync()!;
              isar.writeTxnSync(() {
                isar.downloads.putSync(download
                  ..succeeded = (progress * 100).toInt()
                  ..failed = 0
                  ..isDownload = (progress == 1.0));
              });
            }
          }
          if (progress == 1.0) {
            final file = File("${tempDir.path}/${taskProgress.task.directory}/${taskProgress.task.filename}");
            final newFile =
                await file.copy("${directory.path}/${hasM3U8File ? "$chapterName/" : ""}${taskProgress.task.filename}");
            await file.delete();
            if (hasM3U8File) {
              await m3u8Downloader?.processBytes(newFile, tsKey, tsIv, m3u8MediaSequence);
            }
          }
        },
      );
    }
  }
  return pageUrls;
}
