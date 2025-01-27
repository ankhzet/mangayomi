import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/view_queue_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_providers.g.dart';

@riverpod
Stream<List<History>> getAllHistoryStream(Ref ref, {required ItemType itemType}) async* {
  yield* isar.historys
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<History>> getMangaHistoryStream(Ref ref, {required ItemType itemType, required int mangaId}) async* {
  yield* isar.historys
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType).and().idEqualTo(mangaId)))
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Update>> getAllUpdateStream(Ref ref, {required ItemType itemType}) async* {
  yield* isar.updates
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
      .watch(fireImmediately: true);
}

@riverpod
Stream<List<Manga>> getAllMangasStream(Ref ref, {required ItemType itemType}) async* {
  yield* isar.mangas.filter().itemTypeEqualTo(itemType).watch(fireImmediately: true);
}

@riverpod
Stream<Iterable<ViewQueueItem>> getViewQueueMap(Ref ref) async* {
  yield* isar.viewQueueItems
      .where()
      .watch(fireImmediately: true);
}
