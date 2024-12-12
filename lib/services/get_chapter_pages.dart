import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/dart/service.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/eval/javascript/service.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_chapter_pages.g.dart';

class GetChapterPagesModel {
  List<PageUrl> pageUrls = [];
  List<Uint8List?> archiveImages = [];
  List<UChapDataPreload> uChapDataPreload;

  GetChapterPagesModel({
    required this.pageUrls,
    required this.archiveImages,
    required this.uChapDataPreload,
  });
}

// fixme: remove this when extension is patched https://github.com/kodjodevf/mangayomi/issues/228
List<PageUrl> patchPages(Source source, List<PageUrl> pages) {
  if (source.typeSource != 'comick') {
    return pages;
  }

  return pages.fold([], (accumulator, item) {
    if (item.url.length <= 4) {
      accumulator[accumulator.length - 1].url += '_.${item.url}';
    } else {
      accumulator.add(item);
    }

    return accumulator;
  });
}

@riverpod
Future<GetChapterPagesModel> getChapterPages(
  Ref ref, {
  required Chapter chapter,
}) async {
  final manga = chapter.manga.value!;
  final settings = isar.settings.getSync(227);
  List<ChapterPageurls>? chapterPageUrlsList = settings!.chapterPageUrlsList ?? [];
  final isarPageUrls = chapterPageUrlsList.where((element) => element.chapterId == chapter.id);
  final incognitoMode = ref.watch(incognitoModeStateProvider);
  final chapterDirectory = await StorageProvider.getMangaChapterDirectory(chapter);
  final mangaDirectory = await StorageProvider.getMangaMainDirectory(manga);
  List<UChapDataPreload> uChapDataPreload = [];
  List<bool> isLocalList = [];
  List<PageUrl> pageUrls = [];
  List<Uint8List?> archiveImages = [];
  final isLocalArchive = (chapter.archivePath ?? '').isNotEmpty;


  if (!manga.isLocalArchive!) {
    final source = getSource(manga.lang!, manga.source!)!;
    final data = isarPageUrls.isNotEmpty ? isarPageUrls.first : null;
    final urls = data?.urls;

    if (urls?.isNotEmpty ?? false) {
      for (var i = 0; i < urls!.length; i++) {
        Map<String, String>? headers;

        if (data!.headers?.isNotEmpty ?? false) {
          headers = (jsonDecode(data.headers![i]) as Map?)?.toMapStringString;
        }

        pageUrls.add(PageUrl(urls[i], headers: headers));
      }
    } else {
      if (source.sourceCodeLanguage == SourceCodeLanguage.dart) {
        pageUrls = await DartExtensionService(source).getPageList(chapter.url!);
      } else {
        pageUrls = await JsExtensionService(source).getPageList(chapter.url!);
      }
    }

    pageUrls = patchPages(source, pageUrls);
  }

  if (pageUrls.isNotEmpty || isLocalArchive) {
    final path = isLocalArchive ? chapter.archivePath! : "$mangaDirectory${chapter.name}.cbz";

    if (isLocalArchive || (await File(path).exists())) {
      final local = await ref.watch(getArchiveDataFromFileProvider(path).future);

      for (var image in local.images!) {
        archiveImages.add(image.image!);
        isLocalList.add(true);
      }
    } else {
      for (var i = 0; i < pageUrls.length; i++) {
        archiveImages.add(null);
        isLocalList.add(
          await UChapDataPreload.file(chapterDirectory, i).exists()
        );
      }
    }
    if (isLocalArchive) {
      for (var i = 0; i < archiveImages.length; i++) {
        pageUrls.add(PageUrl(""));
      }
    }
    if (!incognitoMode) {
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
    for (var i = 0; i < pageUrls.length; i++) {
      uChapDataPreload.add(UChapDataPreload(
        chapter,
        chapterDirectory,
        pageUrls[i],
        isLocalList[i],
        archiveImages[i],
        i,
        GetChapterPagesModel(
          pageUrls: pageUrls,
          archiveImages: archiveImages,
          uChapDataPreload: uChapDataPreload,
        ),
        i,
      ));
    }
  }

  return GetChapterPagesModel(
    pageUrls: pageUrls,
    archiveImages: archiveImages,
    uChapDataPreload: uChapDataPreload,
  );
}
