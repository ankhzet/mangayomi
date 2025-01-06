import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_providers.g.dart';

@riverpod
Stream<List<History>> getAllHistoryStream(Ref ref, {required bool isManga}) async* {
  yield* isar.historys
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.isMangaEqualTo(isManga)))
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<History>> getMangaHistoryStream(Ref ref, {required bool isManga, required int mangaId}) async* {
  yield* isar.historys
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.isMangaEqualTo(isManga).and().idEqualTo(mangaId)))
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Update>> getAllUpdateStream(Ref ref, {required bool isManga}) async* {
  yield* isar.updates
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.isMangaEqualTo(isManga)))
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<bool>> getUpdateTypesStream(Ref ref, { required bool d }) async* {
  yield* isar.updates
      .filter()
      .idIsNotNull()
      .distinctByMangaId()
      .mangaIdProperty()
      .watch(fireImmediately: true)
      .map((ids) => (
        isar.mangas
            .where()
            .anyOf(ids.whereType<int>(), (q, id) => q.idEqualTo(id))
            .distinctByIsManga()
            .isMangaProperty()
            .findAllSync()
            .map((type) => type == true)
            .toList(growable: false)
    ));
}

@riverpod
Stream<List<Manga>> getAllMangasStream(Ref ref, {required bool isManga}) async* {
  yield* isar.mangas.filter().isMangaEqualTo(isManga).watch(fireImmediately: true);
}
