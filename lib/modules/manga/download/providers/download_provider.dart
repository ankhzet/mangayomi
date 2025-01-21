import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/dto/preload_task.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/background_downloader/background_downloader.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
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
  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true, 'followRedirects': false});
  final manga = chapter.manga.value!;
  final itemType = chapter.manga.value!.itemType;
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
  Map<String, String> videoHeader = {};
  Map<String, String> htmlHeader = {
    "Priority": "u=0, i",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36",
  };
  bool hasM3U8File = false;
  bool nonM3U8File = false;
  M3u8Downloader? m3u8Downloader;
  Uint8List? tsKey;
  Uint8List? tsIv;
  int? m3u8MediaSequence;

  Future<void> processConvert() async {
    if (itemType == ItemType.novel) return;

    if (hasM3U8File) {
      await m3u8Downloader?.mergeTsToMp4(
          path.join(directory.path, "$chapterName.mp4"), path.join(directory.path, chapterName));
    } else {
      if (ref.watch(saveAsCBZArchiveStateProvider)) {
        await ref.watch(
            convertToCBZProvider(directory.path, mangaDir, chapter.name!, pageUrls.map((e) => e.url).toList()).future);
      }
    }
  }

  void savePageUrls() {
    final chapterPageHeaders = pageUrls.map((e) => e.headers == null ? null : jsonEncode(e.headers)).toList();
    final settings = isar.settings.first;
    isar.settings.first = settings
      ..chapterPageUrlsList = [
        ...chapter.getOtherOptions(settings.chapterPageUrlsList),
        ChapterPageurls()
          ..chapterId = chapter.id
          ..urls = pageUrls.map((e) => e.url).toList()
          ..chapterUrl = chapter.url
          ..headers = chapterPageHeaders.first != null ? chapterPageHeaders.map((e) => e.toString()).toList() : null
      ];
  }

  await Duration(seconds: 1).waitFor(() async {
    if (itemType == ItemType.manga) {
      final value = await ref.read(getChapterPagesProvider(chapter: chapter).future);

      if (value.pageUrls.isNotEmpty) {
        pageUrls = value.pageUrls;
      }
    } else if (itemType == ItemType.anime) {
      final (videos, _, _) = await ref.read(getVideoListProvider(episode: chapter).future);
      final m3u8Urls = videos
          .where((element) => element.originalUrl.endsWith(".m3u8") || element.originalUrl.endsWith(".m3u"))
          .toList();
      final nonM3u8Urls = videos.where((element) => element.originalUrl.isMediaVideo()).toList();
      nonM3U8File = nonM3u8Urls.isNotEmpty;
      hasM3U8File = nonM3U8File ? false : m3u8Urls.isNotEmpty;
      final videosUrls = nonM3U8File ? nonM3u8Urls : m3u8Urls;
      if (videosUrls.isNotEmpty) {
        List<TsInfo> tsList = [];
        if (hasM3U8File) {
          m3u8Downloader = M3u8Downloader(
              m3u8Url: videosUrls.first.url,
              downloadDir: path.join(directory.path, chapterName),
              headers: videosUrls.first.headers ?? {});
          (tsList, tsKey, tsIv, m3u8MediaSequence) = await m3u8Downloader!.getTsList();
        }
        pageUrls = hasM3U8File ? [...tsList.map((e) => PageUrl(e.url))] : [PageUrl(videosUrls.first.url)];
        videoHeader.addAll(videosUrls.first.headers ?? {});
      }
    } else if (itemType == ItemType.novel && chapter.url != null) {
      final cookie = MClient.getCookiesPref(chapter.url!);

      if (cookie.isNotEmpty) {
        final userAgent = isar.settings.first.userAgent!;
        htmlHeader.addAll(cookie);
        htmlHeader[HttpHeaders.userAgentHeader] = userAgent;
      }
      final res = await http.get(Uri.parse(chapter.url!), headers: htmlHeader);
      if (res.headers.containsKey("Location")) {
        pageUrls = [PageUrl(res.headers["Location"]!)];
      } else {
        pageUrls = [PageUrl(chapter.url!)];
      }
    }
  });

  final filtered = pageUrls.where((item) => item.isValid);

  if (filtered.isEmpty) {
    return [];
  }

  final urls = filtered.map((e) => e.url).toList();

  bool shouldLoad = switch (itemType) {
    ItemType.manga =>
      !(ref.watch(saveAsCBZArchiveStateProvider) && await File(path.join(mangaDir, "${chapter.name}.cbz")).exists()),
    ItemType.anime => !(await File(path.join(mangaDir, "$chapterName.mp4")).exists()),
    ItemType.novel => !await File(path.join(mangaDir, "$chapterName.html")).exists(),
  };

  if (shouldLoad) {
    await directory.create(recursive: true);

    for (final (index, page) in filtered.indexed) {
      final cookie = MClient.getCookiesPref(page.url);
      final headers = switch (itemType) {
        ItemType.manga => ref.watch(headersProvider(source: manga.source!, lang: manga.lang!)),
        ItemType.anime => videoHeader,
        ItemType.novel => htmlHeader,
      };

      if (cookie.isNotEmpty) {
        headers.addAll(cookie);
        headers[HttpHeaders.userAgentHeader] = isar.settings.first.userAgent!;
      }

      if (page.headers != null) {
        headers.addAll(page.headers!);
      }

      Future<void> scheduleLoad(String filename) async {
        final uri = path.join('Mangayomi', finalPath, filename);
        final tmp = File(path.join(tempDir.path, uri));
        final target = File(path.join(directory.path, filename));

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

      switch (itemType) {
        case ItemType.manga:
          {
            await scheduleLoad(PreloadTask.filename(index));
          }
        case ItemType.novel:
          {
            await scheduleLoad('$chapterName.html');
          }
        case ItemType.anime:
          {
            await scheduleLoad('$chapterName.mp4');

            if (hasM3U8File) {
              await scheduleLoad(path.join(chapterName, 'TS_${index + 1}.ts'));
            }
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
      taskIds: urls,
      isStartDownload: false,
      chapterId: chapter.id,
      mangaId: manga.id,
    );

    isar.writeTxnSync(() {
      isar.downloads.putSync(download..chapter.value = chapter);
    });
  } else {
    if (hasM3U8File) {
      await Directory(path.join(directory.path, chapterName)).create(recursive: true);
    }

    savePageUrls();

    final isBatch = itemType == ItemType.manga || itemType == ItemType.novel || hasM3U8File;

    await FileDownloader().downloadBatch(
      tasks,
      batchProgressCallback: (succeeded, failed) async {
        if (!isBatch) {
          return;
        }

        if (succeeded == tasks.length) {
          await processConvert();
        }

        final download = isar.downloads.filter().chapterIdEqualTo(chapter.id!).findFirstSync() ??
            Download(
              chapterId: chapter.id,
              mangaId: manga.id,
              total: tasks.length,
              taskIds: urls,
              isStartDownload: true,
            )
          ..chapter.value = chapter;

        isar.writeTxnSync(() {
          isar.downloads.putSync(download
            ..succeeded = succeeded
            ..failed = failed
            ..isDownload = succeeded == tasks.length);
        });
      },
      taskProgressCallback: (taskProgress) async {
        final progress = taskProgress.progress;
        final percent = (progress * 100).toInt();
        final isDone = percent >= 100;

        if (!isBatch) {
          final download = isar.downloads.filter().chapterIdEqualTo(chapter.id!).findFirstSync() ??
              Download(
                chapterId: chapter.id,
                mangaId: manga.id,
                total: 100,
                taskIds: urls,
                isStartDownload: true,
              )
            ..chapter.value = chapter;

          isar.writeTxnSync(() {
            isar.downloads.putSync(download
              ..failed = 0
              ..succeeded = percent
              ..isDownload = isDone);
          });
        }

        if (isDone) {
          final file = File(path.join(tempDir.path, taskProgress.task.directory, taskProgress.task.filename));
          final target = hasM3U8File
              ? path.join(directory.path, chapterName, taskProgress.task.filename)
              : path.join(directory.path, taskProgress.task.filename);

          final newFile = await file.copy(target);
          await file.delete();

          if (hasM3U8File) {
            await m3u8Downloader?.processBytes(newFile, tsKey, tsIv, m3u8MediaSequence);
          }
        }
      },
    );
  }

  return filtered.toList();
}
