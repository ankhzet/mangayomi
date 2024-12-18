import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/double_columm_view_center.dart';
import 'package:mangayomi/modules/manga/reader/double_columm_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/providers/crop_borders_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/custom_color_selector.dart';
import 'package:mangayomi/modules/manga/reader/widgets/custom_popup_menu_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_slider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/round_nav_button.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'package:window_manager/window_manager.dart';

typedef DoubleClickAnimationListener = void Function();

bool isLogicalKeyPressed(LogicalKeyboardKey key) => HardwareKeyboard.instance.isLogicalKeyPressed(key);

class MangaReaderView extends ConsumerWidget {
  final Chapter chapter;

  const MangaReaderView({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterData = ref.watch(getChapterPagesProvider(
      chapter: chapter,
    ));

    return chapterData.when(
      data: (data) {
        if (data.pageUrls.isEmpty && (chapter.manga.value!.isLocalArchive ?? false) == false) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text(''),
              leading: BackButton(
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
                  Navigator.pop(context);
                },
              ),
            ),
            body: const Center(
              child: Text("Error"),
            ),
          );
        }
        return MangaChapterPageGallery(chapter: chapter, chapterUrlModel: data);
      },
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(''),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Text(error.toString()),
        ),
      ),
      loading: () {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(''),
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: const ProgressCenter(),
        );
      },
    );
  }
}

class MangaChapterPageGallery extends ConsumerStatefulWidget {
  const MangaChapterPageGallery({
    super.key,
    required this.chapter,
    required this.chapterUrlModel,
  });

  final GetChapterPagesModel chapterUrlModel;

  final Chapter chapter;

  @override
  ConsumerState createState() {
    return _MangaChapterPageGalleryState();
  }
}

