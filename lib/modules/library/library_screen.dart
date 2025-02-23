// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/providers/add_torrent.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/library/widgets/library_gridview_widget.dart';
import 'package:mangayomi/modules/library/widgets/library_listview_widget.dart';
import 'package:mangayomi/modules/library/widgets/list_tile_manga_category.dart';
import 'package:mangayomi/modules/library/widgets/search_text_form_field.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/modules/more/categories/providers/isar_providers.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  final ItemType itemType;

  const LibraryScreen({required this.itemType, super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> with TickerProviderStateMixin {
  bool _isSearch = false;
  final _textEditingController = TextEditingController();
  late TabController tabBarController;
  int _tabIndex = 0;

  Future<void> _updateLibrary(List<Manga> mangaList) async {
    final cancel = botToast(context.l10n.updating_library, fontSize: 13, second: 1600, alignY: !context.isTablet ? 0.85 : 1);
    final interval = const Duration(milliseconds: 100);
    final Set<String> errors = {};

    for (var manga in mangaList) {
      await interval.waitFor(() async {
        if (!mounted) {
          return;
        }

        try {
          return await ref.read(updateMangaDetailProvider(mangaId: manga.id, isInit: false).future);
        } catch (e) {
          errors.add(e.toString());
        }
      });
    }

    cancel();

    if (errors.isNotEmpty) {
      botToast(errors.join('\n'), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsStream = ref.watch(getSettingsStreamProvider);
    return settingsStream.when(
      data: (settingsList) {
        final settings = settingsList.first;

        final categories = ref.watch(getMangaCategoryStreamProvider(itemType: widget.itemType));
        final withoutCategories = ref.watch(getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType));
        final showCategoryTabs =
            ref.watch(libraryShowCategoryTabsStateProvider(itemType: widget.itemType, settings: settings));
        final mangaAll = ref.watch(getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType));
        final l10n = l10nLocalizations(context)!;
        return Scaffold(
            body: mangaAll.when(
              data: (entries) {
                return withoutCategories.when(
                  data: (withoutCategory) {
                    return categories.when(
                      data: (categories) {
                        if (categories.isNotEmpty && showCategoryTabs) {
                          tabBarController = TabController(
                            length: withoutCategory.isNotEmpty ? categories.length + 1 : categories.length,
                            vsync: this,
                          );
                          tabBarController.animateTo(_tabIndex);
                          tabBarController.addListener(() {
                            _tabIndex = tabBarController.index;
                          });

                          return Consumer(builder: (context, ref, child) {
                            bool reverse = ref
                                .watch(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings))
                                .reverse!;

                            final continueReaderBtn = ref.watch(libraryShowContinueReadingButtonStateProvider(
                                itemType: widget.itemType, settings: settings));
                            final showNumbersOfItems = ref.watch(
                                libraryShowNumbersOfItemsStateProvider(itemType: widget.itemType, settings: settings));
                            final localSource = ref
                                .watch(libraryLocalSourceStateProvider(itemType: widget.itemType, settings: settings));
                            final downloadedChapter = ref.watch(
                                libraryDownloadedChaptersStateProvider(itemType: widget.itemType, settings: settings));
                            final unreadChapter = ref.watch(
                                libraryUnreadChaptersStateProvider(itemType: widget.itemType, settings: settings));
                            final language =
                                ref.watch(libraryLanguageStateProvider(itemType: widget.itemType, settings: settings));
                            final displayType = ref
                                .watch(libraryDisplayTypeStateProvider(itemType: widget.itemType, settings: settings));
                            final isNotFiltering = ref
                                .watch(mangasFilterResultStateProvider(itemType: widget.itemType, settings: settings));

                            final filter = ref.read(
                                mangaFiltersStateProvider(itemType: widget.itemType, settings: settings).notifier);

                            final numberOfItemsList = _filterAndSortManga(
                              entries: entries,
                              filter: filter,
                            );
                            final withoutCategoryNumberOfItemsList = _filterAndSortManga(
                              entries: withoutCategory,
                              filter: filter,
                            );
                            final catIndex = withoutCategory.isNotEmpty ? _tabIndex - 1 : _tabIndex;
                            final categoryId = catIndex < 0 ? null : categories[catIndex].id!;

                            return DefaultTabController(
                              length: categories.length,
                              child: Scaffold(
                                appBar: _appBar(
                                  isNotFiltering,
                                  showNumbersOfItems,
                                  numberOfItemsList.length,
                                  ref,
                                  true,
                                  categoryId,
                                  settings,
                                ),
                                body: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TabBar(isScrollable: true, controller: tabBarController, tabs: [
                                      if (withoutCategory.isNotEmpty)
                                        Row(children: [
                                          Tab(text: l10n.default0),
                                          if (showNumbersOfItems) const SizedBox(width: 4),
                                          if (showNumbersOfItems) _numberBadge(withoutCategoryNumberOfItemsList.length),
                                        ]),
                                      for (final category in categories)
                                        Row(children: [
                                          Tab(text: category.name),
                                          if (showNumbersOfItems) const SizedBox(width: 4),
                                          if (showNumbersOfItems)
                                            _categoryNumberOfItems(categoryId: category.id!, filter: filter),
                                        ]),
                                    ]),
                                    Flexible(
                                      child: TabBarView(
                                        controller: tabBarController,
                                        children: [
                                          if (withoutCategory.isNotEmpty)
                                            _bodyWithoutCategories(
                                              withoutCategories: true,
                                              filter: filter,
                                              reverse: reverse,
                                              downloadedChapter: downloadedChapter,
                                              unreadChapter: unreadChapter,
                                              continueReaderBtn: continueReaderBtn,
                                              language: language,
                                              displayType: displayType,
                                              ref: ref,
                                              localSource: localSource,
                                              settings: settings,
                                            ),
                                          for (final category in categories)
                                            _bodyWithCategories(
                                              categoryId: category.id!,
                                              filter: filter,
                                              reverse: reverse,
                                              downloadedChapter: downloadedChapter,
                                              unreadChapter: unreadChapter,
                                              continueReaderBtn: continueReaderBtn,
                                              language: language,
                                              displayType: displayType,
                                              ref: ref,
                                              localSource: localSource,
                                              settings: settings,
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                        }
                        return Consumer(builder: (context, ref, child) {
                          bool reverse = ref
                              .watch(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings))
                              .reverse!;
                          final continueReaderBtn = ref.watch(libraryShowContinueReadingButtonStateProvider(
                              itemType: widget.itemType, settings: settings));
                          final showNumbersOfItems = ref.watch(
                              libraryShowNumbersOfItemsStateProvider(itemType: widget.itemType, settings: settings));
                          final localSource =
                              ref.watch(libraryLocalSourceStateProvider(itemType: widget.itemType, settings: settings));
                          final downloadedChapter = ref.watch(
                              libraryDownloadedChaptersStateProvider(itemType: widget.itemType, settings: settings));
                          final unreadChapter = ref
                              .watch(libraryUnreadChaptersStateProvider(itemType: widget.itemType, settings: settings));
                          final language =
                              ref.watch(libraryLanguageStateProvider(itemType: widget.itemType, settings: settings));
                          final displayType =
                              ref.watch(libraryDisplayTypeStateProvider(itemType: widget.itemType, settings: settings));
                          final isNotFiltering =
                              ref.watch(mangasFilterResultStateProvider(itemType: widget.itemType, settings: settings));
                          final filter = ref
                              .read(mangaFiltersStateProvider(itemType: widget.itemType, settings: settings).notifier);

                          final sortType = ref
                              .watch(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings))
                              .index;
                          final numberOfItemsList =
                              _filterAndSortManga(entries: entries, filter: filter, sortType: sortType!);
                          return Scaffold(
                              appBar: _appBar(
                                isNotFiltering,
                                showNumbersOfItems,
                                numberOfItemsList.length,
                                ref,
                                false,
                                null,
                                settings,
                              ),
                              body: _bodyWithoutCategories(
                                filter: filter,
                                reverse: reverse,
                                downloadedChapter: downloadedChapter,
                                unreadChapter: unreadChapter,
                                continueReaderBtn: continueReaderBtn,
                                language: language,
                                displayType: displayType,
                                ref: ref,
                                localSource: localSource,
                                settings: settings,
                              ));
                        });
                      },
                      error: (Object error, StackTrace stackTrace) {
                        return ErrorText(error);
                      },
                      loading: () {
                        return const ProgressCenter();
                      },
                    );
                  },
                  error: (Object error, StackTrace stackTrace) {
                    return ErrorText(error);
                  },
                  loading: () {
                    return const ProgressCenter();
                  },
                );
              },
              error: (Object error, StackTrace stackTrace) => ErrorText(error),
              loading: () => const ProgressCenter(),
            ),
            bottomNavigationBar: Consumer(builder: (context, ref, child) {
              final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
              final color = Theme.of(context).textTheme.bodyLarge!.color!;
              final mangaIds = ref.watch(mangasListStateProvider);
              return AnimatedContainer(
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                duration: const Duration(milliseconds: 100),
                height: isLongPressed ? 70 : 0,
                width: context.width(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent, elevation: 0, backgroundColor: Colors.transparent),
                            onPressed: _openCategory,
                            child: Icon(
                              Icons.label_outline_rounded,
                              color: color,
                            )),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              ref.read(mangasSetIsReadStateProvider(mangaIds: mangaIds).notifier).set();
                              ref.invalidate(getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType));
                              ref.invalidate(getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType));
                            },
                            child: Icon(
                              Icons.done_all_sharp,
                              color: color,
                            )),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              ref.read(mangasSetUnReadStateProvider(mangaIds: mangaIds).notifier).set();
                              ref.invalidate(getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType));
                              ref.invalidate(getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType));
                            },
                            child: Icon(
                              Icons.remove_done_sharp,
                              color: color,
                            )),
                      ),
                    ),
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 70,
                    //     child: ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           elevation: 0,
                    //           backgroundColor: Colors.transparent,
                    //           shadowColor: Colors.transparent,
                    //         ),
                    //         onPressed: () {},
                    //         child: Icon(
                    //           Icons.download_outlined,
                    //           color: color,
                    //         )),
                    //   ),
                    // ),
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              _deleteManga();
                            },
                            child: Icon(
                              Icons.delete_outline_outlined,
                              color: color,
                            )),
                      ),
                    ),
                  ],
                ),
              );
            }));
      },
      error: (error, e) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }

  Widget _numberBadge(int value, {double fontSize = 10}) {
    return Badge(
      backgroundColor: Theme.of(context).focusColor,
      padding: EdgeInsets.all(2),
      label: Text(
        softWrap: false,
        textAlign: TextAlign.center,
        value.toString(),
        style: TextStyle(fontSize: fontSize, color: Theme.of(context).textTheme.bodySmall!.color),
      ),
    );
  }

  Widget _categoryNumberOfItems({
    required MangaFiltersState filter,
    required int categoryId,
  }) {
    final mangas = ref.watch(getAllMangaStreamProvider(categoryId: categoryId, itemType: widget.itemType));

    return mangas.when(
      data: (data) {
        final categoryNumberOfItemsList = _filterAndSortManga(
          entries: data,
          filter: filter,
        );

        return _numberBadge(categoryNumberOfItemsList.length);
      },
      error: (Object error, StackTrace stackTrace) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }

  Widget _bodyWithCategories({
    required int categoryId,
    required MangaFiltersState filter,
    required bool reverse,
    required bool downloadedChapter,
    required bool unreadChapter,
    required bool continueReaderBtn,
    required bool localSource,
    required bool language,
    required WidgetRef ref,
    required DisplayType displayType,
    required Settings settings,
  }) {
    final l10n = l10nLocalizations(context)!;
    final mangas = ref.watch(getAllMangaStreamProvider(categoryId: categoryId, itemType: widget.itemType));
    final sortType = ref.watch(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings)).index;
    final mangaIdsList = ref.watch(mangasListStateProvider);
    return Scaffold(
        body: mangas.when(
      data: (data) {
        final entries = _filterAndSortManga(
          entries: data,
          filter: filter,
          sortType: sortType!,
          reversed: reverse,
        );

        if (entries.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await _updateLibrary(data);
            },
            child: displayType == DisplayType.list
                ? LibraryListViewWidget(
                    entriesManga: entries.toList(growable: false),
                    continueReaderBtn: continueReaderBtn,
                    downloadedChapter: downloadedChapter,
                    unreadChapter: unreadChapter,
                    language: language,
                    mangaIdsList: mangaIdsList,
                    localSource: localSource,
                  )
                : LibraryGridViewWidget(
                    entriesManga: entries.toList(growable: false),
                    isCoverOnlyGrid: !(displayType == DisplayType.compactGrid),
                    isComfortableGrid: displayType == DisplayType.comfortableGrid,
                    continueReaderBtn: continueReaderBtn,
                    downloadedChapter: downloadedChapter,
                    language: language,
                    mangaIdsList: mangaIdsList,
                    localSource: localSource,
                    itemType: widget.itemType,
                  ),
          );
        }
        return Center(child: Text(l10n.empty_library));
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    ));
  }

  Widget _bodyWithoutCategories({
    required MangaFiltersState filter,
    required bool reverse,
    required bool downloadedChapter,
    required bool unreadChapter,
    required bool continueReaderBtn,
    required bool localSource,
    required bool language,
    required DisplayType displayType,
    required WidgetRef ref,
    required Settings settings,
    bool withoutCategories = false,
  }) {
    final sortType = ref.watch(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings)).index;
    final manga = withoutCategories
        ? ref.watch(getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType))
        : ref.watch(getAllMangaStreamProvider(categoryId: null, itemType: widget.itemType));
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final l10n = l10nLocalizations(context)!;
    return manga.when(
      data: (data) {
        final entries = _filterAndSortManga(
          entries: data,
          filter: filter,
          sortType: sortType!,
          reversed: reverse,
        );

        if (entries.isEmpty) {
          return Center(child: Text(l10n.empty_library));
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _updateLibrary(data);
          },
          child: displayType == DisplayType.list
              ? LibraryListViewWidget(
                  entriesManga: entries.toList(growable: false),
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  unreadChapter: unreadChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                )
              : LibraryGridViewWidget(
                  entriesManga: entries.toList(growable: false),
                  isCoverOnlyGrid: !(displayType == DisplayType.compactGrid),
                  isComfortableGrid: displayType == DisplayType.comfortableGrid,
                  continueReaderBtn: continueReaderBtn,
                  downloadedChapter: downloadedChapter,
                  language: language,
                  mangaIdsList: mangaIdsList,
                  localSource: localSource,
                  itemType: widget.itemType,
                ),
        );
      },
      error: (Object error, StackTrace stackTrace) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }

  Iterable<Manga> _filterAndSortManga({
    required List<Manga> entries,
    required MangaFiltersState filter,
    int? sortType,
    bool reversed = false,
  }) {
    Iterable<Manga> filtered = filter.filterEntries(entries);

    if (_textEditingController.text.isNotEmpty) {
      final query = _textEditingController.text.toLowerCase();
      filtered = filtered.where((element) => element.name!.toLowerCase().contains(query));
    }

    if (sortType == null) {
      return filtered;
    }

    final int multiplier = reversed ? -1 : 1;

    return filtered.sorted(
      switch (sortType) {
        0 => (() {
            final cache = {};

            return (a, b) {
              final left = cache[a.name!] ??= a.name!.toLowerCase();
              final right = cache[b.name!] ??= b.name!.toLowerCase();

              return (multiplier * left.compareTo(right)) as int;
            };
          })(),
        1 => (a, b) => multiplier * a.lastRead!.compareTo(b.lastRead!),
        2 => (a, b) => multiplier * (a.lastUpdate?.compareTo(b.lastUpdate ?? 0) ?? 0),
        3 => (a, b) =>
            multiplier *
            a.chapters
                .where((element) => !element.isRead!)
                .length
                .compareTo(b.chapters.where((element) => !element.isRead!).length),
        4 => (a, b) => multiplier * a.chapters.length.compareTo(b.chapters.length),
        5 => (a, b) =>
            multiplier * (a.chapters.lastOrNull?.dateUpload?.compareTo(b.chapters.lastOrNull?.dateUpload ?? "") ?? 0),
        6 => (a, b) => multiplier * (a.dateAdded?.compareTo(b.dateAdded ?? 0) ?? 0),
        _ => throw AssertionError('Unexpected sortType: $sortType'),
      },
    );
  }

  void _openCategory() {
    List<int> categoryIds = [];
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final l10n = l10nLocalizations(context)!;
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return StreamBuilder(
                    stream: isar.categorys
                        .filter()
                        .idIsNotNull()
                        .and()
                        .forItemTypeEqualTo(widget.itemType)
                        .watch(fireImmediately: true),
                    builder: (context, snapshot) {
                      return AlertDialog(
                        title: Text(
                          l10n.set_categories,
                        ),
                        content: SizedBox(
                          width: context.width(0.8),
                          child: Builder(builder: (context) {
                            if (!(snapshot.hasData && snapshot.data!.isNotEmpty)) {
                              return Text(l10n.library_no_category_exist);
                            }

                            final entries = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: entries.length,
                              itemBuilder: (context, index) {
                                final entry = entries[index];
                                final id = entry.id!;

                                return ListTileMangaCategory(
                                  category: entry,
                                  categoryIds: categoryIds,
                                  mangasList: mangasList,
                                  onTap: () {
                                    setState(() {
                                      if (categoryIds.contains(id)) {
                                        categoryIds.remove(id);
                                      } else {
                                        categoryIds.add(id);
                                      }
                                    });
                                  },
                                  res: (res) {
                                    if (res.isNotEmpty) {
                                      categoryIds.add(id);
                                    }
                                  },
                                );
                              },
                            );
                          }),
                        ),
                        actions: [
                          snapshot.hasData && snapshot.data!.isNotEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          context.push("/categories", extra: (true, widget.itemType));
                                          Navigator.pop(context);
                                        },
                                        child: Text(l10n.edit)),
                                    Row(
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
                                              isar.writeTxnSync(() {
                                                for (var id in mangaIdsList) {
                                                  Manga? manga = isar.mangas.getSync(id);
                                                  manga!.categories = categoryIds;
                                                  isar.mangas.putSync(manga);
                                                  ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(
                                                      ActionType.updateItem, manga.id, manga.toJson(), false);
                                                }
                                              });
                                              ref.read(mangasListStateProvider.notifier).clear();
                                              ref.read(isLongPressedMangaStateProvider.notifier).update(false);

                                              if (mounted) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Text(
                                              l10n.ok,
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.push("/categories", extra: (true, widget.itemType));
                                        Navigator.pop(context);
                                      },
                                      child: Text(l10n.edit_categories),
                                    ),
                                  ],
                                )
                        ],
                      );
                    });
              },
            );
          });
        });
  }

  void _deleteManga() {
    List<int> fromLibList = [];
    List<int> downloadedChapsList = [];
    showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, ref, child) {
            final mangaIdsList = ref.watch(mangasListStateProvider);
            final l10n = l10nLocalizations(context)!;
            final List<Manga> mangasList = [];
            for (var id in mangaIdsList) {
              mangasList.add(isar.mangas.getSync(id)!);
            }
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text(
                    l10n.remove,
                  ),
                  content: SizedBox(
                      height: 100,
                      width: context.width(0.8),
                      child: Column(
                        children: [
                          ListTileItemFilter(
                            label: l10n.from_library,
                            onTap: () {
                              setState(() {
                                if (fromLibList == mangaIdsList) {
                                  fromLibList = [];
                                } else {
                                  fromLibList = mangaIdsList;
                                }
                              });
                            },
                            type: fromLibList.isNotEmpty ? 1 : 0,
                          ),
                          ListTileItemFilter(
                            label:
                                widget.itemType == ItemType.anime ? l10n.downloaded_episodes : l10n.downloaded_chapters,
                            onTap: () {
                              setState(() {
                                if (downloadedChapsList == mangaIdsList) {
                                  downloadedChapsList = [];
                                } else {
                                  downloadedChapsList = mangaIdsList;
                                }
                              });
                            },
                            type: downloadedChapsList.isNotEmpty ? 1 : 0,
                          ),
                        ],
                      )),
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
                            onPressed: () async {
                              if (fromLibList.isNotEmpty) {
                                isar.writeTxnSync(() {
                                  for (var manga in mangasList) {
                                    if (manga.isLocalArchive ?? false) {
                                      final histories = isar.historys.filter().mangaIdEqualTo(manga.id).findAllSync();
                                      for (var history in histories) {
                                        isar.historys.deleteSync(history.id!);
                                      }

                                      for (var chapter in manga.chapters) {
                                        isar.updates
                                            .filter()
                                            .mangaIdEqualTo(chapter.mangaId)
                                            .chapterNameEqualTo(chapter.name)
                                            .deleteAllSync();
                                        isar.chapters.deleteSync(chapter.id!);
                                      }
                                      isar.mangas.deleteSync(manga.id);
                                      ref
                                          .read(synchingProvider(syncId: 1).notifier)
                                          .addChangedPart(ActionType.removeItem, manga.id, "{}", false);
                                    } else {
                                      manga.favorite = false;
                                      isar.mangas.putSync(manga);
                                      ref
                                          .read(synchingProvider(syncId: 1).notifier)
                                          .addChangedPart(ActionType.updateItem, manga.id, manga.toJson(), false);
                                    }
                                  }
                                });
                              }
                              if (downloadedChapsList.isNotEmpty) {
                                isar.writeTxnSync(() async {
                                  for (var manga in mangasList) {
                                    if (manga.isLocalArchive ?? false) {
                                      final mangaDir = await StorageProvider.getMangaMainDirectory(manga);

                                      for (var chapter in manga.chapters) {
                                        final path = await StorageProvider.getMangaChapterDirectory(chapter);

                                        try {
                                          try {
                                            try {
                                              if (File("$mangaDir${chapter.name}.cbz").existsSync()) {
                                                File("$mangaDir${chapter.name}.cbz").deleteSync();
                                              }
                                            } catch (_) {}

                                            try {
                                              if (File("$mangaDir${chapter.name}.mp4").existsSync()) {
                                                File("$mangaDir${chapter.name}.mp4").deleteSync();
                                              }
                                            } catch (_) {}

                                            Directory(path).deleteSync(recursive: true);
                                          } catch (_) {}
                                          isar.writeTxnSync(() {
                                            final download =
                                                isar.downloads.filter().idEqualTo(chapter.id!).findAllSync();
                                            if (download.isNotEmpty) {
                                              isar.downloads.deleteSync(download.first.id!);
                                            }
                                          });
                                        } catch (_) {}
                                      }
                                    }
                                  }
                                });
                              }

                              ref.read(mangasListStateProvider.notifier).clear();
                              ref.read(isLongPressedMangaStateProvider.notifier).update(false);
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              l10n.ok,
                            )),
                      ],
                    ),
                  ],
                );
              },
            );
          });
        });
  }

  void _showDraggableMenu(Settings settings) {
    final l10n = l10nLocalizations(context)!;
    customDraggableTabBar(tabs: [
      Tab(text: l10n.filter),
      Tab(text: l10n.sort),
      Tab(text: l10n.display),
    ], children: [
      Consumer(builder: (context, ref, _) {
        final filter = ref.watch(mangaFiltersStateProvider(itemType: widget.itemType, settings: settings));

        return Column(
          children: [
            ListTileItemFilter(
              label: l10n.downloaded,
              type: filter.downloaded.value,
              onTap: filter.downloaded.update,
            ),
            ListTileItemFilter(
              label: l10n.unread,
              type: filter.unread.value,
              onTap: filter.unread.update,
            ),
            ListTileItemFilter(
              label: l10n.started,
              type: filter.started.value,
              onTap: filter.started.update,
            ),
            ListTileItemFilter(
              label: l10n.bookmarked,
              type: filter.bookmarked.value,
              onTap: filter.bookmarked.update,
            ),
          ],
        );
      }),
      Consumer(builder: (context, ref, chil) {
        final reverse =
            ref.read(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings).notifier).isReverse();
        final reverseChapter = ref.watch(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings));
        return Column(
          children: [
            for (var i = 0; i < 7; i++)
              ListTileChapterSort(
                label: _getSortNameByIndex(i, context),
                reverse: reverse,
                onTap: () {
                  ref
                      .read(sortLibraryMangaStateProvider(itemType: widget.itemType, settings: settings).notifier)
                      .set(i);
                },
                showLeading: reverseChapter.index == i,
              ),
          ],
        );
      }),
      Consumer(builder: (context, ref, chil) {
        final display = ref.watch(libraryDisplayTypeStateProvider(itemType: widget.itemType, settings: settings));
        final displayV =
            ref.read(libraryDisplayTypeStateProvider(itemType: widget.itemType, settings: settings).notifier);
        final showCategoryTabs =
            ref.watch(libraryShowCategoryTabsStateProvider(itemType: widget.itemType, settings: settings));
        final continueReaderBtn =
            ref.watch(libraryShowContinueReadingButtonStateProvider(itemType: widget.itemType, settings: settings));
        final showNumbersOfItems =
            ref.watch(libraryShowNumbersOfItemsStateProvider(itemType: widget.itemType, settings: settings));
        final downloadedChapter =
            ref.watch(libraryDownloadedChaptersStateProvider(itemType: widget.itemType, settings: settings));
        final unreadChapter =
            ref.watch(libraryUnreadChaptersStateProvider(itemType: widget.itemType, settings: settings));
        final language = ref.watch(libraryLanguageStateProvider(itemType: widget.itemType, settings: settings));
        final localSource = ref.watch(libraryLocalSourceStateProvider(itemType: widget.itemType, settings: settings));
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(l10n.display_mode),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Wrap(
                    children: DisplayType.values.map((e) {
                  final selected = e == display;
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            side: selected
                                ? null
                                : BorderSide(color: context.isLight ? Colors.black : Colors.white, width: 0.8),
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            backgroundColor:
                                selected ? context.primaryColor.withValues(alpha: 0.2) : Colors.transparent),
                        onPressed: () {
                          displayV.setLibraryDisplayType(e);
                        },
                        child: Text(
                          displayV.getLibraryDisplayTypeName(e, context),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 14),
                        )),
                  );
                }

                        // RadioListTile<
                        //     DisplayType>(
                        //   dense: true,
                        //   title: ,
                        //   value: e,
                        //   groupValue: displayV
                        //       .getLibraryDisplayTypeValue(
                        //           display),
                        //   selected: true,
                        //   onChanged: (value) {
                        //     displayV
                        //         .setLibraryDisplayType(
                        //             value!);
                        //   },
                        // ),
                        ).toList()),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final gridSize = ref.watch(libraryGridSizeStateProvider(itemType: widget.itemType)) ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(context.l10n.grid_size),
                              Text(gridSize == 0 ? context.l10n.default0 : context.l10n.n_per_row(gridSize.toString()))
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
                            ),
                            child: Slider(
                              min: 0.0,
                              max: 7,
                              divisions: max(7, 0),
                              value: gridSize.toDouble(),
                              onChanged: (value) {
                                HapticFeedback.vibrate();
                                ref
                                    .read(libraryGridSizeStateProvider(itemType: widget.itemType).notifier)
                                    .set(value.toInt());
                              },
                              onChangeEnd: (value) {
                                ref
                                    .read(libraryGridSizeStateProvider(itemType: widget.itemType).notifier)
                                    .set(value.toInt(), end: true);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(l10n.badges),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    ListTileItemFilter(
                        label: widget.itemType == ItemType.anime ? l10n.downloaded_episodes : l10n.downloaded_chapters,
                        type: downloadedChapter ? 1 : 0,
                        onTap: () {
                          ref
                              .read(
                                  libraryDownloadedChaptersStateProvider(itemType: widget.itemType, settings: settings)
                                      .notifier)
                              .set(!downloadedChapter);
                        }),
                    ListTileItemFilter(
                        label: l10n.unread_chapters,
                        type: unreadChapter ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryUnreadChaptersStateProvider(itemType: widget.itemType, settings: settings)
                                  .notifier)
                              .set(!unreadChapter);
                        }),
                    ListTileItemFilter(
                        label: l10n.language,
                        type: language ? 1 : 0,
                        onTap: () {
                          ref
                              .read(
                                  libraryLanguageStateProvider(itemType: widget.itemType, settings: settings).notifier)
                              .set(!language);
                        }),
                    ListTileItemFilter(
                        label: l10n.local_source,
                        type: localSource ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryLocalSourceStateProvider(itemType: widget.itemType, settings: settings)
                                  .notifier)
                              .set(!localSource);
                        }),
                    ListTileItemFilter(
                        label: widget.itemType == ItemType.anime
                            ? l10n.show_continue_watching_buttons
                            : l10n.show_continue_reading_buttons,
                        type: continueReaderBtn ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryShowContinueReadingButtonStateProvider(
                                      itemType: widget.itemType, settings: settings)
                                  .notifier)
                              .set(!continueReaderBtn);
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [Text(l10n.tabs)],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    ListTileItemFilter(
                        label: l10n.show_category_tabs,
                        type: showCategoryTabs ? 1 : 0,
                        onTap: () {
                          ref
                              .read(libraryShowCategoryTabsStateProvider(itemType: widget.itemType, settings: settings)
                                  .notifier)
                              .set(!showCategoryTabs);
                        }),
                    ListTileItemFilter(
                        label: l10n.show_numbers_of_items,
                        type: showNumbersOfItems ? 1 : 0,
                        onTap: () {
                          ref
                              .read(
                                  libraryShowNumbersOfItemsStateProvider(itemType: widget.itemType, settings: settings)
                                      .notifier)
                              .set(!showNumbersOfItems);
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    ], context: context, vsync: this);
  }

  String _getSortNameByIndex(int index, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    if (index == 0) {
      return l10n.alphabetically;
    } else if (index == 1) {
      return widget.itemType != ItemType.anime ? l10n.last_read : l10n.last_watched;
    } else if (index == 2) {
      return l10n.last_update_check;
    } else if (index == 3) {
      return widget.itemType != ItemType.anime ? l10n.unread_count : l10n.unwatched_count;
    } else if (index == 4) {
      return widget.itemType != ItemType.anime ? l10n.total_chapters : l10n.total_episodes;
    } else if (index == 5) {
      return widget.itemType != ItemType.anime ? l10n.latest_chapter : l10n.latest_episode;
    }
    return l10n.date_added;
  }

  PreferredSize _appBar(
    bool isNotFiltering,
    bool showNumbersOfItems,
    int numberOfItems,
    WidgetRef ref,
    bool isCategory,
    int? categoryId,
    Settings settings,
  ) {
    final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
    final mangaIdsList = ref.watch(mangasListStateProvider);
    final manga = categoryId == null
        ? ref.watch(getAllMangaWithoutCategoriesStreamProvider(itemType: widget.itemType))
        : ref.watch(getAllMangaStreamProvider(categoryId: categoryId, itemType: widget.itemType));
    final l10n = l10nLocalizations(context)!;
    return PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: isLongPressed
            ? manga.when(
                data: (data) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: AppBar(
                    title: Text(mangaIdsList.length.toString()),
                    backgroundColor: context.primaryColor.withValues(alpha: 0.2),
                    leading: IconButton(
                        onPressed: () {
                          ref.read(mangasListStateProvider.notifier).clear();

                          ref.read(isLongPressedMangaStateProvider.notifier).update(!isLongPressed);
                        },
                        icon: const Icon(Icons.clear)),
                    actions: [
                      IconButton(
                          onPressed: () {
                            for (var manga in data) {
                              ref.read(mangasListStateProvider.notifier).selectAll(manga);
                            }
                          },
                          icon: const Icon(Icons.select_all)),
                      IconButton(
                          onPressed: () {
                            if (data.length == mangaIdsList.length) {
                              for (var manga in data) {
                                ref.read(mangasListStateProvider.notifier).selectSome(manga);
                              }
                              ref.read(isLongPressedMangaStateProvider.notifier).update(false);
                            } else {
                              for (var manga in data) {
                                ref.read(mangasListStateProvider.notifier).selectSome(manga);
                              }
                            }
                          },
                          icon: const Icon(Icons.flip_to_back_rounded)),
                    ],
                  ),
                ),
                error: (Object error, StackTrace stackTrace) {
                  return ErrorText(error);
                },
                loading: () {
                  return const ProgressCenter();
                },
              )
            : AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: _isSearch
                    ? null
                    : Row(
                        children: [
                          Text(
                            widget.itemType == ItemType.manga
                                ? l10n.manga
                                : widget.itemType == ItemType.anime
                                    ? l10n.anime
                                    : l10n.novel,
                            style: TextStyle(color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(width: 10),
                          if (showNumbersOfItems)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: _numberBadge(numberOfItems, fontSize: 12),
                            ),
                        ],
                      ),
                actions: [
                  _isSearch
                      ? SeachFormTextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          onPressed: () {
                            setState(() {
                              _isSearch = false;
                            });
                            _textEditingController.clear();
                          },
                          controller: _textEditingController,
                          onSuffixPressed: () {
                            _textEditingController.clear();
                            setState(() {});
                          },
                        )
                      : IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            setState(() {
                              _isSearch = true;
                            });
                            _textEditingController.clear();
                          },
                          icon: const Icon(
                            Icons.search,
                          )),
                  IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        _showDraggableMenu(settings);
                      },
                      icon: Icon(
                        Icons.filter_list_sharp,
                        color: isNotFiltering ? null : Colors.yellow,
                      )),
                  PopupMenuButton(
                      popUpAnimationStyle: popupAnimationStyle,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem<int>(
                            value: 0,
                            child: Text(context.l10n.update_library),
                          ),
                          PopupMenuItem<int>(value: 1, child: Text(l10n.open_random_entry)),
                          PopupMenuItem<int>(value: 2, child: Text(l10n.import)),
                          if (widget.itemType == ItemType.anime)
                            PopupMenuItem<int>(value: 3, child: Text(l10n.torrent_stream)),
                        ];
                      },
                      onSelected: (value) {
                        if (value == 0) {
                          manga.whenData((value) {
                            _updateLibrary(value);
                          });
                        } else if (value == 1) {
                          manga.whenData((value) {
                            var randomManga = (value..shuffle()).first;
                            pushToMangaReaderDetail(
                                ref: ref,
                                archiveId: randomManga.isLocalArchive ?? false ? randomManga.id : null,
                                context: context,
                                lang: randomManga.lang!,
                                mangaM: randomManga,
                                source: randomManga.source!);
                          });
                        } else if (value == 2) {
                          _importLocal(context, widget.itemType);
                        } else if (value == 3 && widget.itemType == ItemType.anime) {
                          addTorrent(context);
                        }
                      }),
                ],
              ));
  }
}

