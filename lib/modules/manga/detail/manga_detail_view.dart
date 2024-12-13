import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/chapters_list_model.dart';
import 'package:mangayomi/modules/manga/detail/chapters_selection_controls.dart';
import 'package:mangayomi/modules/manga/detail/manga_info.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_actions_menu.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_chapters_counter.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_chapters_menu.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover_backdrop.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Function(bool) isExtended;
  final List<Color>? backButtonColors;
  final Manga? manga;
  final bool sourceExist;
  final Function(bool) checkForUpdate;

  const MangaDetailView({
    super.key,
    required this.isExtended,
    required this.sourceExist,
    required this.manga,
    required this.checkForUpdate,
    this.backButtonColors,
  });

  @override
  ConsumerState<MangaDetailView> createState() => _MangaDetailViewState();
}

class _MangaDetailViewState extends ConsumerState<MangaDetailView> with TickerProviderStateMixin {
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        ref.read(offsetProvider.notifier).state = _scrollController.offset;
      });
    super.initState();
  }

  ScrollController _scrollController = ScrollController();
  final offsetProvider = StateProvider((ref) => 0.0);
  late final isLocalArchive = widget.manga!.isLocalArchive ?? false;
  late final manga = widget.manga!;
  late final mangaId = manga.id;

  @override
  Widget build(BuildContext context) {
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final scanlators = ref.watch(scanlatorsFilterStateProvider(manga));
    final sortState = ref.watch(sortChapterStateProvider(mangaId: mangaId));
    final filterUnread = ref.watch(chapterFilterUnreadStateProvider(mangaId: mangaId));
    final filterBookmarked = ref.watch(chapterFilterBookmarkedStateProvider(mangaId: mangaId));
    final filterDownloaded = ref.watch(chapterFilterDownloadedStateProvider(mangaId: mangaId));
    final chapters = ref.watch(getChaptersFilteredStreamProvider(
      mangaId: mangaId,
      model: ChaptersListModel(
        filter: ChapterFilterModel(
          filterUnread: filterUnread.filter,
          filterBookmarked: filterBookmarked.filter,
          filterDownloaded: filterDownloaded.filter,
          filterScanlator: scanlators.$2,
        ),
        sort: ChapterSortModel(sortState),
      ),
    ));

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        if (notification.direction != ScrollDirection.idle) {
          widget.isExtended(notification.direction == ScrollDirection.forward);
        }

        return true;
      },
      child: chapters.when(
        data: (data) {
          ref.read(chaptersListttStateProvider.notifier).set(data);

          return _buildWidget(
            chapters: data,
            isLongPressed: isLongPressed,
          );
        },
        error: (Object error, StackTrace stackTrace) => ErrorText(error),
        loading: () => _buildWidget(
          chapters: manga.chapters.toList(growable: false),
          isLongPressed: isLongPressed,
        ),
      ),
    );
  }

  Widget _buildWidget({required List<Chapter> chapters, required bool isLongPressed}) {
    final l10n = l10nLocalizations(context)!;
    final chapterLength = chapters.length;

    final details = MangaInfo(manga: manga, sourceExist: widget.sourceExist, chapters: chapterLength);

    return Stack(
      children: [
        Consumer(builder: (context, ref, child) => MangaCoverBackdrop(manga: manga, active: ref.watch(offsetProvider) < 100)),
        Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child: Consumer(
                  builder: (context, ref, child) {
                    final offset = ref.watch(offsetProvider);
                    final bgAlpha = ((1.0 - clampDouble(100 - offset, 0, 100) / 100.0) * 255).toInt();
                    final textAlpha = max(0, bgAlpha - 128 - 64) * 4;

                    final isLongPressed = ref.watch(isLongPressedStateProvider);
                    return isLongPressed
                        ? ChaptersSelectionBar(manga: manga, chapters: chapters)
                        : AppBar(
                            title: textAlpha > 0
                                ? Text(
                                    manga.name!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: context.dynamicThemeColor.withAlpha(textAlpha),
                                    ),
                                  )
                                : null,
                            backgroundColor: bgAlpha > 0
                                ? Theme.of(context).scaffoldBackgroundColor.withAlpha(bgAlpha)
                                : Colors.transparent,
                            actions: [
                              MangaChaptersMenu(manga: manga),
                              MangaActionsMenu(manga: manga, checkForUpdate: widget.checkForUpdate),
                            ],
                          );
                  },
                )),
            body: SafeArea(
              child: Row(
                children: [
                  if (context.isTablet)
                    SizedBox(
                      width: context.width(0.5),
                      height: context.height(1),
                      child: SingleChildScrollView(child: details),
                    ),
                  Expanded(
                    child: Scrollbar(
                        interactive: true,
                        thickness: 12,
                        radius: const Radius.circular(10),
                        controller: _scrollController,
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.only(top: 0, bottom: 60),
                              sliver: Consumer(builder: (context, ref, _) {
                                final chaptersSelection = ref.watch(chaptersListStateProvider);

                                return SuperSliverList.builder(
                                    itemCount: chapterLength + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return context.isTablet //
                                            ? MangaChaptersCounter(manga: manga, chapters: chapterLength)
                                            : details;
                                      }

                                      final chapter = chapters[index - 1];

                                      return ChapterListTileWidget(
                                        chapter: chapter,
                                        isSelected: chaptersSelection.contains(chapter),
                                        sourceExist: widget.sourceExist,
                                      );
                                    });
                              }),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Consumer(builder: (context, ref, child) {
              final chap = ref.watch(chaptersListStateProvider);
              bool getLength1 = chap.length == 1;
              bool checkFirstBookmarked = chap.isNotEmpty && chap.first.isBookmarked! && getLength1;
              bool checkReadBookmarked = chap.isNotEmpty && chap.first.isRead! && getLength1;

              return AnimatedContainer(
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.2),
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
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              final chapters = ref.watch(chaptersListStateProvider);
                              isar.writeTxnSync(() {
                                for (var chapter in chapters) {
                                  chapter.isBookmarked = !chapter.isBookmarked!;
                                  ref
                                      .read(changedItemsManagerProvider(managerId: 1).notifier)
                                      .addUpdatedChapter(chapter, false, false);
                                  isar.chapters.putSync(chapter..manga.value = widget.manga);
                                  chapter.manga.saveSync();
                                }
                              });
                              ref.read(isLongPressedStateProvider.notifier).update(false);
                              ref.read(chaptersListStateProvider.notifier).clear();
                            },
                            child: Icon(
                                checkFirstBookmarked ? Icons.bookmark_remove_outlined : Icons.bookmark_add_outlined,
                                color: Theme.of(context).textTheme.bodyLarge!.color)),
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
                              final chapters = ref.watch(chaptersListStateProvider);
                              isar.writeTxnSync(() {
                                for (var chapter in chapters) {
                                  chapter.isRead = !chapter.isRead!;
                                  if (!chapter.isRead!) {
                                    chapter.lastPageRead = "1";
                                  }
                                  ref
                                      .read(changedItemsManagerProvider(managerId: 1).notifier)
                                      .addUpdatedChapter(chapter, false, false);
                                  isar.chapters.putSync(chapter..manga.value = widget.manga);
                                  chapter.manga.saveSync();
                                  if (chapter.isRead!) {
                                    chapter.updateTrackChapterRead(ref);
                                  }
                                }
                              });
                              ref.read(isLongPressedStateProvider.notifier).update(false);
                              ref.read(chaptersListStateProvider.notifier).clear();
                            },
                            child: Icon(
                              checkReadBookmarked ? Icons.remove_done_sharp : Icons.done_all_sharp,
                              color: Theme.of(context).textTheme.bodyLarge!.color!,
                            ),
                          )),
                    ),
                    if (getLength1)
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
                                final int index = chapters.indexOf(chap.first);
                                chapters[index + 1].updateTrackChapterRead(ref);

                                ref.read(isLongPressedStateProvider.notifier).update(false);
                                ref.read(chaptersListStateProvider.notifier).clear();
                                final changeLog = ref.read(changedItemsManagerProvider(managerId: 1).notifier);
                                final List<Chapter> updated = [];

                                for (var chapter in chapters.skip(index)) {
                                  if (chapter.isRead!) {
                                    continue;
                                  }

                                  chapter.isRead = true;
                                  chapter.lastPageRead = "1";
                                  changeLog.addUpdatedChapter(chapter, false, false);
                                  updated.add(chapter..manga.value = widget.manga);
                                  chapter.manga.saveSync();
                                }

                                isar.writeTxnSync(() {
                                  isar.chapters.putAllSync(updated);
                                });
                              },
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.done_outlined,
                                    color: Theme.of(context).textTheme.bodyLarge!.color!,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.arrow_downward_outlined,
                                      size: 11,
                                      color: Theme.of(context).textTheme.bodyLarge!.color!,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                    if (!isLocalArchive)
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
                                isar.txnSync(() {
                                  for (var chapter in ref.watch(chaptersListStateProvider)) {
                                    final entries = isar.downloads
                                        .filter()
                                        .idIsNotNull()
                                        .chapterIdEqualTo(chapter.id)
                                        .findAllSync();
                                    if (entries.isEmpty || !entries.first.isDownload!) {
                                      ref.watch(downloadChapterProvider(chapter: chapter));
                                    }
                                  }
                                });
                                ref.read(isLongPressedStateProvider.notifier).update(false);
                                ref.read(chaptersListStateProvider.notifier).clear();
                              },
                              child: Icon(
                                Icons.download_outlined,
                                color: Theme.of(context).textTheme.bodyLarge!.color!,
                              )),
                        ),
                      ),
                    if (isLocalArchive)
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
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(l10n.delete_chapters),
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
                                                    isar.writeTxnSync(() {
                                                      for (var chapter in ref.watch(chaptersListStateProvider)) {
                                                        isar.chapters.deleteSync(chapter.id!);
                                                      }
                                                    });
                                                    ref.read(isLongPressedStateProvider.notifier).update(false);
                                                    ref.read(chaptersListStateProvider.notifier).clear();
                                                    if (mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(l10n.delete)),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Icon(
                                Icons.delete_outline_outlined,
                                color: Theme.of(context).textTheme.bodyLarge!.color!,
                              )),
                        ),
                      )
                  ],
                ),
              );
            })),
      ],
    );
  }
}