class _MangaChapterPageGalleryState extends ConsumerState<MangaChapterPageGallery> with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;
  late ReaderController _readerController = ref.read(readerControllerProvider(chapter: chapter).notifier);
  bool isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  @override
  void dispose() {
    _readerController.setMangaHistoryUpdate();
    _readerController.checkAndSyncProgress();
    _readerController.setPageIndex(_getCurrentIndex(_uChapDataPreload[_currentIndex!].index), true);
    _rebuildDetail.close();
    _doubleClickAnimationController.dispose();
    _autoScroll.value = false;
    clearGestureDetailsCache();
    if (isDesktop) {
      setFullScreen(value: false);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
    super.dispose();
  }

  late final _autoScroll = ValueNotifier(_readerController.getAutoScroll().$1);
  late final _autoScrollPage = ValueNotifier(_autoScroll.value);
  late GetChapterPagesModel _chapterUrlModel = widget.chapterUrlModel;

  late Chapter chapter = widget.chapter;

  List<UChapDataPreload> _uChapDataPreload = [];

  final _failedToLoadImage = ValueNotifier<bool>(false);

  late int? _currentIndex = _readerController.getPageIndex();

  late final ItemScrollController _itemScrollController = ItemScrollController();
  final ScrollOffsetController _pageOffsetController = ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  late AnimationController _doubleClickAnimationController;

  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  final StreamController<double> _rebuildDetail = StreamController<double>.broadcast();

  @override
  void initState() {
    _doubleClickAnimationController = AnimationController(duration: _doubleTapAnimationDuration(), vsync: this);
    _scaleAnimationController = AnimationController(duration: _doubleTapAnimationDuration(), vsync: this);
    _animation =
        Tween(begin: 1.0, end: 2.0).animate(CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController));
    _animation.addListener(() => _photoViewController.scale = _animation.value);
    _itemPositionsListener.itemPositions.addListener(_readProgressListener);
    _initCurrentIndex();

    super.initState();
  }

  final double _horizontalScaleValue = 1.0;

  late int pagePreloadAmount = ref.watch(pagePreloadAmountStateProvider);
  late bool _isBookmarked = _readerController.getChapterBookmarked();

  final _currentReaderMode = StateProvider<ReaderMode?>((ref) => null);
  PageMode? _pageMode;
  bool _isView = false;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController = PhotoViewScaleStateController();
  final List<int> _cropBorderCheckList = [];

  void _onScaleEnd(BuildContext context, ScaleEndDetails details, PhotoViewControllerValue controllerValue) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }

  late final _extendedController = ExtendedPageController(initialPage: _currentIndex!);

  double get pixelRatio => View.of(context).devicePixelRatio;

  Size get size => View.of(context).physicalSize / pixelRatio;

  Alignment _computeAlignmentByTapOffset(Offset offset) {
    return Alignment(
        (offset.dx - size.width / 2) / (size.width / 2), (offset.dy - size.height / 2) / (size.height / 2));
  }

  Axis _scrollDirection = Axis.vertical;
  bool _isReverseHorizontal = false;

  late final _showPagesNumber = StateProvider((ref) => _readerController.getShowPageNumber());

  Color _backgroundColor(BuildContext context) => Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9);

  void _setFullScreen({bool? value}) async {
    if (isDesktop) {
      value = await windowManager.isFullScreen();
      setFullScreen(value: !value);
    }
    ref.read(fullScreenReaderStateProvider.notifier).set(!value!);
  }

  void _onLongPressImageDialog(UChapDataPreload preload, BuildContext context) async {
    Widget button(String label, IconData icon, Function() onPressed) => Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, elevation: 0, shadowColor: Colors.transparent),
                onPressed: onPressed,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(icon),
                    ),
                    Text(label)
                  ],
                )),
          ),
        );
    final imageBytes = await preload.getImageBytes;
    if (imageBytes != null && context.mounted) {
      final name = "${widget.chapter.manga.value!.name} ${widget.chapter.name} - ${preload.pageIndex}"
          .replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_');
      showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: context.width(1),
        ),
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    color: context.themeData.scaffoldBackgroundColor),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 7,
                        width: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: context.secondaryColor.withValues(alpha: 0.4)),
                      ),
                    ),
                    Row(
                      children: [
                        button(context.l10n.set_as_cover, Icons.image_outlined, () async {
                          final res = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(context.l10n.use_this_as_cover_art),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(context.l10n.cancel)),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              final manga = widget.chapter.manga.value!;
                                              isar.writeTxnSync(() {
                                                isar.mangas.putSync(manga..customCoverImage = imageBytes);
                                              });
                                              if (mounted) {
                                                Navigator.pop(context, "ok");
                                              }
                                            },
                                            child: Text(context.l10n.ok)),
                                      ],
                                    )
                                  ],
                                );
                              });
                          if (res != null && res == "ok" && context.mounted) {
                            Navigator.pop(context);
                            botToast(context.l10n.cover_updated, second: 3);
                          }
                        }),
                        button(context.l10n.share, Icons.share_outlined, () async {
                          await Share.shareXFiles([XFile.fromData(imageBytes, name: name, mimeType: 'image/png')]);
                        }),
                        button(context.l10n.save, Icons.save_outlined, () async {
                          final dir = await StorageProvider.getGalleryDirectory();
                          final file = File(path.join(dir, "$name.png"));
                          file.writeAsBytesSync(imageBytes);

                          if (context.mounted) {
                            botToast(context.l10n.picture_saved, second: 3);
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final cropBorders = ref.watch(cropBordersStateProvider);
    final bool isHorizontalContinuous = ref.watch(_currentReaderMode) == ReaderMode.horizontalContinuous;
    if (cropBorders) {
      _processCropBorders();
    }
    final usePageTapZones = ref.watch(usePageTapZonesStateProvider);
    final l10n = l10nLocalizations(context)!;
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        final (prevChapter, nextChapter) = _readerController.getPrevNextChapter();

        // ignore: unused_local_variable
        final action = switch (event.logicalKey) {
          LogicalKeyboardKey.f11 => (!isLogicalKeyPressed(LogicalKeyboardKey.f11)) ? _setFullScreen() : null,
          LogicalKeyboardKey.escape => (!isLogicalKeyPressed(LogicalKeyboardKey.escape)) ? _goBack(context) : null,
          LogicalKeyboardKey.backspace =>
            (!isLogicalKeyPressed(LogicalKeyboardKey.backspace)) ? _goBack(context) : null,
          LogicalKeyboardKey.arrowUp =>
            (!isLogicalKeyPressed(LogicalKeyboardKey.arrowUp)) ? _onBtnTapped(_currentIndex! - 1, true) : null,
          LogicalKeyboardKey.arrowLeft => (!isLogicalKeyPressed(LogicalKeyboardKey.arrowLeft))
              ? _isReverseHorizontal
                  ? _onBtnTapped(_currentIndex! + 1, false)
                  : _onBtnTapped(_currentIndex! - 1, true)
              : null,
          LogicalKeyboardKey.arrowRight => (!isLogicalKeyPressed(LogicalKeyboardKey.arrowRight))
              ? _isReverseHorizontal
                  ? _onBtnTapped(_currentIndex! - 1, true)
                  : _onBtnTapped(_currentIndex! + 1, false)
              : null,
          LogicalKeyboardKey.arrowDown =>
            (!isLogicalKeyPressed(LogicalKeyboardKey.arrowDown)) ? _onBtnTapped(_currentIndex! + 1, true) : null,
          LogicalKeyboardKey.keyN ||
          LogicalKeyboardKey.pageDown =>
            ((!isLogicalKeyPressed(LogicalKeyboardKey.keyN) || !isLogicalKeyPressed(LogicalKeyboardKey.pageDown)) &&
                    nextChapter != null)
                ? pushReplacementMangaReaderView(
                    context: context,
                    chapter: _readerController.getNextChapter()!,
                  )
                : null,
          LogicalKeyboardKey.keyP ||
          LogicalKeyboardKey.pageUp =>
            ((!isLogicalKeyPressed(LogicalKeyboardKey.keyP) || !isLogicalKeyPressed(LogicalKeyboardKey.pageUp)) &&
                    prevChapter != null)
                ? pushReplacementMangaReaderView(context: context, chapter: _readerController.getPrevChapter()!)
                : null,
          _ => null
        };
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.idle) {
            if (_isView) {
              _isViewFunction();
            }
          }

          return true;
        },
        child: Material(
          child: SafeArea(
            top: !fullScreenReader,
            bottom: false,
            child: ValueListenableBuilder(
                valueListenable: _failedToLoadImage,
                builder: (context, failedToLoadImage, child) {
                  return Stack(
                    children: [
                      _isVerticalOrHorizontalContinuous()
                          ? PhotoViewGallery.builder(
                              itemCount: 1,
                              builder: (_, __) => PhotoViewGalleryPageOptions.customChild(
                                  controller: _photoViewController,
                                  scaleStateController: _photoViewScaleStateController,
                                  basePosition: _scalePosition,
                                  onScaleEnd: _onScaleEnd,
                                  child: ScrollablePositionedList.separated(
                                    scrollDirection: isHorizontalContinuous ? Axis.horizontal : Axis.vertical,
                                    minCacheExtent: pagePreloadAmount * context.height(1),
                                    initialScrollIndex: _readerController.getPageIndex(),
                                    itemCount: _readerController.snapIndex(_uChapDataPreload.length, grid: 1),
                                    physics: const ClampingScrollPhysics(),
                                    itemScrollController: _itemScrollController,
                                    scrollOffsetController: _pageOffsetController,
                                    itemPositionsListener: _itemPositionsListener,
                                    itemBuilder: (context, index) {
                                      int index1 = index * 2 - 1;
                                      int index2 = index1 + 1;
                                      return GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onDoubleTapDown: (details) {
                                          _toggleScale(details.globalPosition);
                                        },
                                        onDoubleTap: () {},
                                        child: _readerController.isGridMode()
                                            ? DoubleColummVerticalView(
                                                datas: index == 0
                                                    ? [_uChapDataPreload[0], null]
                                                    : [
                                                        index1 < _uChapDataPreload.length
                                                            ? _uChapDataPreload[index1]
                                                            : null,
                                                        index2 < _uChapDataPreload.length
                                                            ? _uChapDataPreload[index2]
                                                            : null,
                                                      ],
                                                backgroundColor: backgroundColor,
                                                isFailedToLoadImage: (val) {},
                                                onLongPressData: (datas) {
                                                  _onLongPressImageDialog(datas, context);
                                                },
                                              )
                                            : ImageViewVertical(
                                                data: _uChapDataPreload[index],
                                                failedToLoadImage: (value) {
                                                  // _failedToLoadImage.value = value;
                                                },
                                                onLongPressData: (datas) {
                                                  _onLongPressImageDialog(datas, context);
                                                },
                                                isHorizontal:
                                                    ref.watch(_currentReaderMode) == ReaderMode.horizontalContinuous,
                                              ),
                                      );
                                    },
                                    separatorBuilder: (_, __) => ref.watch(_currentReaderMode) == ReaderMode.webtoon
                                        ? const SizedBox.shrink()
                                        : ref.watch(_currentReaderMode) == ReaderMode.horizontalContinuous
                                            ? VerticalDivider(color: getBackgroundColor(backgroundColor), width: 6)
                                            : Divider(color: getBackgroundColor(backgroundColor), height: 6),
                                  )),
                            )
                          : Material(
                              color: getBackgroundColor(backgroundColor),
                              shadowColor: getBackgroundColor(backgroundColor),
                              child: _readerController.isGridMode()
                                  ? ExtendedImageGesturePageView.builder(
                                      controller: _extendedController,
                                      scrollDirection: _scrollDirection,
                                      reverse: _isReverseHorizontal,
                                      physics: const ClampingScrollPhysics(),
                                      canScrollPage: (_) {
                                        return _horizontalScaleValue == 1.0;
                                      },
                                      itemBuilder: (context, index) {
                                        int index1 = index * 2 - 1;
                                        int index2 = index1 + 1;
                                        final pageList = (index == 0
                                            ? [_uChapDataPreload[0], null]
                                            : [
                                                index1 < _uChapDataPreload.length ? _uChapDataPreload[index1] : null,
                                                index2 < _uChapDataPreload.length ? _uChapDataPreload[index2] : null,
                                              ]);
                                        return DoubleColummView(
                                          datas: _isReverseHorizontal ? pageList.reversed.toList() : pageList,
                                          backgroundColor: backgroundColor,
                                          isFailedToLoadImage: (val) {
                                            if (_failedToLoadImage.value != val && mounted) {
                                              _failedToLoadImage.value = val;
                                            }
                                          },
                                          onLongPressData: (datas) {
                                            _onLongPressImageDialog(datas, context);
                                          },
                                        );
                                      },
                                      itemCount: _readerController.snapIndex(_uChapDataPreload.length, grid: 1),
                                      onPageChanged: _onPageChanged)
                                  : ExtendedImageGesturePageView.builder(
                                      controller: _extendedController,
                                      scrollDirection: _scrollDirection,
                                      reverse: _isReverseHorizontal,
                                      physics: const ClampingScrollPhysics(),
                                      canScrollPage: (gestureDetails) {
                                        return gestureDetails != null ? !(gestureDetails.totalScale! > 1.0) : true;
                                      },
                                      itemBuilder: (BuildContext context, int index) {
                                        return ImageViewPaged(
                                          data: _uChapDataPreload[index],
                                          loadStateChanged: (state) {
                                            if (state.extendedImageLoadState == LoadState.loading) {
                                              final ImageChunkEvent? loadingProgress = state.loadingProgress;
                                              final double progress = loadingProgress?.expectedTotalBytes != null
                                                  ? loadingProgress!.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : 0;
                                              return Container(
                                                color: getBackgroundColor(backgroundColor),
                                                height: context.height(0.8),
                                                child: CircularProgressIndicatorAnimateRotate(progress: progress),
                                              );
                                            }
                                            if (state.extendedImageLoadState == LoadState.completed) {
                                              if (_failedToLoadImage.value == true) {
                                                Future.delayed(const Duration(milliseconds: 10))
                                                    .then((value) => _failedToLoadImage.value = false);
                                              }
                                              return ExtendedImageGesture(
                                                state,
                                                canScaleImage: (_) => true,
                                                imageBuilder: (Widget image,
                                                    {ExtendedImageGestureState? imageGestureState}) {
                                                  return image;
                                                },
                                              );
                                            }
                                            if (state.extendedImageLoadState == LoadState.failed) {
                                              if (_failedToLoadImage.value == false) {
                                                Future.delayed(const Duration(milliseconds: 10))
                                                    .then((value) => _failedToLoadImage.value = true);
                                              }
                                              return Container(
                                                  color: getBackgroundColor(backgroundColor),
                                                  height: context.height(0.8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        l10n.image_loading_error,
                                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: GestureDetector(
                                                            onLongPress: () {
                                                              state.reLoadImage();
                                                              _failedToLoadImage.value = false;
                                                            },
                                                            onTap: () {
                                                              state.reLoadImage();
                                                              _failedToLoadImage.value = false;
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: context.primaryColor,
                                                                  borderRadius: BorderRadius.circular(30)),
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    vertical: 8, horizontal: 16),
                                                                child: Text(
                                                                  l10n.retry,
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ));
                                            }
                                            return const SizedBox.shrink();
                                          },
                                          initGestureConfigHandler: (state) {
                                            return GestureConfig(
                                              inertialSpeed: 200,
                                              inPageView: true,
                                              maxScale: 8,
                                              animationMaxScale: 8,
                                              cacheGesture: true,
                                              hitTestBehavior: HitTestBehavior.translucent,
                                            );
                                          },
                                          onDoubleTap: (state) {
                                            final Offset? pointerDownPosition = state.pointerDownPosition;
                                            final double? begin = state.gestureDetails!.totalScale;
                                            double end;

                                            //remove old
                                            _doubleClickAnimation?.removeListener(_doubleClickAnimationListener);

                                            //stop pre
                                            _doubleClickAnimationController.stop();

                                            //reset to use
                                            _doubleClickAnimationController.reset();

                                            if (begin == doubleTapScales[0]) {
                                              end = doubleTapScales[1];
                                            } else {
                                              end = doubleTapScales[0];
                                            }

                                            _doubleClickAnimationListener = () {
                                              state.handleDoubleTap(
                                                  scale: _doubleClickAnimation!.value,
                                                  doubleTapPosition: pointerDownPosition);
                                            };

                                            _doubleClickAnimation = Tween(begin: begin, end: end).animate(
                                                CurvedAnimation(
                                                    curve: Curves.ease, parent: _doubleClickAnimationController));

                                            _doubleClickAnimation!.addListener(_doubleClickAnimationListener);

                                            _doubleClickAnimationController.forward();
                                          },
                                          onLongPressData: (datas) {
                                            _onLongPressImageDialog(datas, context);
                                          },
                                        );
                                      },
                                      itemCount: _uChapDataPreload.length,
                                      onPageChanged: _onPageChanged)),
                      _gestureRightLeft(failedToLoadImage, usePageTapZones),
                      _gestureTopBottom(failedToLoadImage, usePageTapZones),
                      _appBar(),
                      _bottomBar(),
                      _showPage(),
                      _autoScrollPlayPauseBtn()
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<void> _precacheImages(int index) async {
    try {
      if (index >= 0 && index < _uChapDataPreload.length) {
        await precacheImage(_uChapDataPreload[index].getImageProvider(ref, false), context);
      }
    } catch (_) {}
  }

  Duration? _doubleTapAnimationDuration() {
    int doubleTapAnimationValue = isar.settings.first.doubleTapAnimationSpeed!;
    if (doubleTapAnimationValue == 0) {
      return const Duration(milliseconds: 10);
    } else if (doubleTapAnimationValue == 1) {
      return const Duration(milliseconds: 800);
    }
    return const Duration(milliseconds: 200);
  }

  void _readProgressListener() {
    final positions = _itemPositionsListener.itemPositions.value;
    _currentIndex = positions.first.index;

    int pagesLength = _readerController.snapIndex(_uChapDataPreload.length, grid: 1);

    if (!(_currentIndex! >= 0 && _currentIndex! < pagesLength)) {
      return;
    }

    final current = _uChapDataPreload[_currentIndex!];

    if (_readerController.chapter.id != current.chapter.id) {
      _readerController.setPageIndex(_getPrevIndex(current.pageIndex), false);

      if (mounted) {
        setState(() {
          chapter = current.chapter;
          _chapterUrlModel = current.chapterUrlModel!;
          _readerController = ref.read(readerControllerProvider(chapter: chapter).notifier);
          _isBookmarked = _readerController.getChapterBookmarked();
        });
      }
    }

    if (positions.last.index == pagesLength - 1) {
      final next = _readerController.getNextChapter();

      if (next != null) {
        ref.watch(getChapterPagesProvider(chapter: next).future).then((value) => _preloadNextChapter(value, chapter));
      }
    }

    ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(current.index);
  }

  void _preloadNextChapter(GetChapterPagesModel chapterData, Chapter chap) {
    try {
      int length = 0;
      bool isExist = false;
      List<UChapDataPreload> uChapDataPreloadP = [];
      List<UChapDataPreload> uChapDataPreloadL = _uChapDataPreload;
      List<UChapDataPreload> preChap = [];
      final uIsNotEmpty = chapterData.uChapDataPreload.first.chapter.url!.isNotEmpty;
      final aIsNotEmpty = chapterData.uChapDataPreload.first.chapter.archivePath!.isNotEmpty;

      for (var chp in _uChapDataPreload) {
        final cuIsNotEmpty = chp.chapter.url!.isNotEmpty;
        final caIsNotEmpty = chp.chapter.archivePath!.isNotEmpty;
        if (uIsNotEmpty && cuIsNotEmpty && chapterData.uChapDataPreload.first.chapter.url == chp.chapter.url ||
            aIsNotEmpty &&
                caIsNotEmpty &&
                chapterData.uChapDataPreload.first.chapter.archivePath == chp.chapter.archivePath) {
          isExist = true;
        }
      }
      if (!isExist) {
        for (var ch in chapterData.uChapDataPreload) {
          preChap.add(ch);
        }
      }

      if (preChap.isNotEmpty) {
        length = _uChapDataPreload.length;
        for (var i = 0; i < preChap.length; i++) {
          int index = i + length;
          final dataPreload = preChap[i];
          uChapDataPreloadP.add(dataPreload..pageIndex = index);
        }
        if (mounted) {
          uChapDataPreloadL.addAll(uChapDataPreloadP);
          if (mounted) {
            setState(() {
              _uChapDataPreload = uChapDataPreloadL;
            });
          }
        }
      }
    } catch (_) {}
  }

  void _initCurrentIndex() async {
    final readerMode = _readerController.getReaderMode();
    _uChapDataPreload.addAll(_chapterUrlModel.uChapDataPreload);
    _readerController.setMangaHistoryUpdate();
    await Future.delayed(const Duration(milliseconds: 1));
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    if (fullScreenReader) {
      if (isDesktop) {
        setFullScreen(value: true);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
    ref.read(_currentReaderMode.notifier).state = readerMode;
    if (mounted) {
      setState(() {
        _pageMode = _readerController.getPageMode();
      });
    }
    _setReaderMode(readerMode, ref);
    ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(_uChapDataPreload[_currentIndex!].index);

    if (!_isVerticalOrHorizontalContinuous()) {
      for (var i = 1; i < pagePreloadAmount + 1; i++) {
        _precacheImages(_currentIndex! + i);
        _precacheImages(_currentIndex! - i);
      }
    }
    if (readerMode != ReaderMode.verticalContinuous && readerMode != ReaderMode.webtoon) {
      _autoScroll.value = false;
    }
    _autoPageScroll();
    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (readerMode == ReaderMode.ltr || readerMode == ReaderMode.rtl || readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
  }

  void _onPageChanged(int index) {
    final preload = _uChapDataPreload[index];
    final current = _uChapDataPreload[_currentIndex!];
    final cropBorders = ref.watch(cropBordersStateProvider);
    if (cropBorders) {
      _processCropBordersByIndex(index);
    }
    for (var i = 1; i < pagePreloadAmount + 1; i++) {
      _precacheImages(index + i);
      _precacheImages(index - i);
    }

    if (_readerController.chapter.id != preload.chapter.id) {
      _readerController.setPageIndex(_getCurrentIndex(current.index), false);
      if (mounted) {
        setState(() {
          chapter = current.chapter;
          _readerController = ref.read(readerControllerProvider(chapter: chapter).notifier);
          _chapterUrlModel = preload.chapterUrlModel!;
          _isBookmarked = _readerController.getChapterBookmarked();
        });
      }
    }
    _currentIndex = index;

    ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(preload.index);

    if (preload.pageIndex == _uChapDataPreload.length - 1) {
      final next = _readerController.getNextChapter();

      if (next != null) {
        ref.watch(getChapterPagesProvider(chapter: next).future).then((value) => _preloadNextChapter(value, chapter));
      }
    }
  }

  late final _pageOffset = ValueNotifier(_readerController.getAutoScroll().$2);

  void _autoPageScroll() async {
    if (!_isVerticalOrHorizontalContinuous()) {
      return;
    }

    for (int i = 0; i < 1; i++) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!_autoScroll.value) {
        return;
      }

      _pageOffsetController.animateScroll(offset: _pageOffset.value, duration: const Duration(milliseconds: 100));
    }

    _autoPageScroll();
  }

  void _onBtnTapped(int index, bool isPrev, {bool isSlide = false}) {
    if (_isView && !isSlide) {
      _isViewFunction();
    }

    final animatePageTransitions = ref.read(animatePageTransitionsStateProvider);
    final isContinuousMode = _isVerticalOrHorizontalContinuous();

    if ((isPrev && index == -1) || !(isContinuousMode || _extendedController.hasClients)) {
      return;
    }

    if (animatePageTransitions && !isSlide) {
      if (isContinuousMode) {
        _itemScrollController.scrollTo(curve: Curves.ease, index: index, duration: const Duration(milliseconds: 150));
      } else {
        _extendedController.animateToPage(index, duration: const Duration(milliseconds: 150), curve: Curves.ease);
      }
    } else if (isContinuousMode || (isSlide && !isPrev)) {
      _itemScrollController.jumpTo(index: index);
    } else {
      _extendedController.jumpToPage(index);
    }
  }

  void _toggleScale(Offset tapPosition) {
    if (mounted) {
      setState(() {
        if (_scaleAnimationController.isAnimating) {
          return;
        }

        if (_photoViewController.scale == 1.0) {
          _scalePosition = _computeAlignmentByTapOffset(tapPosition);

          if (_scaleAnimationController.isCompleted) {
            _scaleAnimationController.reset();
          }

          _scaleAnimationController.forward();
          return;
        }

        if (_photoViewController.scale == 2.0) {
          _scaleAnimationController.reverse();
          return;
        }

        _photoViewScaleStateController.reset();
      });
    }
  }

  void _setReaderMode(ReaderMode value, WidgetRef ref) async {
    if (value != ReaderMode.verticalContinuous && value != ReaderMode.webtoon) {
      _autoScroll.value = false;
    } else {
      if (_autoScrollPage.value) {
        _autoPageScroll();
        _autoScroll.value = true;
      }
    }

    _failedToLoadImage.value = false;
    _readerController.setReaderMode(value);

    int index = _readerController.snapIndex(_currentIndex!);
    ref.read(_currentReaderMode.notifier).state = value;

    if (value == ReaderMode.vertical) {
      if (mounted) {
        setState(() {
          _scrollDirection = Axis.vertical;
          _isReverseHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(index);
      }
    } else if (value == ReaderMode.ltr || value == ReaderMode.rtl) {
      if (mounted) {
        setState(() {
          if (value == ReaderMode.rtl) {
            _isReverseHorizontal = true;
          } else {
            _isReverseHorizontal = false;
          }

          _scrollDirection = Axis.horizontal;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(index);
      }
    } else {
      if (mounted) {
        setState(() {
          _isReverseHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));
        _itemScrollController.scrollTo(index: index, duration: const Duration(milliseconds: 1), curve: Curves.ease);
      }
    }
  }

  void _processCropBordersByIndex(int index) async {
    if (!_cropBorderCheckList.contains(index)) {
      _cropBorderCheckList.add(index);
      ref.watch(cropBordersProvider(data: _uChapDataPreload[index], cropBorder: true).future).then((value) {
        _uChapDataPreload[index] = _uChapDataPreload[index]..cropImage = value;
      });
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _processCropBorders() async {
    for (var i = 0; i < _uChapDataPreload.length; i++) {
      if (!_cropBorderCheckList.contains(i)) {
        _cropBorderCheckList.add(i);
        ref.watch(cropBordersProvider(data: _uChapDataPreload[i], cropBorder: true).future).then((value) {
          _uChapDataPreload[i] = _uChapDataPreload[i]..cropImage = value;
          if (mounted) {
            setState(() {});
          }
        });
      }
    }
  }

  void _goBack(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    Navigator.pop(context);
  }

  Widget _appBar() {
    if (!_isView && Platform.isIOS) {
      return const SizedBox.shrink();
    }
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    double height = _isView
        ? Platform.isIOS
            ? 120
            : !fullScreenReader && !isDesktop
                ? 55
                : 80
        : 0;
    return Positioned(
      top: 0,
      child: AnimatedContainer(
        width: context.width(1),
        height: height,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 200),
        child: PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: ListTile(
              dense: true,
              title: SizedBox(
                width: context.width(0.8),
                child: Text(
                  '${_readerController.getMangaName()} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: SizedBox(
                width: context.width(0.8),
                child: Text(
                  _readerController.getChapterTitle(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            actions: [
              btnToShowChapterListDialog(context, context.l10n.chapters, widget.chapter),
              IconButton(
                  onPressed: () {
                    _readerController.setChapterBookmarked();
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                  },
                  icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined)),
              if ((chapter.manga.value!.isLocalArchive ?? false) == false)
                IconButton(
                    onPressed: () async {
                      final manga = chapter.manga.value!;
                      final source = getSource(manga.lang!, manga.source!)!;
                      String url = chapter.url!.startsWith('/') ? "${source.baseUrl}/${chapter.url!}" : chapter.url!;
                      Map<String, dynamic> data = {
                        'url': url,
                        'sourceId': source.id.toString(),
                        'title': chapter.name!
                      };
                      context.push("/mangawebview", extra: data);
                    },
                    icon: const Icon(Icons.public)),
            ],
            backgroundColor: _backgroundColor(context),
          ),
        ),
      ),
    );
  }

  Widget _autoScrollPlayPauseBtn() {
    return _isVerticalOrHorizontalContinuous()
        ? Positioned(
            bottom: 0,
            right: 0,
            child: !_isView
                ? ValueListenableBuilder(
                    valueListenable: _autoScrollPage,
                    builder: (context, valueT, child) => valueT
                        ? ValueListenableBuilder(
                            valueListenable: _autoScroll,
                            builder: (context, value, child) => IconButton(
                                onPressed: () {
                                  _autoPageScroll();
                                  _autoScroll.value = !value;
                                },
                                icon: Icon(value ? Icons.pause_circle : Icons.play_circle)),
                          )
                        : const SizedBox.shrink(),
                  )
                : const SizedBox.shrink())
        : const SizedBox.shrink();
  }

  Widget _bottomBar() {
    if (!_isView && Platform.isIOS) {
      return const SizedBox.shrink();
    }

    final (prevChapter, nextChapter) = _readerController.getPrevNextChapter();

    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
        width: context.width(1),
        height: (_isView ? 130 : 0),
        child: Column(
          children: [
            Flexible(
              child: Transform.scale(
                scaleX: !_isReverseHorizontal ? 1 : -1,
                child: Row(
                  children: [
                    RoundNavButton(
                      backgroundColor: _backgroundColor(context),
                      icon: Icons.skip_previous_rounded,
                      onPressed: prevChapter != null
                          ? () => pushReplacementMangaReaderView(context: context, chapter: prevChapter)
                          : null,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Consumer(builder: (context, ref, child) {
                          final pages = _readerController.getPageLength(_chapterUrlModel.pageUrls);
                          final provider = currentIndexProvider(chapter);
                          final currentIndex = ref.watch(provider);

                          return PageSlider(
                            pages: pages,
                            currentIndex: currentIndex,
                            divisions: _readerController.snapIndex(pages, grid: 1, list: -1),
                            backgroundColor: _backgroundColor(context),
                            indexToLabel: _indexLabel,
                            mirror: _isReverseHorizontal,
                            active: _isView,
                            onChange: (index) {
                              ref.read(provider.notifier).setCurrentIndex(index);
                            },
                            onApply: (index) {
                              _onBtnTapped(
                                _uChapDataPreload
                                    .firstWhere((element) => element.chapter == chapter && element.index == index)
                                    .pageIndex,
                                true,
                                isSlide: true,
                              );
                            },
                          );
                        }),
                      ),
                    ),
                    RoundNavButton(
                      backgroundColor: _backgroundColor(context),
                      icon: Icons.skip_next_rounded,
                      onPressed: nextChapter != null
                          ? () => pushReplacementMangaReaderView(context: context, chapter: nextChapter)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: 65,
                color: _backgroundColor(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PopupMenuButton(
                      popUpAnimationStyle: popupAnimationStyle,
                      color: Colors.black,
                      child: const Icon(
                        Icons.app_settings_alt_outlined,
                      ),
                      onSelected: (value) {
                        ref.read(_currentReaderMode.notifier).state = value;
                        _setReaderMode(value, ref);
                      },
                      itemBuilder: (context) => [
                        for (var mode in ReaderMode.values)
                          PopupMenuItem(
                              value: mode,
                              child: Row(
                                children: [
                                  Consumer(
                                      builder: (context, ref, _) => Icon(Icons.check,
                                          color: ref.watch(_currentReaderMode) == mode
                                              ? Colors.white
                                              : Colors.transparent)),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    getReaderModeName(mode, context),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )),
                      ],
                    ),
                    Consumer(builder: (context, ref, child) {
                      final cropBorders = ref.watch(cropBordersStateProvider);
                      return IconButton(
                        onPressed: () {
                          ref.read(cropBordersStateProvider.notifier).set(!cropBorders);
                        },
                        icon: Stack(
                          children: [
                            const Icon(
                              Icons.crop_rounded,
                            ),
                            if (!cropBorders)
                              Positioned(
                                right: 8,
                                child: Transform.scale(
                                  scaleX: 2.5,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\\',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    Consumer(builder: (context, ref, _) {
                      final readerMode = ref.watch(_currentReaderMode);
                      bool isOnePage = _pageMode == PageMode.onePage;

                      return IconButton(
                        onPressed: readerMode == ReaderMode.horizontalContinuous
                            ? null
                            : () {
                                PageMode newPageMode = isOnePage ? PageMode.doublePage : PageMode.onePage;

                                _onBtnTapped(
                                  _readerController.snapIndex(_getCurrentIndex(_uChapDataPreload[_currentIndex!].index)),
                                  true,
                                  isSlide: true,
                                );

                                _readerController.setPageMode(newPageMode);

                                if (mounted) {
                                  setState(() {
                                    _pageMode = newPageMode;
                                  });
                                }
                              },
                        icon: Icon(
                          isOnePage ? CupertinoIcons.book : CupertinoIcons.book_solid,
                        ),
                      );
                    }),
                    IconButton(
                      onPressed: () {
                        _showModalSettings();
                      },
                      icon: const Icon(
                        Icons.settings_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showPage() {
    return Consumer(builder: (context, ref, child) {
      final currentIndex = ref.watch(currentIndexProvider(chapter));
      return _isView
          ? const SizedBox.shrink()
          : ref.watch(_showPagesNumber)
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    '${_indexLabel(currentIndex)} / ${_readerController.getPageLength(_chapterUrlModel.pageUrls)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      shadows: [
                        Shadow(offset: Offset(-1, -1), blurRadius: 1),
                        Shadow(offset: Offset(1, -1), blurRadius: 1),
                        Shadow(offset: Offset(1, 1), blurRadius: 1),
                        Shadow(offset: Offset(-1, 1), blurRadius: 1)
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ))
              : const SizedBox.shrink();
    });
  }

  void _isViewFunction() {
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    if (mounted) {
      setState(() {
        _isView = !_isView;
      });
    }
    if (fullScreenReader) {
      if (_isView) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
  }

  String _indexLabel(int index) {
    if (_pageMode != PageMode.doublePage) {
      return "${index + 1}";
    }

    if (index == 0) {
      return "1";
    }

    int pageLength = _readerController.getPageLength(_chapterUrlModel.pageUrls);
    int index1 = index * 2;
    int index2 = index1 + 1;

    return !(index1 < pageLength) ? "$pageLength" : "$index1-$index2";
  }

  int _getCurrentIndex(int index) {
    if (_pageMode != PageMode.doublePage || index == 0) {
      return index;
    }

    int pageLength = _readerController.getPageLength(_chapterUrlModel.pageUrls);
    int index1 = index * 2;

    return !(index * 2 < pageLength) ? pageLength - 1 : index1 - 1;
  }

  int _getPrevIndex(int index) {
    return _getCurrentIndex(_uChapDataPreload[index - 1].index);
  }

  Widget _gestureRightLeft(bool failedToLoadImage, bool usePageTapZones) {
    return Consumer(
      builder: (context, ref, child) {
        final handleScale =
            _isVerticalOrHorizontalContinuous() ? (details) => _toggleScale(details.globalPosition) : null;
        void Function() handleGo(int amount) => usePageTapZones
            ? () {
                _onBtnTapped(
                  _currentIndex! + (_isReverseHorizontal ? -1 : 1) * amount,
                  !_isReverseHorizontal,
                );
              }
            : _isViewFunction;

        return Row(
          children: [
            /// left region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: handleGo(-1),
                onDoubleTapDown: handleScale,
                onSecondaryTapDown: handleScale,
              ),
            ),

            /// center region
            Expanded(
              flex: 2,
              child: failedToLoadImage
                  ? SizedBox(
                      width: context.width(1),
                      height: context.height(0.7),
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _isViewFunction,
                      onDoubleTapDown: handleScale,
                      onSecondaryTapDown: handleScale,
                    ),
            ),

            /// right region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: handleGo(1),
                onDoubleTapDown: handleScale,
                onSecondaryTapDown: handleScale,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _gestureTopBottom(bool failedToLoadImage, bool usePageTapZones) {
    return Consumer(
      builder: (context, ref, child) {
        final handleScale =
            _isVerticalOrHorizontalContinuous() ? (details) => _toggleScale(details.globalPosition) : null;
        void Function() handleGo(int amount) => (usePageTapZones && !failedToLoadImage)
            ? () => _onBtnTapped(_currentIndex! + amount, true)
            : _isViewFunction;

        return Column(
          children: [
            /// top region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: handleGo(-1),
                onDoubleTapDown: handleScale,
                onSecondaryTapDown: handleScale,
              ),
            ),

            /// center region
            const Expanded(flex: 5, child: SizedBox.shrink()),

            /// bottom region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: handleGo(1),
                onDoubleTapDown: handleScale,
                onSecondaryTapDown: handleScale,
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isVerticalOrHorizontalContinuous() {
    final readerMode = ref.watch(_currentReaderMode);

    return readerMode == ReaderMode.webtoon ||
        readerMode == ReaderMode.verticalContinuous ||
        readerMode == ReaderMode.horizontalContinuous;
  }

  void _showModalSettings() async {
    _autoScroll.value = false;
    final l10n = l10nLocalizations(context)!;
    await customDraggableTabBar(
      tabs: [
        Tab(text: l10n.reading_mode),
        Tab(text: l10n.general),
        Tab(text: l10n.custom_filter),
      ],
      children: [
        Consumer(builder: (context, ref, chil) {
          final readerMode = ref.watch(_currentReaderMode);
          final usePageTapZones = ref.watch(usePageTapZonesStateProvider);
          final cropBorders = ref.watch(cropBordersStateProvider);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CustomPopupMenuButton<ReaderMode>(
                    label: l10n.reading_mode,
                    title: getReaderModeName(readerMode!, context),
                    onSelected: (value) {
                      ref.read(_currentReaderMode.notifier).state = value;
                      _setReaderMode(value, ref);
                    },
                    value: readerMode,
                    list: ReaderMode.values,
                    itemText: (mode) {
                      return getReaderModeName(mode, context);
                    },
                  ),
                  SwitchListTile(
                      value: cropBorders,
                      title: Text(
                        l10n.crop_borders,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.9), fontSize: 14),
                      ),
                      onChanged: (value) {
                        ref.read(cropBordersStateProvider.notifier).set(value);
                      }),
                  SwitchListTile(
                      value: usePageTapZones,
                      title: Text(l10n.use_page_tap_zones,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                            fontSize: 14,
                          )),
                      onChanged: (value) {
                        ref.read(usePageTapZonesStateProvider.notifier).set(value);
                      }),
                  if (readerMode == ReaderMode.verticalContinuous ||
                      readerMode == ReaderMode.webtoon ||
                      readerMode == ReaderMode.horizontalContinuous)
                    ValueListenableBuilder(
                      valueListenable: _autoScrollPage,
                      builder: (context, valueT, child) {
                        return Column(
                          children: [
                            SwitchListTile(
                                secondary: Icon(valueT ? Icons.timer : Icons.timer_outlined),
                                value: valueT,
                                title: Text(context.l10n.auto_scroll,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                                        fontSize: 14)),
                                onChanged: (val) {
                                  _readerController.setAutoScroll(val, _pageOffset.value);
                                  _autoScrollPage.value = val;
                                  _autoScroll.value = val;
                                }),
                            if (valueT)
                              ValueListenableBuilder(
                                valueListenable: _pageOffset,
                                builder: (context, value, child) => Slider(
                                    min: 2.0,
                                    max: 30.0,
                                    divisions: max(28, 3),
                                    value: value,
                                    onChanged: (val) {
                                      _pageOffset.value = val;
                                    },
                                    onChangeEnd: (val) {
                                      _readerController.setAutoScroll(valueT, val);
                                    }),
                              ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        }),
        Consumer(builder: (context, ref, chil) {
          final showPageNumber = ref.watch(_showPagesNumber);
          final animatePageTransitions = ref.watch(animatePageTransitionsStateProvider);
          final scaleType = ref.watch(scaleTypeStateProvider);
          final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
          final backgroundColor = ref.watch(backgroundColorStateProvider);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomPopupMenuButton<BackgroundColor>(
                    label: l10n.background_color,
                    title: getBackgroundColorName(backgroundColor, context),
                    onSelected: (value) {
                      ref.read(backgroundColorStateProvider.notifier).set(value);
                    },
                    value: backgroundColor,
                    list: BackgroundColor.values,
                    itemText: (color) {
                      return getBackgroundColorName(color, context);
                    },
                  ),
                  CustomPopupMenuButton<ScaleType>(
                    label: l10n.scale_type,
                    title: getScaleTypeNames(context)[scaleType.index],
                    onSelected: (value) {
                      ref.read(scaleTypeStateProvider.notifier).set(ScaleType.values[value.index]);
                    },
                    value: scaleType,
                    list: ScaleType.values.where((scale) {
                      try {
                        return getScaleTypeNames(context).contains(getScaleTypeNames(context)[scale.index]);
                      } catch (_) {
                        return false;
                      }
                    }).toList(),
                    itemText: (scale) => getScaleTypeNames(context)[scale.index],
                  ),
                  SwitchListTile(
                      value: fullScreenReader,
                      title: Text(
                        l10n.fullscreen,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.9), fontSize: 14),
                      ),
                      onChanged: (value) {
                        _setFullScreen(value: value);
                      }),
                  SwitchListTile(
                      value: showPageNumber,
                      title: Text(
                        l10n.show_page_number,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(_showPagesNumber.notifier).state = value;
                        _readerController.setShowPageNumber(value);
                      }),
                  SwitchListTile(
                      value: animatePageTransitions,
                      title: Text(
                        l10n.animate_page_transitions,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      onChanged: (value) {
                        ref.read(animatePageTransitionsStateProvider.notifier).set(value);
                      }),
                ],
              ),
            ),
          );
        }),
        const CustomColorSelector(),
      ],
      context: context,
      vsync: this,
      fullWidth: true,
    );

    if (_autoScrollPage.value) {
      _autoPageScroll();
      _autoScroll.value = true;
    }
  }
}

class UChapDataPreload {
  Chapter chapter;
  String directory;
  PageUrl? pageUrl;
  bool isLocal;
  Uint8List? archiveImage;
  int index;
  GetChapterPagesModel? chapterUrlModel;
  int pageIndex;
  Uint8List? cropImage;

  UChapDataPreload(
    this.chapter,
    this.directory,
    this.pageUrl,
    this.isLocal,
    this.archiveImage,
    this.index,
    this.chapterUrlModel,
    this.pageIndex, {
    this.cropImage,
  });

  File get preloadFile => file(directory, index);

  static String filename(int index) => '${padIndex(index + 1)}.jpg';

  static File file(String path, int index) => File('$path${filename(index)}');
}
