import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'isar_providers.g.dart';

@riverpod
Stream<List<Manga>> getAllMangaStream(Ref ref,
    {required int? categoryId, required bool? isManga}) async* {
  yield* categoryId == null
      ? isar.mangas
          .filter()
          .favoriteEqualTo(true)
          .and()
          .isMangaEqualTo(isManga)
          .watch(fireImmediately: true)
      : isar.mangas
          .filter()
          .favoriteEqualTo(true)
          .categoriesIsNotEmpty()
          .categoriesElementEqualTo(categoryId)
          .and()
          .isMangaEqualTo(isManga)
          .watch(fireImmediately: true);
}

@riverpod
Stream<List<Manga>> getAllMangaWithoutCategoriesStream(Ref ref,
    {required bool? isManga}) async* {
  yield* isar.mangas
      .filter()
      .favoriteEqualTo(true)
      .isMangaEqualTo(isManga)
      .and()
      .categoriesIsEmpty()
      .or()
      .categoriesIsNull()
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Settings>> getSettingsStream(Ref ref) async* {
  yield* isar.settings
      .filter()
      .idIsNotNull()
      .and()
      .idEqualTo(227)
      .watch(fireImmediately: true);
}
