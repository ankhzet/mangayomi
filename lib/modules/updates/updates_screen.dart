import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/dto/update_group.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/base_library_tab_screen.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/library_updater.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends BaseLibraryTabScreenState<UpdatesScreen> {
  bool _isLoading = false;

  Map<ItemType, int> _getUpdateCounts() {
    final counts = <ItemType, int>{};
    for (final type in ItemType.values) {
      final count = isar.updates
          .filter()
          .idIsNotNull()
          .and()
          .chapter((q) => q.manga((q) => q.itemTypeEqualTo(type)))
          .countSync();
      if (count > 0) {
        counts[type] = count;
      }
    }
    return counts;
  }

  @override
  String get title => l10nLocalizations(context)!.updates;

  bool get _hasMultipleTypesWithUpdates => _getUpdateCounts().length > 1;

  @override
  Widget build(BuildContext context) {
    if (!_hasMultipleTypesWithUpdates) {
      return _buildSingleTypeView();
    }
    return super.build(context);
  }

  Widget _buildSingleTypeView() {
    final counts = _getUpdateCounts();
    final itemType = counts.keys.first;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        actions: buildExtraActions(context),
      ),
      body: UpdateTab(
        itemType: itemType,
        query: textEditingController.text,
        isLoading: _isLoading,
      ),
    );
  }

  @override
  Widget buildTab(ItemType type) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: UpdateTab(
        itemType: type,
        query: textEditingController.text,
        isLoading: _isLoading,
      ),
    );
  }

  @override
  Widget buildTabLabel(ItemType type, String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(text: label),
        const SizedBox(width: 8),
        _updateNumbers(ref, type),
      ],
    );
  }

  @override
  List<Widget> buildExtraActions(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return [
      IconButton(
        splashRadius: 20,
        icon: Icon(Icons.refresh_outlined, color: Theme.of(context).hintColor),
        onPressed: _updateLibrary,
      ),
      IconButton(
        splashRadius: 20,
        icon: Icon(
          Icons.delete_sweep_outlined,
          color: Theme.of(context).hintColor,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: Text(l10n.remove_everything),
              content: Text(l10n.remove_all_update_msg),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();
                    await _clearUpdates();
                  },
                  child: Text(l10n.ok),
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  Future<void> _updateLibrary() async {
    setState(() => _isLoading = true);
    final itemType = getCurrentItemType();
    final allowedCategories = isar.categorys
        .filter()
        .idIsNotNull()
        .group((q) => q.shouldUpdateIsNull().or().shouldUpdateEqualTo(true))
        .findAllSync()
        .map((e) => e.id);
    final mangaList = isar.mangas
        .filter()
        .favoriteEqualTo(true)
        .and()
        .itemTypeEqualTo(itemType)
        .and()
        .isLocalArchiveEqualTo(false)
        .findAllSync()
        .where((e) {
          for (final category in allowedCategories) {
            if (e.categories?.contains(category) ?? false) {
              return true;
            }
          }
          return false;
        })
        .toList();
    await updateLibrary(
      ref: ref,
      context: context,
      mangaList: mangaList,
      itemType: itemType,
    );
    setState(() => _isLoading = false);
  }

  Future<void> _clearUpdates() async {
    List<Update> updates = await isar.updates
        .filter()
        .idIsNotNull()
        .chapter((q) => q.manga((q) => q.itemTypeEqualTo(getCurrentItemType())))
        .findAll();
    final idsToDelete = <Id>[];
    isar.writeTxnSync(() {
      for (var update in updates) {
        idsToDelete.add(update.id!);
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.removeUpdate, update.id, "{}", false);
      }
    });
    await isar.writeTxn(() => isar.updates.deleteAll(idsToDelete));
  }
}

class UpdateTab extends ConsumerStatefulWidget {
  final String query;
  final ItemType itemType;
  final bool isLoading;
  const UpdateTab({
    required this.itemType,
    required this.query,
    required this.isLoading,
    super.key,
  });

  @override
  ConsumerState<UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends ConsumerState<UpdateTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = l10nLocalizations(context)!;
    final update = ref.watch(
      getAllUpdateStreamProvider(
        itemType: widget.itemType,
        search: widget.query,
      ),
    );

    String _getTimePeriodKey(String? timestampStr) {
      if (timestampStr == null || timestampStr.isEmpty) return 'unknown';
      final timestamp = int.tryParse(timestampStr);
      if (timestamp == null) return 'unknown';
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = now - timestamp;
      final days = diff ~/ (1000 * 60 * 60 * 24);

      if (days <= 1) return 'today';
      if (days <= 7) return 'week';
      if (days <= 30) return 'month';
      if (days <= 365) return 'year';
      return 'older';
    }

    String _getTimePeriodLabel(String key) {
      switch (key) {
        case 'today':
          return 'Today';
        case 'week':
          return 'This week';
        case 'month':
          return 'More than a week ago';
        case 'year':
          return 'More than a month ago';
        case 'older':
          return 'More than a year ago';
        default:
          return 'Unknown';
      }
    }

    final periodOrder = ['today', 'week', 'month', 'year', 'older', 'unknown'];

    return Stack(
      children: [
        update.when(
          data: (entries) {
            final groupedByPeriod = <String, List<Update>>{};
            for (var entry in entries) {
              final periodKey = _getTimePeriodKey(entry.date);
              groupedByPeriod.putIfAbsent(periodKey, () => []).add(entry);
            }

            final lastUpdatedList = entries
                .map((e) => e.chapter.value?.manga.value?.lastUpdate)
                .whereType<int>()
                .toList();
            lastUpdatedList.sort((a, b) => b.compareTo(a));
            final lastUpdated = lastUpdatedList.firstOrNull;
            if (entries.isNotEmpty) {
              return CustomScrollView(
                slivers: [
                  if (lastUpdated != null)
                    SliverPadding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 10,
                        bottom: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed([
                          Text(
                            l10n.library_last_updated(
                              dateFormat(
                                lastUpdated.toString(),
                                ref: ref,
                                context: context,
                                showHOURorMINUTE: true,
                              ),
                            ),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: context.secondaryColor,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ...periodOrder
                      .where((p) => groupedByPeriod.containsKey(p))
                      .expand((periodKey) {
                        final updatesForPeriod = groupedByPeriod[periodKey]!;
                        final groupedByManga = UpdateGroup.groupUpdates<int?>(
                          updatesForPeriod,
                          (update) => update.chapter.value?.mangaId,
                        );
                        groupedByManga.sort((a, b) => b.compareTo(a));

                        return [
                          SliverPadding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              bottom: 8,
                              left: 12,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate.fixed([
                                Text(_getTimePeriodLabel(periodKey)),
                              ]),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final group = groupedByManga[index];
                              return UpdateChapterListTileWidget(
                                chapter: group.firstOrUnread,
                                chapterGroup: group,
                                sourceExist: true,
                              );
                            }, childCount: groupedByManga.length),
                          ),
                        ];
                      }),
                ],
              );
            }
            return Center(child: Text(l10n.no_recent_updates));
          },
          error: (Object error, StackTrace stackTrace) {
            return ErrorText(error);
          },
          loading: () {
            return const ProgressCenter();
          },
        ),
        if (widget.isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: RefreshProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

Widget _updateNumbers(WidgetRef ref, ItemType itemType) {
  return StreamBuilder(
    stream: isar.updates
        .filter()
        .idIsNotNull()
        .and()
        .chapter((q) => q.manga((q) => q.itemTypeEqualTo(itemType)))
        .watch(fireImmediately: true),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final entries = snapshot.data!.toList();
        final distinctMangaCount = entries
            .map((e) => e.chapter.value?.mangaId)
            .whereType<int>()
            .toSet()
            .length;
        return entries.isEmpty
            ? SizedBox.shrink()
            : Badge(
                backgroundColor: Theme.of(context).focusColor,
                label: Text(
                  distinctMangaCount.toString(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall!.color,
                  ),
                ),
              );
      }
      return Container();
    },
  );
}
