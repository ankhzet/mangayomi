import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
Stream<List<Update>> getAllUpdateStream(Ref ref, {required bool isManga}) async* {
  final updates = await isar.updates
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.isMangaEqualTo(isManga)))
      .findAll();

  final List<int> toDelete = (
      updates
          .where((update) => update.chapter.value!.isRead!)
          .map((update) => update.id!)
          .toList(growable: false)
  );

  if (toDelete.isNotEmpty) {
    await isar.writeTxn(() async {
      await isar.updates.deleteAll(toDelete);
    });
  }

  yield* isar.updates
      .filter()
      .idIsNotNull()
      .and()
      .chapter((q) => q.manga((q) => q.isMangaEqualTo(isManga)))
      .watch(fireImmediately: true);
}
