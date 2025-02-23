import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/dto/preload_task.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/download_manager/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/services/download_manager/m_downloader.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/get_video_list.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_provider.g.dart';

bool isM3U(Video item) => item.originalUrl.endsWith(".m3u8") || item.originalUrl.endsWith(".m3u");

bool isMedia(Video item) => item.originalUrl.isMediaVideo();

const defaultUA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36";

@riverpod
Future<void> downloadChapter(Ref ref, {required Chapter chapter, bool? useWifi}) async {
  bool onlyOnWifi = useWifi ?? ref.watch(onlyOnWifiStateProvider);
  final connectivity = await Connectivity().checkConnectivity();
  final isOnWifi = connectivity.contains(ConnectivityResult.wifi);

  if (onlyOnWifi && !isOnWifi) {
    botToast(navigatorKey.currentContext!.l10n.downloads_are_limited_to_wifi);
    return;
  }

  final http = MClient.init(reqcopyWith: {'useDartHttpClient': true, 'followRedirects': false});
  final manga = chapter.manga.value!;
  final itemType = chapter.manga.value!.itemType;

  await StorageProvider.requestPermission();
  final mangaDir = await StorageProvider.getMangaMainDirectory(manga);
  final path1 = await StorageProvider.getDownloadsDirectory();
  final finalPath = StorageProvider.getChapterDirectoryRelativePath(chapter);
  final chapterName = chapter.name!.replaceForbiddenCharacters(' ');
  final directory = Directory("$path1$finalPath");

  await directory.create(recursive: true);

  Map<String, String> videoHeaders = {};
  Map<String, String> htmlHeaders = { "Priority": "u=0, i", "User-Agent": defaultUA };
  final archive = itemType == ItemType.manga && ref.watch(saveAsCBZArchiveStateProvider);

  M3u8Downloader? m3u8Downloader;

  final pageUrls = await Duration(seconds: 1).waitFor<List<PageUrl>>(() async {
    if (itemType == ItemType.manga) {
      final urls = (await ref.read(getChapterPagesProvider(chapter: chapter).future)).pageUrls;

      if (urls.isNotEmpty) {
        return urls;
      }
    } else if (itemType == ItemType.anime) {
      final (files, _, _) = await ref.read(getVideoListProvider(episode: chapter).future);
      final candidate = files.firstWhereOrNull(isM3U) ?? files.firstWhereOrNull(isMedia);

      if (candidate != null) {
        final url = candidate.url;
        final headers = candidate.headers;

        if (headers != null) {
          videoHeaders.addAll(headers);
        }

        if (isM3U(candidate)) {
          m3u8Downloader = M3u8Downloader(
            m3u8Url: url,
            downloadDir: directory.path,
            headers: headers ?? {},
            fileName: path.join(mangaDir, "$chapterName.mp4"),
            chapter: chapter,
          );
        } else {
          return [PageUrl(url)];
        }
      }
    } else if (itemType == ItemType.novel && chapter.url != null) {
      final cookie = MClient.getCookiesPref(chapter.url!);

      if (cookie.isNotEmpty) {
        htmlHeaders.addAll(cookie);
        htmlHeaders[HttpHeaders.userAgentHeader] = isar.settings.first.userAgent!;
      }

      final res = await http.get(Uri.parse(chapter.url!), headers: htmlHeaders);

      return (res.headers.containsKey("Location") ? [PageUrl(res.headers["Location"]!)] : [PageUrl(chapter.url!)]);
    }

    return [];
  });

  Future<void> archiveDirectory() async {
    await ref.watch(convertToCBZProvider(directory.path, mangaDir, chapter.name!, pageUrls.length).future);
  }

  Future<void> setProgress(DownloadProgress progress) async {
    if (progress.isCompleted && archive) {
      await archiveDirectory();
    }

    var download =
        isar.downloads.getSync(chapter.id!) ??
        (Download(id: chapter.id, total: 100, isStartDownload: true)..chapter.value = chapter);

    if (download.total! > 0) {
      final succeeded = progress.total == 0 ? 0 : (progress.completed / progress.total * 100).toInt();

      isar.writeTxnSync(() {
        isar.downloads.putSync(
          download
            ..succeeded = succeeded
            ..total = 100
            ..failed = 0
            ..isDownload = progress.isCompleted,
        );
      });
    }
  }

  setProgress(DownloadProgress(0, 0, itemType));

  void savePageUrls() {
    final chapterPageHeaders = pageUrls.map((e) => e.headers == null ? null : jsonEncode(e.headers)).toList();
    final settings = isar.settings.first;
    isar.settings.first =
        settings
          ..chapterPageUrlsList = [
            ...chapter.getOtherOptions(settings.chapterPageUrlsList),
            ChapterPageurls()
              ..chapterId = chapter.id
              ..urls = pageUrls.map((e) => e.url).toList()
              ..chapterUrl = chapter.url
              ..headers =
                  chapterPageHeaders.first != null ? chapterPageHeaders.map((e) => e.toString()).toList() : null,
          ];
  }

  final filtered = pageUrls.where((item) => item.isValid);

  if (filtered.isEmpty && m3u8Downloader == null) {
    return;
  }

  final cbzPath = path.join(mangaDir, "${chapter.name}.cbz");
  final mp4Path = path.join(mangaDir, "$chapterName.mp4");
  final htmlPath = path.join(mangaDir, "$chapterName.html");

  bool isCached = switch (itemType) {
    ItemType.manga => archive && await File(cbzPath).exists(),
    ItemType.anime => await File(mp4Path).exists(),
    ItemType.novel => await File(htmlPath).exists(),
  };

  if (!isCached) {
    List<PageUrl> pages = [];

    for (final (index, page) in filtered.indexed) {
      final cookie = MClient.getCookiesPref(page.url);
      final headers = switch (itemType) {
        ItemType.manga => ref.watch(headersProvider(source: manga.source!, lang: manga.lang!)),
        ItemType.anime => videoHeaders,
        ItemType.novel => htmlHeaders,
      };

      if (cookie.isNotEmpty) {
        headers.addAll(cookie);
        headers[HttpHeaders.userAgentHeader] = isar.settings.first.userAgent!;
      }

      if (page.headers != null) {
        headers.addAll(page.headers!);
      }

      final file = switch (itemType) {
        ItemType.manga => File(path.join(directory.path, PreloadTask.filename(index))),
        ItemType.anime => File(mp4Path),
        ItemType.novel => File(htmlPath),
      };

      if (!file.existsSync()) {
        pages.add(PageUrl(page.url.normalize(), headers: headers, fileName: file.path));
      }
    }

    if (pages.isEmpty && pageUrls.isNotEmpty) {
      if (archive) {
        await archiveDirectory();
      }

      savePageUrls();
      final download = Download(
        id: chapter.id,
        succeeded: 0,
        failed: 0,
        total: 0,
        isDownload: true,
        isStartDownload: false,
      );

      isar.writeTxnSync(() {
        isar.downloads.putSync(download..chapter.value = chapter);
      });
    } else {
      savePageUrls();
      await MDownloader(chapter: chapter, pageUrls: pages).download(setProgress);
    }
  } else if (m3u8Downloader != null) {
    await m3u8Downloader?.download(setProgress);
  }
}
