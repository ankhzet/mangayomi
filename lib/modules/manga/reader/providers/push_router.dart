import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';

Future<void> pushMangaReaderView({
  required BuildContext context,
  required Chapter chapter,
}) async {
  final sourceExist = isar.sources
      .filter()
      .langContains(chapter.manga.value!.lang!, caseSensitive: false)
      .and()
      .nameContains(chapter.manga.value!.source!, caseSensitive: false)
      .and()
      .idIsNotNull()
      .and()
      .isActiveEqualTo(true)
      .and()
      .isAddedEqualTo(true)
      .findAllSync()
      .isNotEmpty;
  if (sourceExist || chapter.manga.value!.isLocalArchive!) {
    await context.push(
      switch (chapter.manga.value!.itemType) {
        ItemType.manga => '/mangaReaderView',
        ItemType.anime => '/animePlayerView',
        ItemType.novel => '/novelReaderView',
      },
      extra: chapter,
    );
  }
}

void pushReplacementMangaReaderView({required BuildContext context, required Chapter chapter}) {
  switch (chapter.manga.value!.itemType) {
    case ItemType.manga:
      context.pushReplacement('/mangaReaderView', extra: chapter);
      break;
    case ItemType.anime:
      context.pushReplacement('/animePlayerView', extra: chapter);
      break;
    case ItemType.novel:
      context.pushReplacement('/novelReaderView', extra: chapter);
      break;
  }
}
