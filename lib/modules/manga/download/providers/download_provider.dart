import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/dto/preload_task.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/convert_to_cbz.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/services/get_video_list.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'download_provider.g.dart';

@riverpod
Future<void> downloadChapter(Ref ref, {
  required Chapter chapter,
  bool? useWifi,
}) async {
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
  final tempDir = await getTemporaryDirectory();
  final mangaDir = await StorageProvider.getMangaMainDirectory(manga);
  final path1 = await StorageProvider.getDownloadsDirectory();
  final finalPath = StorageProvider.getChapterDirectoryRelativePath(chapter);
  final chapterName = chapter.name!.replaceForbiddenCharacters(' ');

  List<PageUrl> pageUrls = [];
  List<PageUrl> pages = [];

  Directory directory = Directory("$path1$finalPath");

  await directory.create(recursive: true);

  Map<String, String> videoHeader = {};
  Map<String, String> htmlHeader = {
    "Priority": "u=0, i",
    "User-Agent":
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36",
  };
  bool hasM3U8File = false;
  bool nonM3U8File = false;
  M3u8Downloader? m3u8Downloader;

  Future<void> processConvert() async {
    if (ref.watch(saveAsCBZArchiveStateProvider)) {
      await ref.watch(
          convertToCBZProvider(directory.path, mangaDir, chapter.name!, pageUrls.map((e) => e.url).toList()).future);
    }

    Future<void> setProgress(DownloadProgress progress) async {
      if (progress.isCompleted && itemType == ItemType.manga) {
        await processConvert();
      }
      final download = isar.downloads.getSync(chapter.id!);
      final succeeded = progress.completed == 0 ? 0 : (progress.completed / progress.total * 100).toInt();

      if (download == null) {
        final download = Download(
          id: chapter.id,
          succeeded: succeeded,
          failed: 0,
          total: 100,
          isDownload: progress.isCompleted,
          isStartDownload: true,
        );
        isar.writeTxnSync(() {
          isar.downloads.putSync(download..chapter.value = chapter);
        });
      } else {
        final download = isar.downloads.getSync(chapter.id!);
        if (download != null && progress.total != 0) {
          isar.writeTxnSync(() {
            isar.downloads.putSync(download
              ..succeeded = succeeded
              ..total = 100
              ..failed = 0
              ..isDownload = progress.isCompleted);
          });
        }
      }
    }

    setProgress(DownloadProgress(0, 0, itemType));

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
          if (hasM3U8File) {
            m3u8Downloader = M3u8Downloader(
                m3u8Url: videosUrls.first.url,
                downloadDir: path.join(directory.path, chapterName),
                headers: videosUrls.first.headers ?? {},
                fileName: path.join(mangaDir, "$chapterName.mp4"),
                chapter: chapter);
          } else {
            pageUrls = [PageUrl(videosUrls.first.url)];
          }
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
      return;
    }

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

        if (itemType == ItemType.manga) {
          final file = File(path.join(directory.path, PreloadTask.filename(index)));

          if (!file.existsSync()) {
            pages.add(PageUrl(
              page.url.normalize(),
              headers: headers,
              fileName: file.path,
            ));
          }
        } else if (itemType == ItemType.anime) {
          final file = File(path.join(mangaDir, "$chapterName.mp4"));

          if (!file.existsSync()) {
            pages.add(PageUrl(
              page.url.normalize(),
              headers: headers,
              fileName: file.path,
            ));
          }
        } else {
          final file = File(path.join(directory.path, "$chapterName.html"));

          if (!file.existsSync()) {
            pages.add(PageUrl(
              page.url.normalize(),
              headers: headers,
              fileName: file.path,
            ));
          }
        }
      }

      if (pages.isEmpty && pageUrls.isNotEmpty) {
        await processConvert();
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
    } else if (hasM3U8File) {
      await m3u8Downloader?.download(setProgress);
    }
  }
