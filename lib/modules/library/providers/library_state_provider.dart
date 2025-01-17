import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_state_provider.g.dart';

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  DisplayType build({required bool isManga, required Settings settings}) {
    return isManga ? settings.displayType : settings.animeDisplayType;
  }

  String getLibraryDisplayTypeName(DisplayType displayType, BuildContext context) {
    final l10n = context.l10n;
    return switch (displayType) {
      DisplayType.compactGrid => l10n.compact_grid,
      DisplayType.comfortableGrid => l10n.comfortable_grid,
      DisplayType.coverOnlyGrid => l10n.cover_only_grid,
      _ => l10n.list,
    };
  }

  void setLibraryDisplayType(DisplayType displayType) {
    Settings appSettings = Settings();

    state = displayType;
    if (isManga) {
      appSettings = settings..displayType = displayType;
    } else {
      appSettings = settings..animeDisplayType = displayType;
    }

    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryGridSizeState extends _$LibraryGridSizeState {
  @override
  int? build({required bool isManga}) {
    return isManga ? settings.mangaGridSize : settings.animeGridSize;
  }

  Settings get settings {
    return isar.settings.first;
  }

  void set(int? value, {bool end = false}) {
    Settings appSettings = Settings();

    state = value;
    if (end) {
      if (isManga) {
        appSettings = settings..mangaGridSize = value;
      } else {
        appSettings = settings..animeGridSize = value;
      }

      isar.settings.first = appSettings;
    }
  }
}

class MangaFilter with Iterable<MangaFilterState> {
  static final List<(int bit, bool Function(Manga manga) filter)> bits = [
    (LibraryFilter.downloadedBit, isMatchingDownloaded),
    (LibraryFilter.unreadBit, isMatchingUnread),
    (LibraryFilter.bookmarkedBit, isMatchingBookmarked),
    (LibraryFilter.startedBit, isMatchingStarted),
  ];

  late MangaFilterState downloaded = getOfBit(LibraryFilter.downloadedBit);
  late MangaFilterState unread = getOfBit(LibraryFilter.unreadBit);
  late MangaFilterState bookmarked = getOfBit(LibraryFilter.bookmarkedBit);
  late MangaFilterState started = getOfBit(LibraryFilter.startedBit);

  Iterable<MangaFilterState> all;

  MangaFilter(Settings settings, bool type, void Function() onUpdate)
      : all = bits.map((bit) => MangaFilterState(
              settings: settings,
              type: type,
              position: bit.$1,
              filter: bit.$2,
              onUpdate: onUpdate,
            ));

  MangaFilterState getOfBit(int bit) {
    for (final (index, state) in all.indexed) {
      if (bits[index].$1 == bit) {
        return state;
      }
    }

    throw AssertionError('Unknown filter bit "$bit"');
  }

  @override
  late int hashCode = Object.hash(
    downloaded,
    unread,
    bookmarked,
    started,
  );

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  Iterator<MangaFilterState> get iterator => all.iterator;

  static bool isMatchingDownloaded(Manga manga) {
    return isar.downloads
        .filter()
        .mangaIdEqualTo(manga.id)
        .idIsNotNull()
        .isDownloadEqualTo(true)
        .anyOf(manga.chapters.map((chapter) => chapter.id), (q, id) => q.chapterIdEqualTo(id))
        .limit(1)
        .isNotEmptySync();
  }

  static bool isMatchingUnread(Manga manga) {
    return manga.chapters.any((chapter) => chapter.isRead != true);
  }

  static bool isMatchingStarted(Manga manga) {
    return manga.chapters.any((chapter) => chapter.isRead == true);
  }

  static bool isMatchingBookmarked(Manga manga) {
    return manga.chapters.any((chapter) => chapter.isBookmarked == true);
  }
}

@riverpod
class MangaFiltersState extends _$MangaFiltersState {
  @override
  MangaFilter build({required bool type, required Settings settings}) {
    return state = MangaFilter(
      settings,
      type,
      update,
    );
  }

  void update() {
    state = MangaFilter(
      settings,
      type,
      update,
    );
  }

  Iterable<Manga> filterEntries(Iterable<Manga> entries) {
    for (final option in state) {
      entries = option.filterEntries(entries);
    }

    return entries;
  }
}

class MangaFilterState {
  Settings settings;
  bool type;
  int position;
  bool Function(Manga manga) filter;
  void Function() onUpdate;

  late int value = getValue();

  MangaFilterState({
    required this.settings,
    required this.type,
    required this.position,
    required this.filter,
    required this.onUpdate,
  });

  int getValue() {
    return settings.libraryFilter?.getValue(type, position) ?? 0;
  }

  int setValue(int value) {
    isar.settings.first = settings
      ..libraryFilter = ((settings.libraryFilter ?? LibraryFilter())..setValue(type, position, value));

    onUpdate();
    return value;
  }

  Iterable<Manga> filterEntries(Iterable<Manga> entries) {
    return switch (value) {
      1 => entries.where(filter).toList(),
      2 => entries.where((element) => !filter(element)).toList(),
      _ => entries,
    };
  }

  update() {
    return setValue((value + 1) % 3);
  }
}

@riverpod
class MangasFilterResultState extends _$MangasFilterResultState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return ref.watch(mangaFiltersStateProvider(type: isManga, settings: settings)).every((option) => option.value == 0);
  }
}

