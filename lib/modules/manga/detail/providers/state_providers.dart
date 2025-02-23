import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state_providers.g.dart';

@riverpod
class ChaptersListState extends _$ChaptersListState {
  @override
  set state(List<Chapter> value) {
    super.state = value;

    if (value.isEmpty) {
      toggleMode(false);
    }
  }

  @override
  List<Chapter> build() {
    return [];
  }

  void update(Chapter value) {
    updateAll([value]);
  }

  void updateAll(Iterable<Chapter> value) {
    var result = state.reversed.toList();

    for (final chapter in value) {
      if (result.contains(chapter)) {
        result.remove(chapter);
      } else {
        result.add(chapter);
      }
    }

    state = result;
  }

  void toggleMode(bool selecting) {
    ref.read(isLongPressedStateProvider.notifier).update(selecting);
  }

  void selectAll(Iterable<Chapter> chapters) {
    state = chapters.toList();
  }

  void toggle(Iterable<Chapter> chapters) {
    final dir = chapters.length - state.length;

    if (dir == 0) {
      return clear();
    }

    final ltr = dir > 0;
    final source = ltr ? chapters : state;
    final target = ltr ? state : chapters;

    final result = source.toList();

    for (var chapter in target) {
      if (result.contains(chapter)) {
        result.remove(chapter);
      } else {
        result.add(chapter);
      }
    }

    state = result;
  }

