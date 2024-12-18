import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/manga.dart';
import 'package:mangayomi/utils/extensions/settings.dart';
import 'package:mangayomi/utils/extensions/update.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reader_controller_provider.g.dart';

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build(Chapter chapter) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (incognitoMode) return 0;
    return ref.read(readerControllerProvider(chapter: chapter).notifier).getPageIndex();
  }

  setCurrentIndex(int currentIndex) {
    state = currentIndex;
  }
}

BoxFit getBoxFit(ScaleType scaleType) {
  return switch (scaleType) {
    ScaleType.fitHeight => BoxFit.fitHeight,
    ScaleType.fitWidth => BoxFit.fitWidth,
    ScaleType.fitScreen => BoxFit.contain,
    ScaleType.originalSize => BoxFit.cover,
    ScaleType.smartFit => BoxFit.contain,
    _ => BoxFit.cover
  };
}

typedef ChapterCacheIndex = (int, bool);

@riverpod
class ReaderController extends _$ReaderController with WithSettings {
  @override
  void build({required Chapter chapter}) {}

  late final manga = chapter.manga.value!;
  late final mangaId = manga.id;
  late final mangaFilteredChapters = manga.getFilteredChapterList(settings: settings);
  late final mangaChapters = manga.chapters.toList(growable: false);
  late final incognitoMode = settings.incognitoMode!;

  (bool, double) getAutoScroll() {
    final option = manga.getOption(settings.autoScrollPages);

    return (
      option?.autoScroll ?? false,
      option?.pageOffset ?? 10,
    );
  }

  void setAutoScroll(bool value, double offset) {
    settings = settings
      ..autoScrollPages = [
        ...manga.getOtherOptions(settings.autoScrollPages),
        AutoScrollPages()
          ..mangaId = mangaId
          ..pageOffset = offset
          ..autoScroll = value,
      ];
  }

  ReaderMode getReaderMode() {
    return manga.getOption(settings.personalReaderModeList)?.readerMode ?? settings.defaultReaderMode;
  }

  void setReaderMode(ReaderMode newReaderMode) {
    settings = settings
      ..personalReaderModeList = [
        ...manga.getOtherOptions(settings.personalReaderModeList),
        PersonalReaderMode()
          ..mangaId = mangaId
          ..readerMode = newReaderMode,
      ];
  }

  PageMode getPageMode() {
    return manga.getOption(settings.personalPageModeList)?.pageMode ?? PageMode.onePage;
  }

  void setPageMode(PageMode newPageMode) {
    settings = settings
      ..personalPageModeList = [
        ...manga.getOtherOptions(settings.personalPageModeList),
        PersonalPageMode()
          ..mangaId = mangaId
          ..pageMode = newPageMode,
      ];
  }

  void setShowPageNumber(bool value) {
    if (!incognitoMode) {
      settings = settings..showPagesNumber = value;
    }
  }

  bool getShowPageNumber() {
    return incognitoMode ? true : settings.showPagesNumber!;
  }

  void setMangaHistoryUpdate() {
    if (incognitoMode) return;

    final lastRead = DateTime.now().millisecondsSinceEpoch;

    isar.writeTxnSync(() {
      isar.mangas.putSync(
        manga..lastRead = lastRead,
      );
    });

    History history = (isar.historys.filter().mangaIdEqualTo(mangaId).findFirstSync() ??
        History(
          mangaId: mangaId,
          date: lastRead.toString(),
          isManga: manga.isManga,
          chapterId: chapter.id,
        ))
      ..date = lastRead.toString()
      ..chapterId = chapter.id
      ..chapter.value = chapter;

    isar.writeTxnSync(() {
      isar.historys.putSync(history);
      history.chapter.saveSync();
    });
  }

  void checkAndSyncProgress() {
    final syncAfterReading = ref.watch(syncAfterReadingStateProvider);

    if (syncAfterReading) {
      ref.read(syncServerProvider(syncId: 1).notifier).checkForSync(true);
    }
  }

  void setChapterBookmarked() {
    if (incognitoMode) return;

    final isBookmarked = getChapterBookmarked();

    isar.writeTxnSync(() {
      chapter.isBookmarked = !isBookmarked;
      ref.read(changedItemsManagerProvider(managerId: 1).notifier).addUpdatedChapter(chapter, false, false);
      isar.chapters.putSync(chapter);
    });
  }

  bool getChapterBookmarked() {
    return isar.chapters.getSync(chapter.id!)!.isBookmarked!;
  }

  ChapterCacheIndex getChapterIndex() {
    final id = chapter.id;
    int index = 0;

    for (var chapter in mangaFilteredChapters) {
      if (id == chapter.id) {
        return (index, true);
      }

      index++;
    }

    index = 0;

    for (var chapter in mangaChapters) {
      if (id == chapter.id) {
        break;
      }

      index++;
    }

    return (index, false);
  }

  ChapterCacheIndex getPrevChapterIndex((int, bool) index) {
    int at = index.$1;
    final list = index.$2 ? mangaFilteredChapters : mangaChapters;
    final current = list[at];
    final last = list.length - 1;

    while (++at <= last) {
      final chapter = list[at];

      if (!chapter.isSameNumber(current)) {
        break;
      }
    }

    return (
      at,
      index.$2,
    );
  }

