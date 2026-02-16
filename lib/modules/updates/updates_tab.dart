import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_periodicity_provider.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class UpdatesTab extends ConsumerStatefulWidget {
  final List<Update> entries;
  final bool isOverdraft;
  final Iterable<MangaPeriodicity> queue;
  final Iterable<MangaPeriodicity> periodicity;

  const UpdatesTab({
    super.key,
    required this.entries,
    required this.queue,
    required this.periodicity,
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
  late final entries = widget.entries;
  late final Map<int, int> periodicityMap = Map.fromEntries(
    widget.periodicity.map((i) => MapEntry(i.manga.id, i.days)),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return CustomScrollView(
      slivers: [
        entries.isEmpty
            ? Center(child: Text(l10n.no_recent_updates))
            : _updates(),
      ],
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

  Widget _updates() {
    final groups = UpdateChaptersGroup.groupChapters(
      entries.map((update) => update.chapter.value).whereType<Chapter>(),
      _getPeriodicity,
    );

    return SliverGroupedListView(
      elements: groups,
      groupBy: ChapterGroup.groupBy,
      groupHeaderBuilder:
          (value) => Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8, left: 12),
            child: Row(
              children: [
                Text(
                  _getGroup(value.group),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
      itemBuilder:
          (context, element) =>
              UpdateChapterListTileWidget(update: element, sourceExist: true),
      itemComparator: (item1, item2) => item1.compareTo(item2),
      groupComparator: (item1, item2) => item2 - item1,
      order: GroupedListOrder.DESC,
    );
  }
}
