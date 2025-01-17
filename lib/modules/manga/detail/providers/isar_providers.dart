import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/chapters_list_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_providers.g.dart';

@riverpod
Stream<Manga?> getMangaDetailStream(Ref ref, {required int mangaId}) async* {
  yield* isar.mangas.watchObject(mangaId, fireImmediately: true);
}

@riverpod
Stream<List<Chapter>> getChaptersStream(Ref ref, {required int mangaId}) async* {
  yield* isar.chapters.filter().manga((q) => q.idEqualTo(mangaId)).watch(fireImmediately: true);
}

@riverpod
Stream<bool> getSourceStream(
  Ref ref, {
  required String lang,
  required String name,
}) async* {
  yield* isar.sources
      .filter()
      .idIsNotNull()
      .isActiveEqualTo(true)
      .and()
      .isAddedEqualTo(true)
      .and()
      .langContains(lang, caseSensitive: false)
      .and()
      .nameContains(name, caseSensitive: false)
      .watch(fireImmediately: true)
      .map((sources) => sources.isNotEmpty);
}

@riverpod
Stream<List<Chapter>> getChaptersFilteredStream(
  Ref ref, {
  required int mangaId,
  required ChaptersListModel model,
}) async* {
  yield* isar.chapters
      .filter()
      .manga((q) => q.idEqualTo(mangaId))
      .watch(fireImmediately: true)
      .map((chapters) => model.build(chapters));
}