void _importLocal(BuildContext context, ItemType itemType) {
  final l10n = l10nLocalizations(context)!;
  bool isLoading = false;
  showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.import_local_file,
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Consumer(builder: (context, ref, child) {
                return SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await ref.watch(
                                      importArchivesFromFileProvider(itemType: itemType, null, init: true).future);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(Icons.archive_outlined),
                                    Text(
                                        "${l10n.import_files} ( ${itemType == ItemType.manga ? ".zip, .cbz" : ".mp4, .mkv, .avi, and more"} )",
                                        style: TextStyle(
                                            color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isLoading)
                        Container(
                          width: context.width(1),
                          height: context.height(1),
                          color: Colors.transparent,
                          child: UnconstrainedBox(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                height: 50,
                                width: 50,
                                child: const Center(child: ProgressCenter())),
                          ),
                        )
                    ],
                  ),
                );
              });
            },
          ),
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
              ],
            )
          ],
        );
      });
}

void addTorrent(BuildContext context, {Manga? manga}) {
  final l10n = l10nLocalizations(context)!;
  String torrentUrl = "";
  bool isLoading = false;
  showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) {
        return AlertDialog(
          title: Text(
            l10n.add_torrent,
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Consumer(builder: (context, ref, _) {
                return SizedBox(
                  height: 150,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  torrentUrl = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: l10n.enter_torrent_hint_text,
                                  labelText: l10n.torrent_url,
                                  isDense: true,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  enabledBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: context.secondaryColor)),
                                  focusedBorder:
                                      OutlineInputBorder(borderSide: BorderSide(color: context.secondaryColor)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: context.secondaryColor))),
                            ),
                          ),
                          TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await ref.watch(
                                            addTorrentFromUrlOrFromFileProvider(manga, init: true, url: torrentUrl)
                                                .future);
                                      } catch (_) {}

                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pop(context);
                                    },
                              child: Text(l10n.add))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(l10n.or),
                      ),
                      Stack(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    onPressed: isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            try {
                                              await ref
                                                  .watch(addTorrentFromUrlOrFromFileProvider(manga, init: true).future);
                                            } catch (_) {}

                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pop(context);
                                          },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Icon(Icons.archive_outlined),
                                        Text("import .torrent file",
                                            style: TextStyle(
                                                color: Theme.of(context).textTheme.bodySmall!.color, fontSize: 10))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLoading)
                            Positioned.fill(
                              child: Container(
                                width: 300,
                                height: 150,
                                color: Colors.transparent,
                                child: UnconstrainedBox(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: const Center(child: ProgressCenter())),
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                );
              });
            },
          ),
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
              ],
            )
          ],
        );
      });
}
