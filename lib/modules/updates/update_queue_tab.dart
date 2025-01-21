import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:mangayomi/models/dto/group.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_periodicity_provider.dart';
import 'package:mangayomi/modules/updates/widgets/update_queue_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdateQueueTab extends ConsumerStatefulWidget {
  final int? lastUpdated;
  final bool isOverdraft;
  final Iterable<MangaPeriodicity> queue;

  const UpdateQueueTab({
    super.key,
    this.lastUpdated,
    required this.queue,
    required this.isOverdraft,
  });

  @override
  ConsumerState<UpdateQueueTab> createState() => _UpdateQueueTabState();
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

class _UpdateQueueTabState extends ConsumerState<UpdateQueueTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return CustomScrollView(
      slivers: [
        if (widget.lastUpdated != null)
          SliverPadding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                Text(
                  l10n.library_last_updated(
                    dateFormat(widget.lastUpdated.toString(), ref: ref, context: context, showHourOrMinute: true),
                  ),
                  style: TextStyle(fontStyle: FontStyle.italic, color: context.secondaryColor),
                ),
              ]),
            ),
          ),
        if (widget.queue.isNotEmpty) _queue(widget.queue),
      ],
    );
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
}
