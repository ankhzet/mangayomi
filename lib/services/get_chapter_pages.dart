import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/lib.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_chapter_pages.g.dart';

class GetChapterPagesModel {
  List<PageUrl> pageUrls = [];
  List<Uint8List?> archiveImages = [];
  List<PreloadTask> preloadTasks;

  GetChapterPagesModel({
    required this.pageUrls,
    required this.archiveImages,
    required this.preloadTasks,
  });
}

// fixme: remove this when extension is patched https://github.com/kodjodevf/mangayomi/issues/228
int patchPages(Source source, List<PageUrl> pages) {
  if (source.typeSource == 'comick') {
    final List<int> delete = [];

    for (var (index, item) in pages.indexed) {
      if (item.url.length <= 4) {
        pages[index - 1].url += '_.${item.url}';
        delete.add(index);
      }
    }

    if (delete.isNotEmpty) {
      for (var idx in delete.reversed) {
        pages.removeAt(idx);
      }

      return delete.length;
    }
  }

  return 0;
}

@riverpod
Future<GetChapterPagesModel> getChapterPages(
  Ref ref, {
  required Chapter chapter,
}) async {
  final settings = isar.settings.first;
  final chapterDirectory = await StorageProvider.getMangaChapterDirectory(chapter);
  final manga = chapter.manga.value!;
  final isLocalArchive = chapter.archivePath?.isNotEmpty ?? false;
  final List<PreloadTask> tasks = [];
  final List<bool> isLocalList = [];
  final List<Uint8List?> archiveImages = [];
  final List<PageUrl> pageUrls = [];

  if (!manga.isLocalArchive!) {
    final data = chapter.getOption(settings.chapterPageUrlsList);
    final source = getSource(manga.lang!, manga.source!)!;
    final Iterable<PageUrl> loaded;

    if (data?.urls?.isNotEmpty ?? false) {
      loaded = data!.urls!.indexed.map((i) => PageUrl(i.$2, headers: data.getUrlHeaders(i.$1))).toList();
    } else {
      loaded = await getExtensionService(source).getPageList(chapter.url!);
    }

    pageUrls.addAll(loaded);

    patchPages(source, pageUrls);
  }

  final model = GetChapterPagesModel(
    pageUrls: pageUrls,
    archiveImages: archiveImages,
    preloadTasks: tasks,
  );

  if (pageUrls.isNotEmpty || isLocalArchive) {
    final mangaDirectory = await StorageProvider.getMangaMainDirectory(manga);
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
        isLocalList.add(await PreloadTask.file(chapterDirectory, i).exists());
      }
    }

    if (isLocalArchive) {
      for (var i = 0; i < archiveImages.length; i++) {
        pageUrls.add(PageUrl(''));
      }
    }

    // .read() ?
    if (!ref.watch(incognitoModeStateProvider)) {
      final List<String> urls = pageUrls.map((e) => e.url).toList();
      final List<String>? headers =
          pageUrls.any((e) => e.headers != null) ? pageUrls.map((e) => jsonEncode(e.headers ?? {})).toList() : null;

      isar.settings.first = settings..chapterPageUrlsList = [
        ...chapter.getOtherOptions(settings.chapterPageUrlsList),
          ChapterPageurls()
            ..chapterId = chapter.id
            ..urls = urls
            ..headers = headers,
      ];
    }

    for (var (idx, item) in pageUrls.indexed) {
      tasks.add(PreloadTask(
        chapter,
        chapterDirectory,
        item,
        isLocalList[idx],
        archiveImages[idx],
        idx,
        model,
      ));
    }
  }

  return model;
}
