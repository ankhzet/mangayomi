import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
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
class ReaderController extends _$ReaderController {
  @override
  void build({required Chapter chapter}) {}

  late final manga = chapter.manga.value!;

  final incognitoMode = isar.settings.getSync(227)!.incognitoMode!;
  late final mangaId = manga.id;

  ReaderMode getReaderMode() {
    final personalReaderModeList = getIsarSetting().personalReaderModeList ?? [];
    final personalReaderMode = personalReaderModeList.where((element) => element.mangaId == manga.id);
    if (personalReaderMode.isNotEmpty) {
      return personalReaderMode.first.readerMode;
    }
    return isar.settings.getSync(227)!.defaultReaderMode;
  }

  (bool, double) getAutoScroll() {
    final autoScrollPagesList = getIsarSetting().autoScrollPages ?? [];
    final autoScrollPages = autoScrollPagesList.where((element) => element.mangaId == manga.id);
    if (autoScrollPages.isNotEmpty) {
      return (autoScrollPages.first.autoScroll ?? false, autoScrollPages.first.pageOffset ?? 10);
    }
    return (false, 10);
  }

  void setAutoScroll(bool value, double offset) {
    List<AutoScrollPages>? autoScrollPagesList = [];
    for (var autoScrollPages in getIsarSetting().autoScrollPages ?? []) {
      if (autoScrollPages.mangaId != manga.id) {
        autoScrollPagesList.add(autoScrollPages);
      }
    }
    autoScrollPagesList.add(AutoScrollPages()
      ..mangaId = manga.id
      ..pageOffset = offset
      ..autoScroll = value);
    isar.writeTxnSync(() => isar.settings.putSync(getIsarSetting()..autoScrollPages = autoScrollPagesList));
  }

  PageMode getPageMode() {
    final personalPageModeList = getIsarSetting().personalPageModeList ?? [];
    final personalPageMode = personalPageModeList.where((element) => element.mangaId == manga.id);
    if (personalPageMode.isNotEmpty) {
      return personalPageMode.first.pageMode;
    }
    return PageMode.onePage;
  }

  void setReaderMode(ReaderMode newReaderMode) {
    List<PersonalReaderMode>? personalReaderModeLists = [];
    for (var personalReaderMode in getIsarSetting().personalReaderModeList ?? []) {
      if (personalReaderMode.mangaId != manga.id) {
        personalReaderModeLists.add(personalReaderMode);
      }
    }
    personalReaderModeLists.add(PersonalReaderMode()
      ..mangaId = manga.id
      ..readerMode = newReaderMode);
    isar.writeTxnSync(() => isar.settings.putSync(getIsarSetting()..personalReaderModeList = personalReaderModeLists));
  }

  void setPageMode(PageMode newPageMode) {
    List<PersonalPageMode>? personalPageModeLists = [];
    for (var personalPageMode in getIsarSetting().personalPageModeList ?? []) {
      if (personalPageMode.mangaId != manga.id) {
        personalPageModeLists.add(personalPageMode);
      }
    }
    personalPageModeLists.add(PersonalPageMode()
      ..mangaId = manga.id
      ..pageMode = newPageMode);
    isar.writeTxnSync(() => isar.settings.putSync(getIsarSetting()..personalPageModeList = personalPageModeLists));
  }

  void setShowPageNumber(bool value) {
    if (!incognitoMode) {
      isar.writeTxnSync(() => isar.settings.putSync(getIsarSetting()..showPagesNumber = value));
    }
  }

  Settings getIsarSetting() {
    return isar.settings.getSync(227)!;
  }

  bool getShowPageNumber() {
    if (!incognitoMode) {
      return getIsarSetting().showPagesNumber!;
    }
    return true;
  }

