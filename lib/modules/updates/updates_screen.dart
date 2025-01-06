import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/updates/updates_tab.dart';
import 'package:mangayomi/modules/widgets/media_type_tab_bar_view.dart';
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

  Future<Iterable<Manga>> calculateQueue(bool type) async {
    final mangas =
        await isar.mangas.filter().favoriteEqualTo(true).and().sourceIsNotNull().and().isMangaEqualTo(_type).findAll();

    final updates = mangas.map((manga) => (manga, manga.lastUpdate ?? 0)).sorted((a, b) => a.$2 - b.$2).map((i) => i.$1);
    final now = DateTime.now().millisecondsSinceEpoch;
    final today = updates.where((manga) => Duration(milliseconds: now - (manga.lastUpdate ?? 0)) > const Duration(hours: 1));

    print('To update today: ${today.length}');
    print(updates.map((manga) => (manga.name, Duration(milliseconds: now - (manga.lastUpdate ?? 0)).toString())).toList());

    for (final manga in today) {
      print('${manga.name}');
    }

    return today.take(10);
  }

  Future<void> _updateLibrary() async {
    setState(() {
      _isLoading = true;
    });

    try {
      CancelFunc? cancel;
      final label = context.l10n.updating_library;

      void toast(String text) {
        cancel = botToast(text, fontSize: 13, second: 1600, alignY: !context.isTablet ? 0.85 : 1);
      }

      toast(label);

      final next = await calculateQueue(_type);
      final interval = const Duration(milliseconds: 50);

      int numbers = 0;
      int total = next.length;

      print(next.map((m) => m.name));
      toast('$label (0 / $total)');

      for (var manga in next) {
        await interval.waitFor(() => ref.read(updateMangaDetailProvider(mangaId: manga.id, isInit: false).future));
        numbers++;

        toast('$label ($numbers / $total)');
        await Future.delayed(const Duration(milliseconds: 50));
      }

      cancel!();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final stream = ref.watch(getUpdateTypesStreamProvider(d: true));

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
        types: stream,
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
                  : IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          _isSearch = true;
                        });
                      },
                      icon: Icon(Icons.search_outlined, color: Theme.of(context).hintColor),
                    ),
              IconButton(
                splashRadius: 20,
                disabledColor: ,
                onPressed: _updateLibrary,
                icon: Icon(Icons.refresh_outlined, color: Theme.of(context).hintColor),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: () {
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
                },
                icon: Icon(Icons.delete_sweep_outlined, color: Theme.of(context).hintColor),
              ),
            ],
            bottom: tabBar,
          ),
          body: view,
        ),
      ),
    );
  }
}
