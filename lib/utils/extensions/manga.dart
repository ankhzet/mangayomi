import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
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
        cacheMaxAge: cacheMaxAge,
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
}
