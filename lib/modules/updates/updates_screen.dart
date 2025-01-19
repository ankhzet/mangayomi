import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_periodicity_provider.dart';
import 'package:mangayomi/modules/updates/providers/updates.dart';
import 'package:mangayomi/modules/updates/updates_tab.dart';
import 'package:mangayomi/modules/widgets/async_value_widget.dart';
import 'package:mangayomi/modules/widgets/count_badge.dart';
import 'package:mangayomi/modules/widgets/media_type_tab_bar_view.dart';
import 'package:mangayomi/modules/widgets/refresh_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/async_value.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> {
  final _textEditingController = TextEditingController();
  bool _isLoading = false;
  bool _isSearch = false;
  bool _type = true;
  bool _initial = true;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final async = ref.watch(getWatchedEntriesProvider).merge2(ref.watch(updatePeriodicityProvider()));

    return AsyncValueWidget(
      tag: getWatchedEntriesProvider.name,
      async: async,
      builder: (values) => async.build(values, (List<Manga> entities, Iterable<MangaPeriodicity> periodicity) {
        final types = entities.map((entity) => entity.isManga == true).toUnique(growable: false);
        final (queue, overdraft) = _getQueue(periodicity);

        return DefaultTabController(
          animationDuration: Duration.zero,
          length: 2,
          child: MediaTabs(
            onChange: (type) {
              setState(() {
                _type = type;
                _textEditingController.clear();
                _isSearch = false;
              });
            },
            types: types,
            content: (type) => UpdatesTab(
              isManga: type,
              isOverdraft: overdraft,
              queue: queue,
              periodicity: periodicity,
              query: _textEditingController.text,
            ),
            wrap: (tabBar, view) => Scaffold(
              appBar: AppBar(
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
                  _updateAction(queue, overdraft),
                  _actionIconButton(
                    Icons.delete_sweep_outlined,
                    onPressed: () => _removeAllUpdates(context),
                  ),
                ],
                bottom: tabBar,
              ),
              body: view,
            ),
          ),
        );
      }),
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
    Iterable<(Manga, int, int, MangaPeriodicity)> rest = deltas.where((i) => i.$2 < i.$3);
    final overdraft = filtered.isEmpty;

    if (overdraft) {
      filtered = deltas.sorted((a, b) => a.$2 - b.$2).takeLast(10);
    }

    filtered = filtered.sorted((a, b) => -((a.$2 - a.$3) - (b.$2 - b.$3)));
    rest = rest.sorted((a, b) => -((a.$2 - a.$3) - (b.$2 - b.$3)));

    if (_initial) {
      _initial = false;

      if (kDebugMode) {
        String h(int milliseconds, int width) => '${Duration(milliseconds: milliseconds).inHours}h'.padLeft(width);
        print('\n\n================================\nScheduled for update:\n');
        for (final (idx, (manga, delta, period, _)) in filtered.indexed) {
          print('${idx.toString().padLeft(4)} | ${h(delta - period, 5)} overdue | ${manga.name}');
        }
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

  Widget _updateAction(List<MangaPeriodicity> queue, bool overdraft) {
    return _actionButton(
      icon: _isLoading
          ? ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 20,
                maxHeight: 20,
              ),
              child: RefreshCenter(),
            )
          : _actionIcon(Icons.refresh_outlined, queue.isNotEmpty),
      onPressed: queue.isNotEmpty ? () => _updateLibrary(queue.map((i) => i.manga)) : null,
      badge: CountBadge(
        count: queue.length,
        color: overdraft ? const Color.fromARGB(255, 176, 46, 37) : const Color.fromARGB(255, 46, 176, 37),
      ),
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

  Widget _actionButton({required Widget icon, Widget? badge, VoidCallback? onPressed}) {
    final children = badge != null
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              icon,
              Positioned(
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
      disabledColor: Theme.of(context).disabledColor,
      icon: children,
    );
  }

  Future<void> _updateLibrary(Iterable<Manga> next) async {
    setState(() {
      _isLoading = true;
    });

    final cancel = botToast(
      context.l10n.updating_library,
      fontSize: 13,
      second: 1600,
      alignY: !context.isTablet ? 0.85 : 1,
    );

    try {
      final interval = const Duration(milliseconds: 100);

      for (var manga in next) {
        await interval.waitFor(() async {
          if (mounted) {
            return ref.read(updateMangaDetailProvider(mangaId: manga.id, isInit: false).future);
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
                      .chapter(
                        (q) => q.manga((q) => q.isMangaEqualTo(_type)),
                      )
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