  ChapterCacheIndex getNextChapterIndex((int, bool) index) {
    int at = index.$1;
    final list = index.$2 ? mangaFilteredChapters : mangaChapters;
    final current = list[at];

    while (--at >= 0) {
      final chapter = list[at];

      if (!chapter.isSameNumber(current)) {
        break;
      }
    }

    return (
      at,
      index.$2,
    );
  }

  Chapter? getChapterByIndex(ChapterCacheIndex index) {
    final list = index.$2 ? mangaFilteredChapters : mangaChapters;
    final at = index.$1;

    return (
        (at < 0 || at >= list.length)
          ? null
        : list[at]
    );
  }

  Chapter? getPrevChapter() {
    return getChapterByIndex(getPrevChapterIndex(getChapterIndex()));
  }

  Chapter? getNextChapter() {
    return getChapterByIndex(getNextChapterIndex(getChapterIndex()));
  }

  int getChaptersLength(ChapterCacheIndex index) {
    return index.$2 ? mangaFilteredChapters.length : mangaChapters.length;
  }

  (Chapter?, Chapter?) getPrevNextChapter() {
    final index = getChapterIndex();
    final prev = getChapterByIndex(getPrevChapterIndex(index));
    final next = getChapterByIndex(getNextChapterIndex(index));

    return (
      prev,
      next,
    );
  }

  (bool, bool) getHasPrevNextChapter() {
    final chapters = getPrevNextChapter();

    return (
      chapters.$1 != null,
      chapters.$2 != null,
    );
  }

  int getPageIndex() {
    if (incognitoMode || chapter.isRead!) return 0;

    return chapter.getOption(settings.chapterPageIndexList)?.index ?? 0;
  }

  int getPageLength(List incognitoPageLength) {
    if (incognitoMode) return incognitoPageLength.length;

    return chapter.getOption(settings.chapterPageUrlsList)?.urls!.length ?? 0;
  }

  bool isGridMode() {
    return (getPageMode() == PageMode.doublePage && !(getReaderMode() == ReaderMode.horizontalContinuous));
  }

  /// {int} [index] Index to snap to slides grid. Uses `_uChapDataPreload.length` if `null`
  int snapIndex(int index, {int grid = 0, int list = 0}) {
    if (isGridMode()) {
      return (index / 2).ceil() + grid;
    }

    return index + list;
  }

  void setPageIndex(int newIndex, bool save) {
    if (chapter.isRead! || incognitoMode) return;

    final mode = getReaderMode();
    final continuous = mode == ReaderMode.verticalContinuous || mode == ReaderMode.webtoon;
    final pages = continuous ? getPageLength([]) : 0;
    final isRead = (newIndex >= pages - 1) || (continuous && (newIndex >= pages - 2));

    if (!(isRead || save)) {
      return;
    }

    settings = settings
      ..chapterPageIndexList = [
        ...chapter.getOtherOptions(settings.chapterPageIndexList),
        ChapterPageIndex()
          ..chapterId = chapter.id
          ..index = isRead ? 0 : newIndex,
      ];

    final chap = chapter;

    isar.writeTxnSync(() {
      chap.isRead = isRead;
      chap.lastPageRead = isRead ? '1' : (newIndex + 1).toString();
      ref.read(changedItemsManagerProvider(managerId: 1).notifier).addUpdatedChapter(chap, false, false);
      isar.chapters.putSync(chap);
    });

    if (isRead) {
      isar.updates.deleteForChaptersSync(mangaId, [chapter.id!]);
      chapter.updateTrackChapterRead(ref);
    }
  }

  String getMangaName() {
    return manga.name!;
  }

  String getChapterTitle() {
    return chapter.name!;
  }
}

extension ChapterExtensions on Chapter {
  void updateTrackChapterRead(dynamic ref) {
    if (!(ref is WidgetRef || ref is Ref)) return;
    final updateProgressAfterReading = ref.watch(updateProgressAfterReadingStateProvider);
    if (!updateProgressAfterReading) return;
    final manga = this.manga.value!;
    final chapterNumber = ChapterRecognition().parseChapterNumber(manga.name!, name!);

    final tracks =
        isar.tracks.filter().idIsNotNull().isMangaEqualTo(manga.isManga).mangaIdEqualTo(mangaId).findAllSync();

    if (tracks.isEmpty) return;
    for (var track in tracks) {
      final service = isar.trackPreferences.filter().syncIdIsNotNull().syncIdEqualTo(track.syncId).findFirstSync();
      if (!(service == null || chapterNumber <= (track.lastChapterRead ?? 0))) {
        if (track.status != TrackStatus.completed) {
          track.lastChapterRead = chapterNumber;
          if (track.lastChapterRead == track.totalChapter && (track.totalChapter ?? 0) > 0) {
            track.status = TrackStatus.completed;
            track.finishedReadingDate = DateTime.now().millisecondsSinceEpoch;
          } else {
            track.status = manga.isManga! ? TrackStatus.reading : TrackStatus.watching;
            if (track.lastChapterRead == 1) {
              track.startedReadingDate = DateTime.now().millisecondsSinceEpoch;
            }
          }
        }
        ref.read(trackStateProvider(track: track, isManga: manga.isManga).notifier).updateManga();
      }
    }
  }
}

extension MangaExtensions on Manga {
  List<Chapter> getFilteredChapterList({Settings? settings}) {
    return getChapterModel(settings ?? isar.settings.first).build(chapters).toList(growable: false);
  }
}