  void clear() {
    state = [];
    toggleMode(false);
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

abstract interface class Stateful<State> {
  State get state;

  set state(State state);
}

abstract interface class IFilterTypeState<T> implements Stateful<T> {
  T getOption();

  T getModel();

  void setModel(T model);
}

mixin OptionState<T extends OfManga> implements IFilterTypeState<T> {
  late final settings = isar.settings.first;
  late final int mangaId;

  @visibleForOverriding
  ChapterFilterOption get option;

  @override
  T getOption();

  Iterable<T> get collection {
    return switch (option) {
      ChapterFilterOption.download => settings.chapterFilterDownloadedList! as Iterable<T>,
      ChapterFilterOption.unread => settings.chapterFilterUnreadList! as Iterable<T>,
      ChapterFilterOption.bookmark => settings.chapterFilterBookmarkedList! as Iterable<T>,
      ChapterFilterOption.sort => settings.sortChapterList! as Iterable<T>,
    };
  }

  @override
  T getModel() {
    return collection.where(OfManga.isManga(mangaId)).firstOrNull ?? getOption();
  }

  @override
  void setModel(T model) {
    final dynamic list = collection.where(OfManga.isNotManga(mangaId)).toList()..add(model);

    switch (option) {
      case ChapterFilterOption.download:
        settings.chapterFilterDownloadedList = list;
      case ChapterFilterOption.unread:
        settings.chapterFilterUnreadList = list;
      case ChapterFilterOption.bookmark:
        settings.chapterFilterBookmarkedList = list;
      case ChapterFilterOption.sort:
        settings.sortChapterList = list;
    }

    isar.settings.first = settings;

    state = model;
  }
}

@riverpod
class SortChapterState extends _$SortChapterState with OptionState<SortChapter> {
  @override
  SortChapter build({required int mangaId}) {
    return getModel();
  }

  @override
  final option = ChapterFilterOption.sort;

  @override
  getOption() => SortChapter(mangaId: mangaId);

  void set(SortType type) {
    setModel(
      getOption()
        ..index = type.index
        ..reverse = this.type == type ? !isReverse : isReverse,
    );
  }

  int get index => state.index!;

  SortType get type => SortType.values[state.index!];

  bool get isReverse => state.reverse!;
}

mixin FilterOption<T extends FilterOptionModel> implements Stateful<T>, OptionState<T> {
  void update() {
    setModel(getOption()..type = (state.type! + 1) % 3);
  }
}

@riverpod
class ChapterFilterDownloadedState extends _$ChapterFilterDownloadedState
    with OptionState<FilterOptionModel>, FilterOption {
  @override
  FilterOptionModel build({required int mangaId}) {
    return getModel();
  }

  @override
  final option = ChapterFilterOption.download;

  @override
  getOption() => ChapterFilterDownloaded(mangaId: mangaId);
}

@riverpod
class ChapterFilterUnreadState extends _$ChapterFilterUnreadState with OptionState<FilterOptionModel>, FilterOption {
  @override
  FilterOptionModel build({required int mangaId}) {
    return getModel();
  }

  @override
  final option = ChapterFilterOption.unread;

  @override
  getOption() => ChapterFilterUnread(mangaId: mangaId);
}

@riverpod
class ChapterFilterBookmarkedState extends _$ChapterFilterBookmarkedState
    with OptionState<FilterOptionModel>, FilterOption {
  @override
  FilterOptionModel build({required int mangaId}) {
    return getModel();
  }

  @override
  final option = ChapterFilterOption.bookmark;

  @override
  getOption() => ChapterFilterBookmarked(mangaId: mangaId);
}

@riverpod
class ChapterFilterResultState extends _$ChapterFilterResultState {
  @override
  bool build({required Manga manga}) {
    return ref.watch(chapterFilterDownloadedStateProvider(mangaId: manga.id)).type == 0 &&
        ref.watch(chapterFilterUnreadStateProvider(mangaId: manga.id)).type == 0 &&
        ref.watch(chapterFilterBookmarkedStateProvider(mangaId: manga.id)).type == 0 &&
        ref.watch(scanlatorsFilterStateProvider(manga)).$2.isEmpty;
  }
}

@riverpod
class ChapterSetIsBookmarkState extends _$ChapterSetIsBookmarkState {
  @override
  void build({required Manga manga}) {}

  set() {
    final chapters = ref.watch(chaptersListStateProvider);
    isar.writeTxnSync(() {
      for (var chapter in chapters) {
        chapter.isBookmarked = !chapter.isBookmarked!;
        isar.chapters.putSync(chapter..manga.value = manga);
        chapter.manga.saveSync();
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.updateChapter, chapter.id, chapter.toJson(), false);
      }
    });
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetIsReadState extends _$ChapterSetIsReadState {
  @override
  void build({required Manga manga}) {}

  set() {
    final chapters = ref.watch(chaptersListStateProvider);
    isar.writeTxnSync(() {
      for (var chapter in chapters) {
        chapter.isRead = !chapter.isRead!;
        isar.chapters.putSync(chapter..manga.value = manga);
        chapter.manga.saveSync();
        ref
            .read(synchingProvider(syncId: 1).notifier)
            .addChangedPart(ActionType.updateChapter, chapter.id, chapter.toJson(), false);
      }
    });
    ref.read(isLongPressedStateProvider.notifier).update(false);
    ref.read(chaptersListStateProvider.notifier).clear();
  }
}

@riverpod
class ChapterSetDownloadState extends _$ChapterSetDownloadState {
  @override
  void build({required Manga manga}) {}

  set() {
    ref.read(isLongPressedStateProvider.notifier).update(false);
    isar.txnSync(() {
      for (var chapter in ref.watch(chaptersListStateProvider)) {
        final entries = isar.downloads.filter().idEqualTo(chapter.id).findAllSync();
        if (entries.isEmpty || !entries.first.isDownload!) {
          ref.watch(downloadChapterProvider(chapter: chapter));
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

  set(List<Chapter> chapters) async {
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
      if ((a.scanlator?.isNotEmpty ?? false) && !scanlators.contains(a.scanlator)) {
        scanlators.add(a.scanlator!);
      }
    }

    return scanlators;
  }

  void set(List<String> filterScanlators) async {
    final settings = isar.settings.first;
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
    isar.settings.first = settings..filterScanlatorList = filterScanlatorList;
    state = (_getScanlators(), _getFilterScanlator()!, filterScanlators);
  }

  List<String>? _getFilterScanlator() {
    final scanlators = isar.settings.first.filterScanlatorList ?? [];
    final filter = scanlators.where((element) => element.mangaId == manga.id).toList();
    return filter.isEmpty ? null : filter.first.scanlators;
  }

  setFilteredList(String scanlator) {
    List<String> scanlatorFilteredList = [...state.$3];

    if (scanlatorFilteredList.contains(scanlator)) {
      scanlatorFilteredList.remove(scanlator);
    } else {
      scanlatorFilteredList.add(scanlator);
    }

    state = (_getScanlators(), _getFilterScanlator() ?? [], scanlatorFilteredList);
  }
}
