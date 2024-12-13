import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:draggable_menu/draggable_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/dart/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/manga/detail/chapters_list_model.dart';
import 'package:mangayomi/modules/manga/detail/chapters_selection_controls.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/genre_badges_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_actions_menu.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_chapters_counter.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_chapters_menu.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover_backdrop.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_list_tile.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_source_baseurl.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../../utils/constant.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Function(bool) isExtended;
  final Widget? titleDescription;
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
    this.titleDescription,
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

  bool _expanded = false;
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
      filter: ChapterFilterModel(
        filterUnread: filterUnread.filter,
        filterBookmarked: filterBookmarked.filter,
        filterDownloaded: filterDownloaded.filter,
        filterScanlator: scanlators.$2,
      ),
      sort: ChapterSortModel(sortState),
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
              reverse: sortState.reverse!,
              isLongPressed: isLongPressed,
            );
          },
          error: (Object error, StackTrace stackTrace) => ErrorText(error),
          loading: () => const ProgressCenter(),
        ));
  }

  Widget _buildWidget({
    required List<Chapter> chapters,
    required bool reverse,
    required bool isLongPressed,
  }) {
    final l10n = l10nLocalizations(context)!;
    final chapterLength = chapters.length;
    final reverseList = chapters.reversed.toList();

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
                      child: SingleChildScrollView(child: _bodyContainer(chapterLength: chapterLength)),
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
                                int index = chapters.indexOf(chap.first);
                                chapters[index + 1].updateTrackChapterRead(ref);
                                isar.writeTxnSync(() {
                                  for (var i = index + 1; i < chapterLength; i++) {
                                    if (!chapters[i].isRead!) {
                                      chapters[i].isRead = true;
                                      chapters[i].lastPageRead = "1";
                                      ref
                                          .read(changedItemsManagerProvider(managerId: 1).notifier)
                                          .addUpdatedChapter(chapters[i], false, false);
                                      isar.chapters.putSync(chapters[i]..manga.value = widget.manga);
                                      chapters[i].manga.saveSync();
                                    }
                                  }
                                  ref.read(isLongPressedStateProvider.notifier).update(false);
                                  ref.read(chaptersListStateProvider.notifier).clear();
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

  Widget _bodyContainer({required int chapterLength}) {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.05),
                Theme.of(context).scaffoldBackgroundColor
              ],
              stops: const [0, .3],
            ),
          ),
        ),
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: context.width(1),
                  child: Row(
                    children: [
                      _coverCard(),
                      Expanded(child: _titles()),
                    ],
                  ),
                ),
                if (isLocalArchive)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: _editLocalArchiveInfos,
                      icon: const CircleAvatar(child: Icon(Icons.edit_outlined)),
                    ),
                  )
              ],
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (manga.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: manga.description!,
                        initial: _expanded,
                        onChanged: (value) {
                          setState(() {
                            _expanded = value;
                          });
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GenreBadgesWidget(genres: manga.genre!, multiline: _expanded || context.isTablet),
                  ),
                  if (!context.isTablet) MangaChaptersCounter(manga: manga),
                ],
              ),
            ),
            if (chapterLength == 0)
              Container(
                  width: context.width(1), height: context.height(1), color: Theme.of(context).scaffoldBackgroundColor)
          ],
        ),
      ],
    );
  }

  Widget _titles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: manga.name!));

            botToast('Copied!', second: 3);
          },
          child: Text(manga.name!,
              style: const TextStyle(
                fontSize: 20,
              )),
        ),
        widget.titleDescription!,
      ],
    );
  }

  void _editLocalArchiveInfos() {
    final l10n = l10nLocalizations(context)!;
    TextEditingController? name = TextEditingController(text: manga.name!);
    TextEditingController? description = TextEditingController(text: manga.description!);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              l10n.edit,
            ),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(l10n.name),
                        ),
                        TextFormField(
                          controller: name,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(l10n.description),
                        ),
                        TextFormField(
                          controller: description,
                        ),
                      ],
                    ),
                  )
                ],
              ),
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
                  TextButton(
                      onPressed: () {
                        isar.writeTxnSync(() {
                          manga.description = description.text;
                          manga.name = name.text;
                          isar.mangas.putSync(manga);
                        });
                        Navigator.pop(context);
                      },
                      child: Text(l10n.edit)),
                ],
              )
            ],
          );
        });
  }

  void _trackingDraggableMenu(List<TrackPreference>? entries) {
    DraggableMenu.open(
        context,
        DraggableMenu(
          ui: ClassicDraggableMenu(radius: 20, barItem: Container(), color: Theme.of(context).scaffoldBackgroundColor),
          allowToShrink: true,
          child: Material(
            color: context.isLight
                ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9)
                : !ref.watch(pureBlackDarkModeStateProvider)
                    ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9)
                    : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemCount: entries!.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                      stream: isar.tracks
                          .filter()
                          .idIsNotNull()
                          .syncIdEqualTo(entries[index].syncId)
                          .mangaIdEqualTo(mangaId)
                          .watch(fireImmediately: true),
                      builder: (context, snapshot) {
                        List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
                        return trackRes!.isNotEmpty
                            ? TrackerWidget(
                                mangaId: mangaId,
                                syncId: entries[index].syncId!,
                                trackRes: trackRes.first,
                                isManga: manga.isManga!)
                            : TrackListTile(
                                text: l10nLocalizations(context)!.add_tracker,
                                onTap: () async {
                                  final trackSearch = await trackersSearchraggableMenu(
                                    context,
                                    isManga: manga.isManga!,
                                    track: Track(
                                        status: TrackStatus.planToRead,
                                        syncId: entries[index].syncId!,
                                        title: manga.name!),
                                  ) as TrackSearch?;
                                  if (trackSearch != null) {
                                    await ref
                                        .read(trackStateProvider(track: null, isManga: manga.isManga!).notifier)
                                        .setTrackSearch(trackSearch, mangaId, entries[index].syncId!);
                                  }
                                },
                                id: entries[index].syncId!,
                                entries: const []);
                      });
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ),
        ));
  }
}
