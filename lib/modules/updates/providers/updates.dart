import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates.g.dart';

@riverpod
Stream<List<Manga>> getWatchedEntries(Ref ref) async* {
  yield* isar.mangas
      .filter()
      .favoriteEqualTo(true)
      .and()
      .sourceIsNotNull()
      .and()
      .isLocalArchiveEqualTo(false)
      .watch(fireImmediately: true);
}