  void setMangaHistoryUpdate() {
    if (incognitoMode) return;

    final lastRead = DateTime.now().millisecondsSinceEpoch;

    isar.writeTxnSync(() {
      isar.mangas.putSync(
        manga..lastRead = lastRead,
      );
    });
    History? history;

    final empty = isar.historys.filter().mangaIdEqualTo(manga.id).isEmptySync();

    if (empty) {
      history = History(
          mangaId: manga.id,
          date: DateTime.now().millisecondsSinceEpoch.toString(),
          isManga: manga.isManga,
          chapterId: chapter.id)
        ..chapter.value = chapter;
    } else {
      history = (isar.historys.filter().mangaIdEqualTo(manga.id).findFirstSync())!
        ..chapterId = chapter.id
        ..chapter.value = chapter
        ..date = DateTime.now().millisecondsSinceEpoch.toString();
    }
    isar.writeTxnSync(() {
      isar.historys.putSync(history!);
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

    for (var chapter in manga.getFilteredChapterList()) {
      if (id == chapter.id) {
        return (index, true);
      }

      index++;
    }

    index = 0;

    for (var chapter in manga.chapters.toList().reversed.toList()) {
      if (id == chapter.id) {
        break;
      }

      index++;
    }

    return (index, false);
  }

  ChapterCacheIndex getPrevChapterIndex() {
    final (index, inFilter) = getChapterIndex();

    return (
      index + 1,
      inFilter,
    );
  }

  ChapterCacheIndex getNextChapterIndex() {
    final (index, inFilter) = getChapterIndex();

    return (
      index - 1,
      inFilter,
    );
  }

  Chapter getChapterByIndex(ChapterCacheIndex index) {
    return index.$2
        ? manga.getFilteredChapterList()[index.$1]
        : manga.chapters.toList().reversed.toList()[index.$1];
  }

  Chapter getPrevChapter() {
    return getChapterByIndex(getPrevChapterIndex());
  }

  Chapter getNextChapter() {
    return getChapterByIndex(getNextChapterIndex());
  }

  int getChaptersLength(ChapterCacheIndex index) {
    return index.$2
        ? manga.getFilteredChapterList().length
        : manga.chapters.toList().reversed.toList().length;
  }

  (bool, bool) getChapterPrevNext() {
    final index = getChapterIndex();
    final hasPrevChapter = index.$1 + 1 != getChaptersLength(index);
    final hasNextChapter = index.$1 != 0;

    return (
      hasPrevChapter,
      hasNextChapter,
    );
  }

  int getPageIndex() {
    if (incognitoMode) return 0;
    final chapterPageIndexList = getIsarSetting().chapterPageIndexList ?? [];
    final index = chapterPageIndexList.where((element) => element.chapterId == chapter.id);
    return chapter.isRead!
        ? 0
        : index.isNotEmpty
            ? index.first.index!
            : 0;
  }

  int getPageLength(List incognitoPageLength) {
    if (incognitoMode) return incognitoPageLength.length;
    return getIsarSetting().chapterPageUrlsList!.where((element) => element.chapterId == chapter.id).first.urls!.length;
  }

  void setPageIndex(int newIndex, bool save) {
    if (chapter.isRead!) return;
    if (incognitoMode) return;
    final mode = getReaderMode();
    final continuous = mode == ReaderMode.verticalContinuous || mode == ReaderMode.webtoon;
    final pages = continuous ? getPageLength([]) : 0;
    final isRead = (newIndex >= pages - 1) || (continuous && (newIndex >= pages - 2));

    if (isRead || save) {
      List<ChapterPageIndex>? chapterPageIndexes = [];
      for (var chapterPageIndex in getIsarSetting().chapterPageIndexList ?? []) {
        if (chapterPageIndex.chapterId != chapter.id) {
          chapterPageIndexes.add(chapterPageIndex);
        }
      }
      chapterPageIndexes.add(ChapterPageIndex()
        ..chapterId = chapter.id
        ..index = isRead ? 0 : newIndex);
      final chap = chapter;
      isar.writeTxnSync(() {
        isar.settings.putSync(getIsarSetting()..chapterPageIndexList = chapterPageIndexes);
        chap.isRead = isRead;
        chap.lastPageRead = isRead ? '1' : (newIndex + 1).toString();
        ref.read(changedItemsManagerProvider(managerId: 1).notifier).addUpdatedChapter(chap, false, false);
        isar.chapters.putSync(chap);
      });

      if (isRead) {
        chapter.updateTrackChapterRead(ref);
      }
    }
  }

  String getMangaName() {
    return manga.name!;
  }

  String getSourceName() {
    return manga.source!;
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
  List<Chapter> getFilteredChapterList() {
    // todo: use sort model instead
    final data = chapters.toList().reversed.toList();
    final filterUnread = (isar.settings
                .getSync(227)!
                .chapterFilterUnreadList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            ChapterFilterUnread(
              mangaId: id,
              type: 0,
            ))
        .type!;

    final filterBookmarked = (isar.settings
                .getSync(227)!
                .chapterFilterBookmarkedList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            ChapterFilterBookmarked(
              mangaId: id,
              type: 0,
            ))
        .type!;
    final filterDownloaded = (isar.settings
                .getSync(227)!
                .chapterFilterDownloadedList!
                .where((element) => element.mangaId == id)
                .toList()
                .firstOrNull ??
            ChapterFilterDownloaded(
              mangaId: id,
              type: 0,
            ))
        .type!;

    final sortChapter =
        (isar.settings.getSync(227)!.sortChapterList!.where((element) => element.mangaId == id).toList().firstOrNull ??
                SortChapter(
                  mangaId: id,
                  index: 1,
                  reverse: false,
                ))
            .index;
    final filterScanlator = _getFilterScanlator(this) ?? [];
    List<Chapter> chapterList = data
        .where((element) => filterUnread == 1
            ? element.isRead == false
            : filterUnread == 2
                ? element.isRead == true
                : true)
        .where((element) => filterBookmarked == 1
            ? element.isBookmarked == true
            : filterBookmarked == 2
                ? element.isBookmarked == false
                : true)
        .where((element) {
          final modelChapDownload = isar.downloads.filter().idIsNotNull().chapterIdEqualTo(element.id).findAllSync();
          return filterDownloaded == 1
              ? modelChapDownload.isNotEmpty && modelChapDownload.first.isDownload == true
              : filterDownloaded == 2
                  ? !(modelChapDownload.isNotEmpty && modelChapDownload.first.isDownload == true)
                  : true;
        })
        .where((element) => !filterScanlator.contains(element.scanlator))
        .toList();

    if (sortChapter == 0) {
      chapterList.sort(
        (a, b) {
          if (a.scanlator == null || b.scanlator == null || a.dateUpload == null || b.dateUpload == null) {
            return 0;
          }

          int scan = a.scanlator!.compareTo(b.scanlator!);

          if (scan != 0) {
            return scan;
          }

          return a.dateUpload!.compareTo(b.dateUpload!);
        },
      );
    } else if (sortChapter == 1) {
      chapterList.sort(
        (a, b) {
          return a.compareTo(b);
        },
      );
    } else if (sortChapter == 2) {
      chapterList.sort(
        (a, b) {
          return (a.dateUpload == null || b.dateUpload == null)
              ? 0
              : int.parse(a.dateUpload!).compareTo(int.parse(b.dateUpload!));
        },
      );
    } else if (sortChapter == 3) {
      chapterList.sort(
        (a, b) {
          return (a.name == null || b.name == null) ? 0 : a.name!.compareTo(b.name!);
        },
      );
    }

    return chapterList;
  }
}

List<String>? _getFilterScanlator(Manga manga) {
  final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
  final filter = scanlators.where((element) => element.mangaId == manga.id).toList();
  return filter.firstOrNull?.scanlators;
}
