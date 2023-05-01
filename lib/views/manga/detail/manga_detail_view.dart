import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_menu/draggable_menu.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/views/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/views/manga/detail/readmore.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_list_tile_widget.dart';
import 'package:mangayomi/views/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';

class MangaDetailView extends ConsumerStatefulWidget {
  final Function(bool) isExtended;

  final int listLength;
  final Widget? titleDescription;
  final List<Color>? backButtonColors;
  final Widget? action;
  final ModelManga? modelManga;
  const MangaDetailView({
    super.key,
    required this.isExtended,
    this.titleDescription,
    this.backButtonColors,
    this.action,
    required this.modelManga,
    required this.listLength,
  });

  @override
  ConsumerState<MangaDetailView> createState() => _MangaDetailViewState();
}

class _MangaDetailViewState extends ConsumerState<MangaDetailView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        ref.read(offetProvider.notifier).state = _scrollController.offset;
      });
    super.initState();
  }

  final offetProvider = StateProvider((ref) => 0.0);
  bool _expanded = false;
  ScrollController _scrollController = ScrollController();

  List<ModelChapters>? _chapters;
  ModelManga? _modelManga;
  int? _pageLength;

  @override
  Widget build(BuildContext context) {
    _chapters = ref
        .watch(chapterFilterResultStateProvider(modelManga: widget.modelManga!))
        .chapters;
    _modelManga = ref.watch(
        chapterFilterResultStateProvider(modelManga: widget.modelManga!));

    _pageLength = ref
            .watch(chapterFilterResultStateProvider(
                modelManga: widget.modelManga!))
            .chapters!
            .length +
        1;

    final reverse =
        ref.watch(reverseMangaStateProvider(modelManga: widget.modelManga!));

    return NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            widget.isExtended(true);
          }
          if (notification.direction == ScrollDirection.reverse) {
            widget.isExtended(false);
          }
          return true;
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppBar().preferredSize.height),
                child: Consumer(
                  builder: (context, ref, child) {
                    final isNotFiltering = ref
                        .read(chapterFilterResultStateProvider(
                                modelManga: widget.modelManga!)
                            .notifier)
                        .isNotFiltering();
                    final isLongPressed = ref.watch(isLongPressedStateProvider);
                    final chapterNameList =
                        ref.watch(chapterNameListStateProvider);
                    return isLongPressed
                        ? Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: AppBar(
                              title: Text(chapterNameList.length.toString()),
                              backgroundColor:
                                  primaryColor(context).withOpacity(0.2),
                              leading: IconButton(
                                  onPressed: () {
                                    ref
                                        .read(chapterNameListStateProvider
                                            .notifier)
                                        .clear();

                                    ref
                                        .read(
                                            isLongPressedStateProvider.notifier)
                                        .update(!isLongPressed);
                                  },
                                  icon: const Icon(Icons.clear)),
                              actions: [
                                IconButton(
                                    onPressed: () {
                                      for (var i = 0;
                                          i <
                                              widget
                                                  .modelManga!.chapters!.length;
                                          i++) {
                                        ref
                                            .read(chapterNameListStateProvider
                                                .notifier)
                                            .selectAll(widget.modelManga!
                                                .chapters![i].name!);
                                      }
                                    },
                                    icon: const Icon(Icons.select_all)),
                                IconButton(
                                    onPressed: () {
                                      if (widget.modelManga!.chapters!.length ==
                                          chapterNameList.length) {
                                        for (var i = 0;
                                            i <
                                                widget.modelManga!.chapters!
                                                    .length;
                                            i++) {
                                          ref
                                              .read(chapterNameListStateProvider
                                                  .notifier)
                                              .selectSome(widget.modelManga!
                                                  .chapters![i].name!);
                                        }
                                        ref
                                            .read(isLongPressedStateProvider
                                                .notifier)
                                            .update(false);
                                      } else {
                                        for (var i = 0;
                                            i <
                                                widget.modelManga!.chapters!
                                                    .length;
                                            i++) {
                                          ref
                                              .read(chapterNameListStateProvider
                                                  .notifier)
                                              .selectSome(widget.modelManga!
                                                  .chapters![i].name!);
                                        }
                                      }
                                    },
                                    icon:
                                        const Icon(Icons.flip_to_back_rounded)),
                              ],
                            ),
                          )
                        : AppBar(
                            title: ref.watch(offetProvider) > 200
                                ? Text(
                                    widget.modelManga!.name!,
                                    style: const TextStyle(fontSize: 17),
                                  )
                                : null,
                            backgroundColor: ref.watch(offetProvider) == 0.0
                                ? Colors.transparent
                                : Theme.of(context).scaffoldBackgroundColor,
                            actions: [
                              IconButton(
                                  splashRadius: 20,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.download_outlined,
                                  )),
                              IconButton(
                                  splashRadius: 20,
                                  onPressed: () {
                                    _showDraggableMenu();
                                  },
                                  icon: Icon(
                                    Icons.filter_list_sharp,
                                    color:
                                        isNotFiltering ? null : Colors.yellow,
                                  )),
                              PopupMenuButton(
                                  itemBuilder: (context) {
                                    return [
                                      const PopupMenuItem<int>(
                                          value: 0,
                                          child: Text("Edit categories")),
                                      const PopupMenuItem<int>(
                                          value: 0, child: Text("Migrate")),
                                      const PopupMenuItem<int>(
                                          value: 0, child: Text("Share")),
                                    ];
                                  },
                                  onSelected: (value) {}),
                            ],
                          );
                  },
                )),
            body: Stack(
              children: [
                Positioned(
                    top: 0,
                    child: Stack(
                      children: [
                        cachedNetworkImage(
                            imageUrl: widget.modelManga!.imageUrl!,
                            width: mediaWidth(context, 1),
                            height: 461,
                            fit: BoxFit.cover),
                        Container(
                          width: mediaWidth(context, 1),
                          height: 465,
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                        ),
                        SafeArea(
                          child: Container(
                              width: mediaWidth(context, 1),
                              height: mediaHeight(context, 1),
                              color: Theme.of(context).scaffoldBackgroundColor),
                        )
                      ],
                    )),
                SafeArea(
                    child: DraggableScrollbar(
                        heightScrollThumb: 48.0,
                        backgroundColor: primaryColor(context),
                        scrollThumbBuilder: (backgroundColor, thumbAnimation,
                            labelAnimation, height,
                            {labelConstraints, labelText}) {
                          return FadeTransition(
                            opacity: thumbAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: height,
                              width: 8.0,
                            ),
                          );
                        },
                        scrollbarTimeToFade: const Duration(seconds: 2),
                        controller: _scrollController,
                        child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(top: 0, bottom: 60),
                            itemCount: _pageLength,
                            itemBuilder: (context, index) {
                              int finalIndex = index - 1;
                              if (index == 0) {
                                return _bodyContainer();
                              }
                              int reverseIndex = _chapters!.length -
                                  _chapters!.reversed.toList().indexOf(
                                      _chapters!.reversed
                                          .toList()[finalIndex]) -
                                  1;

                              List<ModelChapters> chapters = reverse
                                  ? _chapters!.reversed.toList()
                                  : _chapters!;

                              return ChapterListTileWidget(
                                chapters: chapters,
                                modelManga: _modelManga!,
                                reverse: reverse,
                                reverseIndex: reverseIndex,
                                finalIndex: finalIndex,
                              );
                            }))),
              ],
            ),
            bottomNavigationBar: Consumer(
              builder: (context, ref, child) {
                final chapter = ref.watch(chapterModelStateProvider);
                final isLongPressed = ref.watch(isLongPressedStateProvider);
                return AnimatedContainer(
                  curve: Curves.easeIn,
                  decoration: BoxDecoration(
                      color: primaryColor(context).withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  duration: const Duration(milliseconds: 100),
                  height: isLongPressed ? 70 : 0,
                  width: mediaWidth(context, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent),
                              onPressed: () async {
                                ref
                                    .read(chapterSetIsBookmarkStateProvider(
                                            modelManga: widget.modelManga!)
                                        .notifier)
                                    .set();
                                ref
                                    .read(chapterNameListStateProvider.notifier)
                                    .clear();
                              },
                              child: Icon(chapter.isBookmarked
                                  ? Icons.bookmark_remove
                                  : Icons.bookmark_add_outlined)),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent),
                              onPressed: () {
                                ref
                                    .read(chapterSetIsReadStateProvider(
                                            modelManga: widget.modelManga!)
                                        .notifier)
                                    .set();
                                ref
                                    .read(chapterNameListStateProvider.notifier)
                                    .clear();
                              },
                              child: Icon(chapter.isRead
                                  ? Icons.remove_done_sharp
                                  : Icons.done_all_sharp)),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent),
                              onPressed: () {
                                ref
                                    .read(chapterSetDownloadStateProvider(
                                            modelManga: widget.modelManga!)
                                        .notifier)
                                    .set();
                                ref
                                    .read(chapterNameListStateProvider.notifier)
                                    .clear();
                              },
                              child: const Icon(Icons.download_outlined)),
                        ),
                      )
                    ],
                  ),
                );
              },
            )));
  }

  _showDraggableMenu() {
    late TabController tabBarController;
    tabBarController = TabController(length: 3, vsync: this);
    tabBarController.animateTo(0);
    DraggableMenu.open(
      context,
      DraggableMenu(
        barItem: Container(),
        uiType: DraggableMenuUiType.classic,
        expandable: false,
        maxHeight: mediaHeight(context, 0.36),
        fastDrag: false,
        minimizeBeforeFastDrag: false,
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              body: Column(
                children: [
                  TabBar(
                    controller: tabBarController,
                    tabs: const [
                      Tab(text: "Filter"),
                      Tab(text: "Sort"),
                      Tab(text: "Display"),
                    ],
                  ),
                  Flexible(
                    child: TabBarView(controller: tabBarController, children: [
                      Consumer(builder: (context, ref, chil) {
                        return Column(
                          children: [
                            ListTileChapterFilter(
                                label: "Downloaded",
                                type: ref.watch(
                                    chapterFilterDownloadedStateProvider(
                                        modelManga: widget.modelManga!)),
                                onTap: () {
                                  ref
                                      .read(
                                          chapterFilterDownloadedStateProvider(
                                                  modelManga:
                                                      widget.modelManga!)
                                              .notifier)
                                      .update();
                                }),
                            ListTileChapterFilter(
                                label: "Unread",
                                type: ref.watch(
                                    chapterFilterUnreadStateProvider(
                                        modelManga: widget.modelManga!)),
                                onTap: () {
                                  ref
                                      .read(chapterFilterUnreadStateProvider(
                                              modelManga: widget.modelManga!)
                                          .notifier)
                                      .update();
                                }),
                            ListTileChapterFilter(
                                label: "Bookmarked",
                                type: ref.watch(
                                    chapterFilterBookmarkedStateProvider(
                                        modelManga: widget.modelManga!)),
                                onTap: () {
                                  ref
                                      .read(
                                          chapterFilterBookmarkedStateProvider(
                                                  modelManga:
                                                      widget.modelManga!)
                                              .notifier)
                                      .update();
                                }),
                          ],
                        );
                      }),
                      Consumer(builder: (context, ref, chil) {
                        final reverse = ref.watch(reverseMangaStateProvider(
                            modelManga: widget.modelManga!));
                        return Column(
                          children: [
                            ListTileChapterSort(
                                label: "By upload date",
                                reverse: reverse,
                                onTap: () {
                                  ref
                                      .read(reverseMangaStateProvider(
                                              modelManga: widget.modelManga!)
                                          .notifier)
                                      .update(!reverse);
                                }),
                          ],
                        );
                      }),
                      Consumer(builder: (context, ref, chil) {
                        return Column(
                          children: [
                            RadioListTile(
                              title: const Text("Source title"),
                              value: "e",
                              groupValue: "e",
                              selected: true,
                              onChanged: (value) {},
                            ),
                            RadioListTile(
                              title: const Text("Chapter number"),
                              value: "ej",
                              groupValue: "e",
                              selected: false,
                              onChanged: (value) {},
                            ),
                          ],
                        );
                      }),
                    ]),
                  ),
                ],
              ),
            )),
      ),
      barrier: true,
    );
  }

  Widget _bodyContainer() {
    return Stack(
      children: [
        Positioned(
            top: 0,
            child: cachedNetworkImage(
                imageUrl: widget.modelManga!.imageUrl!,
                width: mediaWidth(context, 1),
                height: 300,
                fit: BoxFit.cover)),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                Color(Theme.of(context).scaffoldBackgroundColor.value)
              ],
              stops: const [0, .35],
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 180,
              child: Stack(
                children: [
                  _titles(),
                  _coverCard(),
                ],
              ),
            ),
            _actionConstructor(),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.modelManga!.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: widget.modelManga!.description!,
                        onChanged: (value) {
                          setState(() {
                            _expanded = value;
                          });
                        },
                      ),
                    ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _expanded
                          ? Wrap(
                              children: [
                                for (var i = 0;
                                    i < widget.modelManga!.genre!.length;
                                    i++)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 2, bottom: 5),
                                    child: SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                        onPressed: () {},
                                        child: Text(
                                          widget.modelManga!.genre![i],
                                          style: TextStyle(
                                              fontSize: 11.5,
                                              color: isLight(context)
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  for (var i = 0;
                                      i < widget.modelManga!.genre!.length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2, bottom: 5),
                                      child: SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.2),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          onPressed: () {},
                                          child: Text(
                                            widget.modelManga!.genre![i],
                                            style: TextStyle(
                                                fontSize: 11.5,
                                                color: isLight(context)
                                                    ? Colors.black
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )),
                  // log
                  Column(
                    children: [
                      //Description
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                '${(_pageLength! - 1)} chapters',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _coverCard() {
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: 65 * 1.5,
          height: 65 * 2.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.modelManga!.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titles() {
    return Positioned(
      top: 60,
      left: 30,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 100),
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.modelManga!.name!,
                style: const TextStyle(
                  fontSize: 18,
                )),
            widget.titleDescription!,
          ],
        ),
      ),
    );
  }

  Widget _actionConstructor() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.action!,
          const SizedBox(
            width: 5,
          ),
          SizedBox(
            width: mediaWidth(context, 0.4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0),
              onPressed: () {
                Map<String, String> data = {
                  'url': widget.modelManga!.link!,
                  'source': widget.modelManga!.source!,
                };
                context.push("/mangawebview", extra: data);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.public,
                    size: 22,
                    color: secondaryColor(context),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'WebView',
                    style:
                        TextStyle(fontSize: 13, color: secondaryColor(context)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
