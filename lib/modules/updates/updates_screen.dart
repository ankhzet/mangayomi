import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/update_group.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdatesScreen extends ConsumerStatefulWidget {
  const UpdatesScreen({super.key});

  @override
  ConsumerState<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends ConsumerState<UpdatesScreen> with TickerProviderStateMixin {
  late TabController _tabBarController;
  bool _isLoading = false;

  Future<void> _updateLibrary() async {
    setState(() {
      _isLoading = true;
    });

    CancelFunc? cancel;
    final label = context.l10n.updating_library;

    void toast(String text) {
      cancel = botToast(text, fontSize: 13, second: 1600, alignY: !context.isTablet ? 0.85 : 1);
    }

    toast(label);

    final mangaList =
        isar.mangas.filter().favoriteEqualTo(true).and().isMangaEqualTo(_tabBarController.index == 0).findAllSync();
    int numbers = 0;
    int total = mangaList.length;

    toast('$label (0 / $total)');

    for (var manga in mangaList) {
      await ref.read(updateMangaDetailProvider(mangaId: manga.id, isInit: false).future);
      numbers++;

      if (numbers % 5 == 0) {
        toast('$label ($numbers / $total)');
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    cancel!();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.animateTo(0);
    _tabBarController.addListener(() {
      setState(() {
        _textEditingController.clear();
        _isSearch = false;
      });
    });
    super.initState();
  }

  final _textEditingController = TextEditingController();
  bool _isSearch = false;
  List<History> entriesData = [];

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: _isSearch
              ? null
              : Text(
                  l10n.updates,
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
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
                    icon: Icon(Icons.search_outlined, color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  _updateLibrary();
                },
                icon: Icon(Icons.refresh_outlined, color: Theme.of(context).hintColor)),
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            l10n.remove_everything,
                          ),
                          content: Text(l10n.remove_all_update_msg),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(l10n.cancel)),
                                const SizedBox(
                                  width: 15,
                                ),
                                TextButton(
                                    onPressed: () {
                                      List<int> updates = isar.updates
                                          .filter()
                                          .idIsNotNull()
                                          .chapter(
                                            (q) => q.manga((q) => q.isMangaEqualTo(_tabBarController.index == 0)),
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
                                    child: Text(l10n.ok)),
                              ],
                            )
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete_sweep_outlined, color: Theme.of(context).hintColor)),
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabBarController,
            tabs: [
              Tab(text: l10n.manga),
              Tab(text: l10n.anime),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(controller: _tabBarController, children: [
            UpdateTab(isManga: true, query: _textEditingController.text, isLoading: _isLoading),
            UpdateTab(isManga: false, query: _textEditingController.text, isLoading: _isLoading)
          ]),
        ),
      ),
    );
  }
}

class UpdateTab extends ConsumerStatefulWidget {
  final String query;
  final bool isManga;
  final bool isLoading;

  const UpdateTab({required this.isManga, required this.query, required this.isLoading, super.key});

  @override
  ConsumerState<UpdateTab> createState() => _UpdateTabState();
}

class _UpdateTabState extends ConsumerState<UpdateTab> {
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

            int? lastUpdated = entries.fold(null, (result, update) {
              final timestamp = update.lastMangaUpdate;

              return (((result == null) || (timestamp > result)) ? timestamp : result);
            });

            final groups = UpdateGroup.groupUpdates(
              entries,
              (Update update) => dateFormat(
                update.date!,
                context: context,
                ref: ref,
                forHistoryValue: true,
                useRelativeTimesTamps: false,
              ),
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
                            dateFormat(lastUpdated.toString(), ref: ref, context: context, showHOURorMINUTE: true),
                          ),
                          style: TextStyle(fontStyle: FontStyle.italic, color: context.secondaryColor),
                        ),
                      ]),
                    ),
                  ),
                SliverGroupedListView(
                  elements: groups,
                  groupBy: UpdateGroup.groupBy,
                  groupSeparatorBuilder: (groupByValue) => Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 12),
                    child: Row(
                      children: [
                        Text(dateFormat(
                          null,
                          context: context,
                          stringDate: groupByValue,
                          ref: ref,
                        )),
                      ],
                    ),
                  ),
                  itemBuilder: (context, element) => UpdateChapterListTileWidget(update: element, sourceExist: true),
                  itemComparator: (item1, item2) => item1.compareTo(item2),
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
              child: Center(
                child: RefreshProgressIndicator(),
              )),
      ],
    ));
  }
}
