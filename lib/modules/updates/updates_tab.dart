import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/modules/widgets/refresh_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class UpdatesTab extends ConsumerStatefulWidget {
  final String query;
  final bool isManga;
  final bool isLoading;

  const UpdatesTab({required this.isManga, required this.query, required this.isLoading, super.key});

  @override
  ConsumerState<UpdatesTab> createState() => _UpdatesTabState();
}

final int granularity = 1000 * 60 * 60 * 1; // 6h

final types = {
  1: 'Daily updates',
  7: 'Weekly updates',
  30: 'Update once a month',
  90: 'Update every 3 month',
  180: 'Update twice a year',
  356: 'Update once a year',
};
final ranges = types.keys;

class _UpdatesTabState extends ConsumerState<UpdatesTab> {

  Map<int, Duration> calculatePeriodicity() {
    final Map<int, Duration> result = {};
    final now = (DateTime.now().millisecondsSinceEpoch / granularity).toInt();
    final mangas = isar.mangas.filter().favoriteEqualTo(true).and().sourceIsNotNull().findAllSync();
    final periodicity = mangas.map((manga) {
      final uploads =
      isar.chapters.filter().mangaIdEqualTo(manga.id).distinctByDateUpload().dateUploadProperty().findAllSync();
      final timestamps =
      uploads.map((str) => (str?.isEmpty ?? true) ? 0 : int.parse(str!) ~/ granularity).sorted((a, b) => a - b);

      if (timestamps.isEmpty) {
        return (manga, (0, 0, 0, 0));
      }

      return (manga, _getPeriodicity(timestamps.followedBy([now])));
    }).sorted((a, b) => a.$2.$1 - b.$2.$1);

    for (final (manga, i) in periodicity) {
      result[manga.id] = Duration(milliseconds: i.$1 * granularity);
    }

    return result;
  }

  (int, int, int, int) _getPeriodicity(Iterable<int> dates) {
    int prev = dates.first;

    final List<int> deltas = [];

    for (final timestamp in dates.skip(1)) {
      deltas.add(timestamp - prev);
      prev = timestamp;
    }

    final List<int>  uniques = deltas.toUnique(growable: false);
    final List<int> median = uniques.length > 2
        ? uniques.sorted((a, b) => a - b).skip(1).take(uniques.length - 2).toList(growable: false)
        : uniques;

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

    final avg = sum / median.length;
    final from = ((min + avg) / 2).toInt();
    final to = ((max + avg) / 2).toInt();
    final weighted = ((from + to) / 2).toInt();

    return (
    weighted,
    avg.toInt(),
    from,
    to,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final update = ref.watch(getAllUpdateStreamProvider(isManga: widget.isManga));

    return Scaffold(
      body: Stack(
        children: [
          update.when(
            data: (data) {
              final query = widget.query.toLowerCase();
              final entries = query.isEmpty
                  ? data
                  : data
                      .where((element) => element.chapter.value!.manga.value!.name!.toLowerCase().contains(query))
                      .toList();

              if (entries.isEmpty) {
                return Center(
                  child: Text(l10n.no_recent_updates),
                );
              }

              final periodicity = calculatePeriodicity();

              int? lastUpdated = entries.fold(null, (result, update) {
                final timestamp = update.lastMangaUpdate;

                return (((result == null) || (timestamp > result)) ? timestamp : result);
              });

              int getPeriodicity(Chapter chapter) {
                if (chapter.manga.value!.favorite != true) {
                  return -2;
                }

                final p = periodicity[chapter.mangaId];

                if (p != null) {
                  final days = p.inDays;

                  for (final range in ranges) {
                    if (days <= range) {
                      return range;
                    }
                  }

                  return -1;
                }

                return 0;
              }

              final groups = ChapterGroup.groupUpdates(
                entries.map((update) => update.chapter.value).whereType<Chapter>(),
                getPeriodicity,
              );

              return CustomScrollView(
                slivers: [
                  if (lastUpdated != null)
                    SliverPadding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          Text(
                            l10n.library_last_updated(
                              dateFormat(lastUpdated.toString(), ref: ref, context: context, showHourOrMinute: true),
                            ),
                            style: TextStyle(fontStyle: FontStyle.italic, color: context.secondaryColor),
                          ),
                        ]),
                      ),
                    ),
                  SliverGroupedListView(
                    elements: groups,
                    groupBy: ChapterGroup.groupBy,
                    groupHeaderBuilder: (value) => Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 12),
                      child: Row(
                        children: [
                          Text(switch (value.group) {
                            -2 => 'Dropped title',
                            -1 => 'Infrequent updates',
                            0 => 'Update frequency unknown',
                            _ => types[value.group] ?? 'Infrequent updates',
                          }),
                        ],
                      ),
                    ),

                    itemBuilder: (context, element) => UpdateChapterListTileWidget(update: element, sourceExist: true),
                    itemComparator: (item1, item2) => item1.compareTo(item2),
                    groupComparator: (item1, item2) => item2 - item1,
                    order: GroupedListOrder.DESC,
                  ),
                ],
              );
            },
            error: (Object error, StackTrace stackTrace) => ErrorText(error),
            loading: () => const ProgressCenter(),
          ),
          if (widget.isLoading)
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: RefreshCenter(),
            ),
        ],
      ),
    );
  }
}
