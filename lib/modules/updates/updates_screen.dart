import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/view_queue_item.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_periodicity_provider.dart';
import 'package:mangayomi/modules/updates/providers/updates.dart';
import 'package:mangayomi/modules/updates/update_info_tabs.dart';
import 'package:mangayomi/modules/updates/update_queue_tab.dart';
import 'package:mangayomi/modules/updates/updates_tab.dart';
import 'package:mangayomi/modules/updates/view_queue_tab.dart';
import 'package:mangayomi/modules/widgets/async_value_widget.dart';
import 'package:mangayomi/modules/widgets/count_badge.dart';
import 'package:mangayomi/modules/widgets/media_type_tab_bar_view.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/async_value.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/extensions/view_queue_item.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> {
  final _textEditingController = TextEditingController();
  bool _isLoading = false;
  bool _isSearch = false;
  bool _initial = true;
  ItemType _type = ItemType.manga;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(getWatchedEntriesProvider).combiner();

    return AsyncValueWidget(
      async: async,
      builder: (values) => async.build(values, (List<Manga> entities) {
        final types = entities.map((entity) => entity.itemType).toUnique(growable: false);

        return MediaTabs(
          onChange: (type) {
            setState(() {
              _type = type;
              _textEditingController.clear();
              _isSearch = false;
            });
          },
          types: types,
          content: (type) => _infoTypes(type),
          wrap: (tabBar, view) => Scaffold(
            appBar: _appBar(tabBar, _type),
            body: view,
          ),
        );
      }),
    );
  }

  List<Update> _filterUpdates(List<Update> updates) {
    final query = _textEditingController.text.toLowerCase();
    final Map<int?, bool> map = {};

    return query.isEmpty
        ? updates
        : updates.where((element) {
            final mangaId = element.mangaId;
            final value = map[mangaId];

            if (value != null) {
              return value;
            }

            return map[mangaId] = element.chapter.value!.manga.value!.name!.toLowerCase().contains(query);
          }).toList();
  }

  Widget _infoTypes(ItemType type) {
    final async =
        ref.watch(updatePeriodicityProvider(type: type)).merge2(ref.watch(getAllUpdateStreamProvider(itemType: type)));

    return AsyncValueWidget(
      async: async,
      builder: (values) => async.build(values, (Iterable<MangaPeriodicity> periodicity, List<Update> updates) {
        final (queue, overdraft) = _getQueue(periodicity);
        final entries = _filterUpdates(updates);
        final viewQueueAsync = ref.watch(getViewQueueMapProvider).combiner();

        return AsyncValueWidget(
          async: viewQueueAsync,
          builder: (values) => viewQueueAsync.build(values, (Iterable<ViewQueueItem> items) {
            final map = items.mapQueueItems(entries.map((e) => e.manga.id));
            final viewQueue = entries.where((update) => map[update.manga.id] == true).toList();
            final List<UpdateInfoType> types = [];

            if (updates.isNotEmpty) {
              types.add(UpdateInfoType.updates);
            }

            if (viewQueue.isNotEmpty) {
              types.add(UpdateInfoType.viewQueue);
            }

            if (queue.isNotEmpty) {
              types.add(UpdateInfoType.updateQueue);
            }

            return UpdateInfoTabs(
              types: types,
              content: (tab) => switch (tab) {
                UpdateInfoType.updates => UpdatesTab(
                  entries: entries,
                  isOverdraft: overdraft,
                  queue: queue,
                  periodicity: periodicity,
                ),
                UpdateInfoType.updateQueue => UpdateQueueTab(
                  isOverdraft: overdraft,
                  queue: queue,
                  lastUpdated: entries.fold(null, (result, update) {
                    final timestamp = update.lastMangaUpdate;

                    return (((result == null) || (timestamp > result)) ? timestamp : result);
                  }),
                ),
                UpdateInfoType.viewQueue => ViewQueueTab(
                  entries: viewQueue,
                  periodicity: periodicity,
                ),
              },
              wrap: (tabBar, view) => Scaffold(
                body: view,
                bottomNavigationBar: tabBar,
              ),
            );
          }),
        );
      }),
    );
  }

  AppBar _appBar(TabBar? tabBar, ItemType type) {
    final l10n = l10nLocalizations(context)!;

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: _isSearch ? null : Text(l10n.updates, style: TextStyle(color: Theme.of(context).hintColor)),
      actions: [
        _isSearch
            ? SeachFormTextField(
                onChanged: (value) {
                  setState(() {});
                },
                onSuffixPressed: () {
                  _textEditingController.clear();
                  setState(() {});
                },
                onPressed: () {
                  setState(() {
                    _isSearch = false;
                  });
                  _textEditingController.clear();
                },
                controller: _textEditingController,
              )
            : _actionIconButton(
                Icons.search_outlined,
                onPressed: () {
                  setState(() {
                    _isSearch = true;
                  });
                },
              ),
        _updateAction(type),
        _actionIconButton(
          Icons.delete_sweep_outlined,
          onPressed: () => _removeAllUpdates(context),
        ),
      ],
      bottom: tabBar,
    );
  }

  (List<MangaPeriodicity>, bool) _getQueue(Iterable<MangaPeriodicity> periodicity) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final deltas = periodicity.map((i) {
      final (:manga, :last, :period, :days) = i;
      final delta = now - last.millisecondsSinceEpoch;

      return (manga, delta, period.inMilliseconds ~/ 10, i);
    });
    Iterable<(Manga, int, int, MangaPeriodicity)> filtered = deltas.where((i) => i.$2 >= i.$3);
    final overdraft = filtered.isEmpty;

    if (overdraft) {
      filtered = deltas.sorted((a, b) => a.$2 - b.$2).takeLast(50);
    } else {
      filtered = filtered.sorted((a, b) => -((a.$2 - a.$3) - (b.$2 - b.$3)));
    }

    if (_initial) {
      _initial = false;

      if (kDebugMode) {
        String h(int milliseconds, int width) => '${Duration(milliseconds: milliseconds).inHours}h'.padLeft(width);
        print('\n\n================================\nScheduled for update:\n');
        for (final (idx, (manga, delta, period, _)) in filtered.indexed) {
          print('${idx.toString().padLeft(4)} | ${h(delta - period, 5)} overdue | ${manga.name}');
        }

        Iterable<(Manga, int, int, MangaPeriodicity)> rest =
            deltas.where((i) => i.$2 < i.$3).sorted((a, b) => -((a.$2 - a.$3) - (b.$2 - b.$3)));
        print('\n\n================================\nToo early for update:\n');
        print('     | next in | last check | period | updates roughly every | Title');
        for (final (idx, (manga, delta, period, periodicity)) in rest.indexed) {
          print(
              '${idx.toString().padLeft(4)} | ${h(-(delta - period), 7)} | ${h(delta, 6)} ago | ${h(period, 6)} | ${periodicity.days.toString().padLeft(16)} days | ${manga.name}');
        }
      }
    }

    return (filtered.mapToList((i) => i.$4), overdraft);
  }

  Widget _updateAction(ItemType type) {
    final async = ref.watch(updatePeriodicityProvider(type: type)).combiner();

    return AsyncValueWidget(
      async: async,
      builder: (values) => async.build(values, (Iterable<MangaPeriodicity> periodicity) {
        final (queue, overdraft) = _getQueue(periodicity);

        final badge = CountBadge(
          count: queue.length,
          color: overdraft ? const Color.fromARGB(255, 176, 46, 37) : const Color.fromARGB(255, 46, 176, 37),
        );

        return _actionButton(
          icon: _isLoading
              ? RefreshProgressIndicator(
                  indicatorMargin: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  strokeAlign: 0,
                )
              : _actionIcon(Icons.refresh_outlined, queue.isNotEmpty),
          constraints: _isLoading
              ? BoxConstraints(
                  maxWidth: kMinInteractiveDimension - 8,
                  maxHeight: kMinInteractiveDimension - 8,
                )
              : null,
          onPressed: queue.isNotEmpty ? () => _updateLibrary(queue.map((i) => i.manga)) : null,
          badge: _isLoading ? Positioned.fill(child: Center(child: badge)) : badge,
        );
      }),
    );
  }

  Widget _actionIcon(IconData iconData, bool enabled) {
    return Icon(
      iconData,
      color: enabled ? Theme.of(context).hintColor : Theme.of(context).disabledColor,
    );
  }

  Widget _actionIconButton(IconData iconData, {Widget? badge, VoidCallback? onPressed}) {
    return _actionButton(
      badge: badge,
      icon: _actionIcon(iconData, onPressed != null),
      onPressed: onPressed,
    );
  }

  Widget _actionButton({
    required Widget icon,
    Widget? badge,
    BoxConstraints? constraints,
    VoidCallback? onPressed,
  }) {
    final children = badge != null
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              icon,
              badge is Positioned
                  ? badge
                  : Positioned(
                      right: -5,
                      bottom: -5,
                      child: badge,
                    ),
            ],
          )
        : icon;

    return IconButton(
      onPressed: onPressed,
      splashRadius: 20,
      constraints: constraints,
      disabledColor: Theme.of(context).disabledColor,
      icon: children,
    );
  }

  Future<void> _updateLibrary(Iterable<Manga> next) async {
    setState(() {
      _isLoading = !_isLoading;
    });

    if (!_isLoading) {
      return;
    }

    final double alignY = context.isTablet ? 0.85 : 0.70;
    final cancel = botToast(
      context.l10n.updating_library,
      fontSize: 13,
      second: 1600,
      alignY: alignY,
    );
    final Set<String> errors = {};

    try {
      final interval = const Duration(milliseconds: 100);

      for (var manga in next) {
        if (!_isLoading) {
          break;
        }

        await interval.waitFor(() async {
          if (mounted) {
            try {
              return await ref.read(updateMangaDetailProvider(mangaId: manga.id, isInit: false).future);
            } catch (e) {
              errors.add(e.toString());
            }
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      cancel();

      if (errors.isNotEmpty) {
        botToast(
          errors.join('\n'),
          fontSize: 13,
          second: 5,
          alignY: alignY,
          isError: true,
        );
      }
    }
  }

  _removeAllUpdates(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.remove_everything),
        content: Text(l10n.remove_all_update_msg),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(l10n.cancel),
              ),
              const SizedBox(width: 15),
              TextButton(
                onPressed: () {
                  List<int> updates = isar.updates
                      .filter()
                      .idIsNotNull()
                      .chapter((q) => q.manga((q) => q.itemTypeEqualTo(_type)))
                      .findAllSync()
                      .map((i) => i.id!)
                      .toList(growable: false);

                  isar.writeTxnSync(() {
                    isar.updates.deleteAll(updates);
                  });

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(l10n.ok),
              ),
            ],
          )
        ],
      ),
    );
  }
}
