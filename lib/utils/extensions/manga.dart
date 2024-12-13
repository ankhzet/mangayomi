import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/detail/chapters_list_model.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/headers.dart';

extension MangaExtension on Manga {
  bool isThisManga<T extends OfManga>(T element) => element.mangaId == id;

  bool isNotThisManga<T extends OfManga>(T element) => element.mangaId != id;

  T? getOption<T extends OfManga>(List<T>? list) => list?.where(isThisManga).firstOrNull;

  List<T> getOtherOptions<T extends OfManga>(List<T>? list) => list?.where(isNotThisManga).toList() ?? [];

  ImageProvider imageProvider(WidgetRef ref, {Duration? cacheMaxAge}) {
    if (customCoverImage == null) {
      return CustomExtendedNetworkImageProvider(
        toImgUrl(customCoverFromTracker ?? imageUrl!),
        headers: ref.watch(headersProvider(source: source!, lang: lang!)),
        cacheMaxAge: cacheMaxAge ?? const Duration(days: 30),
      );
    }

    return MemoryImage(customCoverImage as Uint8List);
  }

  @ignore
  List<Chapter> get sortedChapters => chapters.sorted((a, b) => a.compareTo(b));

  List<Chapter> getDuplicateChapters() {
    final List<Chapter> result = [];

    for (var chapter in sortedChapters) {
      final found = chapters.firstWhereOrNull((had) => had.isSame(chapter));

      if (found != null && found.id != chapter.id) {
        result.add(chapter);
      }
    }

    return result;
  }

  ChapterFilterModel getChapterFilterModel(Settings settings) {
    final filterUnread = getOption(settings.chapterFilterUnreadList)?.type ?? 0;
    final filterBookmarked = getOption(settings.chapterFilterBookmarkedList)?.type ?? 0;
    final filterDownloaded = getOption(settings.chapterFilterDownloadedList)?.type ?? 0;
    final scanlators = getOption(settings.filterScanlatorList)?.scanlators ?? [];

    return ChapterFilterModel(
      filterUnread: FilterType.values[filterUnread],
      filterBookmarked: FilterType.values[filterBookmarked],
      filterDownloaded: FilterType.values[filterDownloaded],
      filterScanlator: scanlators,
    );
  }

  ChapterSortModel getChapterSortModel(Settings settings) {
    return ChapterSortModel(
      getOption(settings.sortChapterList) ??
          SortChapter(
            mangaId: id,
            index: 1,
            reverse: false,
          ),
    );
  }

  ChaptersListModel getChapterModel(Settings settings) {
    return ChaptersListModel(
      filter: getChapterFilterModel(settings),
      sort: getChapterSortModel(settings),
    );
  }
}
