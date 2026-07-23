import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_providers.g.dart';

@riverpod
class ChaptersListState extends _$ChaptersListState {
  @override
  List<Chapter> build() {
    return [];
  }

  void setState(List<Chapter> newState) {
    state = newState;

    if (state.isEmpty) {
      ref.read(isLongPressedStateProvider.notifier).update(false);
    }
  }

  void update(Chapter value) {
    var newList = state.reversed.toList();
    if (newList.contains(value)) {
      newList.remove(value);
    } else {
      newList.add(value);
    }

    setState(newList);
  }

  void selectAll(Iterable<Chapter> list) {
    setState(state.reversed.followedBy(list).toSet().toList());
  }

  void selectSome(Chapter value) {
    var newList = state.reversed.toList();

    if (newList.contains(value)) {
      newList.remove(value);
    } else {
      newList.add(value);
    }

    setState(newList);
  }

  void updateAll(List<Chapter> chapters) {
    var changed = chapters.isNotEmpty;

    if (!changed) {
      return;
    }

    var newList = state.reversed.toList();

    for (var chapter in chapters) {
      if (newList.contains(chapter)) {
        newList.remove(chapter);
      } else {
        newList.add(chapter);
      }
    }

    setState(newList);
  }

  void toggleGroup(List<Chapter> chapters) {
    var included = chapters.any((chapter) => state.contains(chapter));

    if (included) {
      setState(state.reversed.followedBy(chapters).toSet().toList());
    } else {
      setState(state.reversed.where((chapter) => !chapters.contains(chapter)).toList());
    }
  }

  void clear() {
    setState([]);
  }
}

@riverpod
class IsLongPressedState extends _$IsLongPressedState {
  @override
  bool build() {
    return false;
  }

  void update(bool value) {
    state = value;
  }
}

@riverpod
class IsExtendedState extends _$IsExtendedState {
  @override
  bool build() {
    return true;
  }

  void update(bool value) {
    state = value;
  }
}

@riverpod
class SortChapterState extends _$SortChapterState {
  @override
  SortChapter build({required int mangaId}) {
    return isar.settings
            .getSync(227)!
            .sortChapterList!
            .where((element) => element.mangaId == mangaId)
            .toList()
            .firstOrNull ??
        SortChapter(mangaId: mangaId, index: 1, reverse: false);
  }

  void update(bool reverse, int index) {
    var value = SortChapter()
      ..index = index
      ..mangaId = mangaId
      ..reverse = state.index == index ? !reverse : reverse;
    final settings = isar.settings.getSync(227)!;
    List<SortChapter>? sortChapterList = [];
    for (var sortChapter in settings.sortChapterList!) {
      if (sortChapter.mangaId != mangaId) {
        sortChapterList.add(sortChapter);
      }
    }
    sortChapterList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..sortChapterList = sortChapterList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });

    state = value;
  }

  void set(int index) {
    final reverse = isReverse();
    update(reverse, index);
  }

  bool isReverse() {
    return state.reverse!;
  }
}

@riverpod
class ChapterFilterDownloadedState extends _$ChapterFilterDownloadedState {
  @override
  int build({required int mangaId}) {
    state = getType();
    return getType();
  }

  int getType() {
    return (isar.settings
                .getSync(227)!
                .chapterFilterDownloadedList!
                .where((element) => element.mangaId == mangaId)
                .toList()
                .firstOrNull ??
            ChapterFilterDownloaded(mangaId: mangaId, type: 0))
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterDownloaded()
      ..type = type
      ..mangaId = mangaId;
    final settings = isar.settings.getSync(227)!;
    List<ChapterFilterDownloaded>? chapterFilterDownloadedList = [];
    for (var filterChapter in settings.chapterFilterDownloadedList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterDownloadedList.add(filterChapter);
      }
    }
    chapterFilterDownloadedList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..chapterFilterDownloadedList = chapterFilterDownloadedList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });

    state = type;
  }

  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}

@riverpod
class ChapterFilterUnreadState extends _$ChapterFilterUnreadState {
  @override
  int build({required int mangaId}) {
    state = getType();
    return getType();
  }

  int getType() {
    return (isar.settings
                .getSync(227)!
                .chapterFilterUnreadList!
                .where((element) => element.mangaId == mangaId)
                .toList()
                .firstOrNull ??
            ChapterFilterUnread(mangaId: mangaId, type: 0))
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterUnread()
      ..type = type
      ..mangaId = mangaId;
    final settings = isar.settings.getSync(227)!;
    List<ChapterFilterUnread>? chapterFilterUnreadList = [];
    for (var filterChapter in settings.chapterFilterUnreadList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterUnreadList.add(filterChapter);
      }
    }
    chapterFilterUnreadList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..chapterFilterUnreadList = chapterFilterUnreadList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
    state = type;
  }

  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}

@riverpod
class ChapterFilterBookmarkedState extends _$ChapterFilterBookmarkedState {
  @override
  int build({required int mangaId}) {
    state = getType();
    return getType();
  }

  int getType() {
    return (isar.settings
                .getSync(227)!
                .chapterFilterBookmarkedList!
                .where((element) => element.mangaId == mangaId)
                .toList()
                .firstOrNull ??
            ChapterFilterBookmarked(mangaId: mangaId, type: 0))
        .type!;
  }

