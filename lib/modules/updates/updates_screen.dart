import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/updates/providers/updates.dart';
import 'package:mangayomi/modules/updates/updates_tab.dart';
import 'package:mangayomi/modules/widgets/count_badge.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/media_type_tab_bar_view.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

final int granularity = 1000 * 60 * 60 * 1; // 6h

String duration(int days) {
  final all = Duration(milliseconds: days * granularity);
  final inDays = all.inDays;
  final inHours = (all - Duration(days: inDays)).inHours;

  return (inHours > 0 ? '${inDays}d. ${inHours}h.' : '${inDays}d.');
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> {
  final _textEditingController = TextEditingController();
  bool _isLoading = false;
  bool _isSearch = false;
  bool _type = true;
  List<History> entriesData = [];

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

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final watched = ref.watch(getWatchedEntriesProvider);

    return watched.when(
      data: (entities) {
        final types = entities.map((entity) => entity.isManga == true).toUnique(growable: false);

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
              query: _textEditingController.text,
              isLoading: _isLoading,
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
                      : _actionButton(
                          Icons.search_outlined,
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                          },
                        ),
                  _updateAction(entities),
                  _actionButton(
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
      },
      error: (e, _) => ErrorText(e),
      loading: () => const ProgressCenter(),
    );
  }

  Widget _updateAction(Iterable<Manga> entities) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final updates = entities //
        .map((manga) => (manga, manga.lastUpdate ?? 0))
        .sorted((a, b) => a.$2 - b.$2)
        .map((i) => i.$1);
    final today = updates //
        .where((manga) => Duration(milliseconds: now - (manga.lastUpdate ?? 0)) > const Duration(hours: 1));

    final queue = today.toList(growable: false);

    return _actionButton(
      Icons.refresh_outlined,
      onPressed: queue.isNotEmpty ? () => _updateLibrary(queue) : null,
      badge: CountBadge(count: queue.length),
    );
  }

  Widget _actionButton(IconData iconData, {Widget? badge, VoidCallback? onPressed}) {
    final icon = Icon(
      iconData,
      color: onPressed == null ? Theme.of(context).disabledColor : Theme.of(context).hintColor,
    );
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
}
