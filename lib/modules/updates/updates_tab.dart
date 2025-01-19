import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/models/dto/group.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_periodicity_provider.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/updates/widgets/update_queue_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/async_value_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/async_value.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdatesTab extends ConsumerStatefulWidget {
  final String query;
  final bool isManga;
  final bool isOverdraft;
  final Iterable<MangaPeriodicity> queue;
  final Iterable<MangaPeriodicity> periodicity;

  const UpdatesTab({
    super.key,
    required this.isManga,
    required this.queue,
    required this.periodicity,
    required this.query,
    required this.isOverdraft,
  });

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
  3560: 'Update once a decade',
};

class _UpdatesTabState extends ConsumerState<UpdatesTab> {
  late final Map<int, int> periodicityMap =
      Map.fromEntries(widget.periodicity.map((i) => MapEntry(i.manga.id, i.days)));

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final async = ref.watch(getAllUpdateStreamProvider(isManga: widget.isManga)).combiner();

    return Scaffold(
      body: Stack(
        children: [
          AsyncValueWidget(
            async: async,
            builder: (values) => async.build(values, (List<Update> updates) {
              final query = widget.query.toLowerCase();
              final Map<int?, bool> map = {};
              final entries = query.isEmpty
                  ? updates
                  : updates.where((element) {
                      final mangaId = element.mangaId;
                      final value = map[mangaId];

                      if (value != null) {
                        return value;
                      }

                      return map[mangaId] = element.chapter.value!.manga.value!.name!.toLowerCase().contains(query);
                    }).toList();

              int? lastUpdated = entries.fold(null, (result, update) {
                final timestamp = update.lastMangaUpdate;

                return (((result == null) || (timestamp > result)) ? timestamp : result);
              });

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
                  if (widget.queue.isNotEmpty) _queue(widget.queue),
                  if (entries.isEmpty)
                    Center(
                      child: Text(l10n.no_recent_updates),
                    ),
                  _updates(entries),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  int _getPeriodicity(Chapter chapter) {
    if (chapter.manga.value!.favorite != true) {
      return -2;
    }

    return periodicityMap[chapter.mangaId] ?? -1;
  }

  String _getGroup(int days) {
    return switch (days) {
      -2 => 'Dropped title',
      -1 => 'Infrequent updates',
      0 => 'Update frequency unknown',
      _ => types[days] ?? 'Infrequent updates',
    };
  }

  Widget _queue(Iterable<MangaPeriodicity> queue) {
    final List<Group<MangaPeriodicity, int>> groups = Group.groupItems(
      queue,
      (periodicity) => periodicity.days,
      Group<MangaPeriodicity, int>.new,
      belongsTo: (periodicity, group) => group.first!.manga.id == periodicity.manga.id,
    );

    final label = widget.isOverdraft ? 'Not checked in a while' : 'Next in queue';

    return SliverGroupedListView(
      elements: groups,
      groupBy: Group.groupBy<int>,
      groupHeaderBuilder: (value) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, left: 12),
        child: Row(
          children: [
            Text('$label: ${_getGroup(value.group)}', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      itemBuilder: (context, element) => UpdateQueueListTileWidget(candidate: element),
      itemComparator: (item1, item2) => item1.first!.last.compareTo(item2.first!.last),
      groupComparator: (item1, item2) => item2 - item1,
      order: GroupedListOrder.DESC,
    );
  }

  Widget _updates(List<Update> entries) {
    final groups = ChapterGroup.groupChapters(
      entries.map((update) => update.chapter.value).whereType<Chapter>(),
      _getPeriodicity,
    );

    return SliverGroupedListView(
      elements: groups,
      groupBy: ChapterGroup.groupBy,
      groupHeaderBuilder: (value) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8, left: 12),
        child: Row(
          children: [
            Text(_getGroup(value.group), style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      itemBuilder: (context, element) => UpdateChapterListTileWidget(update: element, sourceExist: true),
      itemComparator: (item1, item2) => item1.compareTo(item2),
      groupComparator: (item1, item2) => item2 - item1,
      order: GroupedListOrder.DESC,
    );
  }
}
