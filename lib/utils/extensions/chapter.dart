import 'package:flutter/material.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';

extension ChapterExtension on Chapter {
  bool isThisChapter<T extends OfChapter>(T element) => element.chapterId == id;

  bool isNotThisChapter<T extends OfChapter>(T element) => element.chapterId != id;

  T? getOption<T extends OfChapter>(List<T>? list) => list?.where(isThisChapter).firstOrNull;

  List<T> getOtherOptions<T extends OfChapter>(List<T>? list) => list?.where(isNotThisChapter).toList() ?? [];

  Future<void> pushToReaderView(BuildContext context, {bool ignoreIsRead = false}) async {
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
}