@riverpod
class LibraryShowCategoryTabsState extends _$LibraryShowCategoryTabsState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.libraryShowCategoryTabs : settings.animeLibraryShowCategoryTabs) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowCategoryTabs = value;
    } else {
      appSettings = settings..animeLibraryShowCategoryTabs = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryDownloadedChaptersState extends _$LibraryDownloadedChaptersState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.libraryDownloadedChapters : settings.animeLibraryDownloadedChapters) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryDownloadedChapters = value;
    } else {
      appSettings = settings..animeLibraryDownloadedChapters = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryUnreadChaptersState extends _$LibraryUnreadChaptersState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.libraryUnreadChapters : settings.animeLibraryUnreadChapters) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryUnreadChapters = value;
    } else {
      appSettings = settings..animeLibraryUnreadChapters = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryLanguageState extends _$LibraryLanguageState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.libraryShowLanguage : settings.animeLibraryShowLanguage) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowLanguage = value;
    } else {
      appSettings = settings..animeLibraryShowLanguage = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryLocalSourceState extends _$LibraryLocalSourceState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.libraryLocalSource : settings.animeLibraryLocalSource) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryLocalSource = value;
    } else {
      appSettings = settings..animeLibraryLocalSource = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryShowNumbersOfItemsState extends _$LibraryShowNumbersOfItemsState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.libraryShowNumbersOfItems : settings.animeLibraryShowNumbersOfItems) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowNumbersOfItems = value;
    } else {
      appSettings = settings..animeLibraryShowNumbersOfItems = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryShowContinueReadingButtonState extends _$LibraryShowContinueReadingButtonState {
  @override
  bool build({required bool isManga, required Settings settings}) {
    return (isManga
        ? settings.libraryShowContinueReadingButton
        : settings.animeLibraryShowContinueReadingButton) ?? false;
  }

  void set(bool value) {
    Settings appSettings = Settings();
    if (isManga) {
      appSettings = settings..libraryShowContinueReadingButton = value;
    } else {
      appSettings = settings..animeLibraryShowContinueReadingButton = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class SortLibraryMangaState extends _$SortLibraryMangaState {
  @override
  SortLibraryManga build({required bool isManga, required Settings settings}) {
    return (isManga ? settings.sortLibraryManga : settings.sortLibraryAnime) ?? SortLibraryManga();
  }

  void update(bool reverse, int index) {
    Settings appSettings = Settings();
    var value = SortLibraryManga()
      ..index = index
      ..reverse = state.index == index ? !reverse : reverse;

    if (isManga) {
      appSettings = settings..sortLibraryManga = value;
    } else {
      appSettings = settings..sortLibraryAnime = value;
    }
    isar.settings.first = appSettings;
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
class MangasListState extends _$MangasListState {
  @override
  List<int> build() {
    return [];
  }

  void update(Manga value) {
    var newList = state.reversed.toList();
    if (newList.contains(value.id)) {
      newList.remove(value.id);
    } else {
      newList.add(value.id);
    }
    if (newList.isEmpty) {
      ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    }
    state = newList;
  }

  void selectAll(Manga value) {
    var newList = state.reversed.toList();
    if (!newList.contains(value.id)) {
      newList.add(value.id);
    }

    state = newList;
  }

  void selectSome(Manga value) {
    var newList = state.reversed.toList();
    if (newList.contains(value.id)) {
      newList.remove(value.id);
    } else {
      newList.add(value.id);
    }
    state = newList;
  }

  void clear() {
    state = [];
  }
}

@riverpod
class IsLongPressedMangaState extends _$IsLongPressedMangaState {
  @override
  bool build() {
    return false;
  }

  void update(bool value) {
    state = value;
  }
}

@riverpod
class MangasSetIsReadState extends _$MangasSetIsReadState {
  @override
  void build({required List<int> mangaIds}) {}

  void set() {
    for (var mangaid in mangaIds) {
      final manga = isar.mangas.getSync(mangaid)!;
      final chapters = manga.chapters;
      if (chapters.isNotEmpty) {
        chapters.last.updateTrackChapterRead(ref);
        isar.writeTxnSync(() {
          for (var chapter in chapters) {
            chapter.isRead = true;
            chapter.lastPageRead = "1";
            ref.read(changedItemsManagerProvider(managerId: 1).notifier).addUpdatedChapter(chapter, false, false);
            isar.chapters.putSync(chapter..manga.value = manga);
            chapter.manga.saveSync();
          }
        });
      }
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}

@riverpod
class MangasSetUnReadState extends _$MangasSetUnReadState {
  @override
  void build({required List<int> mangaIds}) {}

  void set() {
    for (var mangaid in mangaIds) {
      final manga = isar.mangas.getSync(mangaid)!;
      final chapters = manga.chapters;
      isar.writeTxnSync(() {
        for (var chapter in chapters) {
          chapter.isRead = false;
          ref.read(changedItemsManagerProvider(managerId: 1).notifier).addUpdatedChapter(chapter, false, false);
          isar.chapters.putSync(chapter..manga.value = manga);
          chapter.manga.saveSync();
        }
      });
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}
