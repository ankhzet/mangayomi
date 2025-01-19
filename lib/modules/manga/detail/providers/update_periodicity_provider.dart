import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_periodicity_provider.g.dart';

const defaultGranularity = 1000 * 60 * 60 * 1; // 1h
const ranges = [1, 7, 30, 90, 180, 356, 3560];

typedef MangaPeriodicity = ({Manga manga, Duration period, DateTime last, int days});

@riverpod
Stream<Iterable<MangaPeriodicity>> updatePeriodicity(
  Ref ref, {
  int granularity = defaultGranularity,
}) async* {
  // fetch watchable entities
  final entities = isar.mangas
      .where()
      .favoriteEqualTo(true)
      .filter()
      .sourceIsNotNull()
      .findAllSync()
      .fold(<int, Manga>{}, (map, manga) => map..putIfAbsent(manga.id, () => manga));
  final ids = entities.keys;
  // fetch initial chapters state
  final chapters =
      entities.isEmpty ? <Chapter>[] : isar.chapters.where().anyOf(ids, (q, id) => q.mangaIdEqualTo(id)).findAllSync();

  // initial periodicity pump
  Iterable<MangaPeriodicity> periodicity = _getAllPeriodicity(entities, chapters, granularity);

  yield periodicity;

  // watch for updates
  final updates =
      isar.mangas.where().favoriteEqualTo(true).filter().sourceIsNotNull().watchLazy(fireImmediately: false);

  yield* updates.map((void _) {
    // get updated entities
    final diff = isar.mangas
        .where()
        .favoriteEqualTo(true)
        .filter()
        .sourceIsNotNull()
        .group((q) => q // (manga NOT IN fetched list) OR (manga IN fetched list AND lastUpdate changed)
            .group((qq) => qq.not().anyOf(entities.values, (q, manga) => q.group((q) => (q.idEqualTo(manga.id)))))
            .or()
            .group((qq) => qq.anyOf(
                  entities.values,
                  (q, manga) =>
                      q.group((q) => (q.idEqualTo(manga.id).and().lastUpdateGreaterThan(manga.lastUpdate ?? 0))),
                )))
        .findAllSync();

    if (diff.isEmpty) {
      return periodicity;
    }

    final ids = diff.map((manga) => manga.id);
    // fetch updated chapters state
    final chapters = isar.chapters
        .where()
        .anyOf(diff, (q, manga) => q.mangaIdEqualTo(manga.id))
        .distinctByDateUpload()
        .findAllSync();

    for (final manga in diff) {
      entities[manga.id] = manga;
    }

    // updated periodicity
    final updated = _getAllPeriodicity(entities, chapters, granularity);

    // replace prev
    final spliced =
        periodicity.where((item) => !ids.contains(item.manga.id)).followedBy(updated).sorted(comparePeriodicity);
    periodicity = spliced;

    return periodicity;
  });
}

int comparePeriodicity(MangaPeriodicity a, MangaPeriodicity b) => a.period.inMilliseconds - b.period.inMilliseconds;

Iterable<MangaPeriodicity> _getAllPeriodicity(Map<int, Manga> entities, Iterable<Chapter> chapters, int granularity) {
  final now = DateTime.now().millisecondsSinceEpoch ~/ granularity;
  final byManga = chapters.groupBy((chapter) => chapter.mangaId!);

  return byManga //
      .entries
      .map((entry) {
    int mangaId = entry.key;
    Manga entity = entities[mangaId] ?? (entities[mangaId] = isar.mangas.getSync(mangaId)!);

    return _getMangaPeriodicity(entity, entry.value, granularity, now);
  }).sorted(comparePeriodicity);
}

MangaPeriodicity _getMangaPeriodicity(
  Manga manga,
  Iterable<Chapter> chapters,
  int granularity,
  int now,
) {
  final grouped = ChapterGroup.groupChapters(chapters, (chapter) => chapter.compositeOrder);
  final timestamps = grouped.map((group) => group.dateUpload).whereType<DateTime>();
  final periodicity = ( //
      timestamps.isEmpty //
          ? 0
          : _getPeriodicity(timestamps
              .map((datetime) => datetime.millisecondsSinceEpoch ~/ granularity)
              .sorted((a, b) => a - b)
              .followedBy([now])));
  final last = DateTime.fromMillisecondsSinceEpoch(manga.lastUpdate ?? 0);
  final period = Duration(milliseconds: periodicity * granularity);

  return (
    manga: manga,
    period: period,
    days: _getRange(period),
    last: last,
  );
}

int _getRange(Duration periodicity) {
  final days = periodicity.inDays;

  for (final range in ranges) {
    if (days <= range) {
      return range;
    }
  }

  return -1;
}

int _getPeriodicity(Iterable<int> dates) {
  int prev = dates.first;
  List<int> deltas = List.filled(dates.length - 1, 0, growable: true);
  int total = 0;

  for (final timestamp in dates.skip(1)) {
    final delta = timestamp - prev;

    if (delta > 0) {
      deltas[total++] = delta;
      prev = timestamp;
    }
  }

  deltas.length = total;

  final fifth = deltas.length ~/ 20;
  final tenth = deltas.length ~/ 10;
  final cutoff = fifth > 0 ? fifth : tenth;

  List<int> median = cutoff > 0
      ? (deltas..sort((a, b) => a - b)).sublist(cutoff, deltas.length - cutoff).toList(growable: false)
      : deltas;

  int min = median.first;
  int max = min;
  int sum = min;

  for (final delta in median) {
    if (delta > max) {
      max = delta;
    }

    if (delta < min) {
      min = delta;
    }

    sum += delta;
  }

  return sum ~/ median.length;
}
