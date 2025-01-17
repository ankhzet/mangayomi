import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates.g.dart';

@riverpod
Stream<List<Manga>> getWatchedEntries(Ref ref) async* {
  yield* isar.mangas.filter().favoriteEqualTo(true).and().sourceIsNotNull().watch(fireImmediately: true);
}

@riverpod
Stream<List<Manga>> getUpdatesQueue(Ref ref, {required Iterable<int> ids}) async* {
  yield* isar.mangas.filter().anyOf(ids, (q, id) => q.idEqualTo(id)).watch(fireImmediately: true).map((mangas) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = mangas //
        .map((manga) => (manga, manga.lastUpdate ?? 0))
        .sorted((a, b) => a.$2 - b.$2)
        .map((i) => i.$1);
    final today = updates //
        .where((manga) => Duration(milliseconds: now - (manga.lastUpdate ?? 0)) > const Duration(hours: 1));

    if (kDebugMode) {
      print('To update today: ${today.length}');
      print(updates
          .map((manga) => (manga.name, Duration(milliseconds: now - (manga.lastUpdate ?? 0)).toString()))
          .toList());
    }

    return today.toList(growable: false);
  });
}