  void setType(int type) {
    var value = ChapterFilterBookmarked()
      ..type = type
      ..mangaId = mangaId;
    final settings = isar.settings.getSync(227)!;
    List<ChapterFilterBookmarked>? chapterFilterBookmarkedList = [];
    for (var filterChapter in settings.chapterFilterBookmarkedList!) {
      if (filterChapter.mangaId != mangaId) {
        chapterFilterBookmarkedList.add(filterChapter);
      }
    }
    chapterFilterBookmarkedList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..chapterFilterBookmarkedList = chapterFilterBookmarkedList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
    state = type;
  }

  void update() {
    if (state == 0) {
      setType(1);
    } else if (state == 1) {
      setType(2);
    } else {
      setType(0);
    }
  }
}

@riverpod
class ChapterFilterResultState extends _$ChapterFilterResultState {
  @override
  bool build({required Manga manga}) {
    final downloadFilterType = ref.watch(
      chapterFilterDownloadedStateProvider(mangaId: manga.id),
    );
    final unreadFilterType = ref.watch(
      chapterFilterUnreadStateProvider(mangaId: manga.id),
    );

    final bookmarkedFilterType = ref.watch(
      chapterFilterBookmarkedStateProvider(mangaId: manga.id),
    );
    final scanlators = ref.watch(scanlatorsFilterStateProvider(manga));
    return downloadFilterType == 0 &&
        unreadFilterType == 0 &&
        bookmarkedFilterType == 0 &&
        scanlators.$2.isEmpty;
  }
}

@riverpod
class ChapterSetIsBookmarkState extends _$ChapterSetIsBookmarkState {
  @override
  void build({required Manga manga}) {}

  void set() {
    final allChapters = <Chapter>[];
    final chapters = ref.watch(chaptersListStateProvider);
    for (var chapter in chapters) {
      chapter.isBookmarked = !chapter.isBookmarked!;
      chapter.updatedAt = DateTime.now().millisecondsSinceEpoch;
      chapter.manga.value = manga;
      allChapters.add(chapter);
    }
    isar.writeTxnSync(() => isar.chapters.putAllSync(allChapters));
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetIsReadState extends _$ChapterSetIsReadState {
  @override
  void build({required Manga manga}) {}

  void set() {
    final allChapters = <Chapter>[];
    final chapters = ref.watch(chaptersListStateProvider);
    for (var chapter in chapters) {
      chapter.isRead = !chapter.isRead!;
      chapter.updatedAt = DateTime.now().millisecondsSinceEpoch;
      chapter.manga.value = manga;
      allChapters.add(chapter);
    }
    isar.writeTxnSync(() => isar.chapters.putAllSync(allChapters));
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetDownloadState extends _$ChapterSetDownloadState {
  @override
  void build({required Manga manga}) {}

  void set() {
    ref.read(isLongPressedStateProvider.notifier).update(false);
    isar.txnSync(() {
      for (var chapter in ref.watch(chaptersListStateProvider)) {
        final entries = isar.downloads
            .filter()
            .idEqualTo(chapter.id)
            .findAllSync();
        if (entries.isEmpty || !entries.first.isDownload!) {
          ref.watch(addDownloadToQueueProvider(chapter: chapter));
        }
      }
    });

    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChaptersListttState extends _$ChaptersListttState {
  @override
  List<Chapter> build() {
    return [];
  }

  void set(List<Chapter> chapters) async {
    await Future.delayed(const Duration(milliseconds: 10));
    state = chapters;
  }
}

@riverpod
class ScanlatorsFilterState extends _$ScanlatorsFilterState {
  @override
  (List<String>, List<String>, List<String>) build(Manga manga) {
    return (
      _getScanlators(),
      _getFilterScanlator() ?? [],
      _getFilterScanlator() ?? [],
    );
  }

  List<String> _getScanlators() {
    List<String> scanlators = [];
    for (var a in manga.chapters.toList()) {
      if ((a.scanlator?.isNotEmpty ?? false) &&
          !scanlators.contains(a.scanlator)) {
        scanlators.add(a.scanlator!);
      }
    }

    return scanlators;
  }

  void set(List<String> filterScanlators) async {
    final settings = isar.settings.getSync(227)!;
    var value = FilterScanlator()
      ..scanlators = filterScanlators
      ..mangaId = manga.id;
    List<FilterScanlator>? filterScanlatorList = [];
    for (var filterScanlator in settings.filterScanlatorList ?? []) {
      if (filterScanlator.mangaId != manga.id) {
        filterScanlatorList.add(filterScanlator);
      }
    }
    filterScanlatorList.add(value);
    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..filterScanlatorList = filterScanlatorList
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
    state = (_getScanlators(), _getFilterScanlator()!, filterScanlators);
  }

  List<String>? _getFilterScanlator() {
    final scanlators = isar.settings.getSync(227)!.filterScanlatorList ?? [];
    final filter = scanlators
        .where((element) => element.mangaId == manga.id)
        .toList();
    return filter.isEmpty ? null : filter.first.scanlators;
  }

  void setFilteredList(String scanlator) {
    List<String> scanlatorFilteredList = [];
    for (var a in state.$3) {
      scanlatorFilteredList.add(a);
    }

    if (scanlatorFilteredList.contains(scanlator)) {
      scanlatorFilteredList.remove(scanlator);
    } else {
      scanlatorFilteredList.add(scanlator);
    }
    state = (
      _getScanlators(),
      _getFilterScanlator() ?? [],
      scanlatorFilteredList,
    );
  }
}
