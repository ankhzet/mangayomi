import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

extension ChapterExtension on Chapter {
  @ignore
  ItemType get itemType => manga.value!.itemType;

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

  String progress() {
    final progress = lastPageRead!;

    if (progress.isEmpty || progress == '1') {
      return '';
    }

    return switch (manga.value!.itemType) {
      ItemType.manga => progress,
      ItemType.anime => Duration(milliseconds: int.parse(progress)).toString().substringBefore("."),
      ItemType.novel => "${((double.tryParse(progress) ?? 0) * 100).toStringAsFixed(0)} %",
    };
  }

  DateTime? datetimeUpload() {
    if (dateUpload?.isNotEmpty == true) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(dateUpload!));
    }

    return null;
  }
}
