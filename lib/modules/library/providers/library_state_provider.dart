import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_state_provider.g.dart';

@riverpod
class LibraryDisplayTypeState extends _$LibraryDisplayTypeState {
  @override
  DisplayType build({required ItemType itemType, required Settings settings}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.displayType;
      case ItemType.anime:
        return settings.animeDisplayType;
      default:
        return settings.novelDisplayType;
    }
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

    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..displayType = displayType;
        break;
      case ItemType.anime:
        appSettings = settings..animeDisplayType = displayType;
        break;
      default:
        appSettings = settings..novelDisplayType = displayType;
    }

    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryGridSizeState extends _$LibraryGridSizeState {
  @override
  int? build({required ItemType itemType}) {
    switch (itemType) {
      case ItemType.manga:
        return settings.mangaGridSize;
      case ItemType.anime:
        return settings.animeGridSize;
      default:
        return settings.novelGridSize;
    }
  }

  Settings get settings {
    return isar.settings.first;
  }

  void set(int? value, {bool end = false}) {
    Settings appSettings = Settings();

    state = value;
    if (end) {
      switch (itemType) {
        case ItemType.manga:
          appSettings = settings..mangaGridSize = value;
          break;
        case ItemType.anime:
          appSettings = settings..animeGridSize = value;
          break;
        default:
          appSettings = settings..novelGridSize = value;
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

  MangaFilter(Settings settings, ItemType type, void Function() onUpdate)
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
  MangaFilter build({required ItemType type, required Settings settings}) {
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
  ItemType type;
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
  bool build({required ItemType itemType, required Settings settings}) {
    return ref.watch(mangaFiltersStateProvider(type: itemType, settings: settings)).every((option) => option.value == 0);
  }
}

@riverpod
class LibraryShowCategoryTabsState extends _$LibraryShowCategoryTabsState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
      ItemType.manga => settings.libraryShowCategoryTabs!,
      ItemType.anime => settings.animeLibraryShowCategoryTabs!,
      _ =>  settings.novelLibraryShowCategoryTabs ?? false,
    }
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowCategoryTabs = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowCategoryTabs = value;
        break;
      default:
        appSettings = settings..novelLibraryShowCategoryTabs = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryDownloadedChaptersState extends _$LibraryDownloadedChaptersState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
       ItemType.manga => settings.libraryDownloadedChapters!,
       ItemType.anime => settings.animeLibraryDownloadedChapters!,
      _  => settings.novelLibraryDownloadedChapters ?? false,
    };
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryDownloadedChapters = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryDownloadedChapters = value;
        break;
      default:
        appSettings = settings..novelLibraryDownloadedChapters = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryUnreadChaptersState extends _$LibraryUnreadChaptersState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
      ItemType.manga => settings.libraryUnreadChapters!,
      ItemType.anime => settings.animeLibraryUnreadChapters!,
      _  => settings.novelLibraryUnreadChapters ?? false,
    };
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryUnreadChapters = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryUnreadChapters = value;
        break;
      default:
        appSettings = settings..novelLibraryUnreadChapters = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryLanguageState extends _$LibraryLanguageState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
       ItemType.manga => settings.libraryShowLanguage!,
       ItemType.anime => settings.animeLibraryShowLanguage!,
      _ => settings.novelLibraryShowLanguage ?? false,
    };
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowLanguage = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowLanguage = value;
        break;
      default:
        appSettings = settings..novelLibraryShowLanguage = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryLocalSourceState extends _$LibraryLocalSourceState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
       ItemType.manga => settings.libraryLocalSource ?? false,
       ItemType.anime => settings.animeLibraryLocalSource ?? false,
      _ => settings.novelLibraryLocalSource ?? false,
    };
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryLocalSource = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryLocalSource = value;
        break;
      default:
        appSettings = settings..novelLibraryLocalSource = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryShowNumbersOfItemsState extends _$LibraryShowNumbersOfItemsState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
       ItemType.manga => settings.libraryShowNumbersOfItems!,
       ItemType.anime => settings.animeLibraryShowNumbersOfItems!,
      _ => settings.novelLibraryShowNumbersOfItems ?? false,
    };
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowNumbersOfItems = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowNumbersOfItems = value;
        break;
      default:
        appSettings = settings..novelLibraryShowNumbersOfItems = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class LibraryShowContinueReadingButtonState extends _$LibraryShowContinueReadingButtonState {
  @override
  bool build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
      ItemType.manga => settings.libraryShowContinueReadingButton!,
      ItemType.anime => settings.animeLibraryShowContinueReadingButton!,
      _ => settings.novelLibraryShowContinueReadingButton ?? false,
    };
  }

  void set(bool value) {
    Settings appSettings = Settings();
    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..libraryShowContinueReadingButton = value;
        break;
      case ItemType.anime:
        appSettings = settings..animeLibraryShowContinueReadingButton = value;
        break;
      default:
        appSettings = settings..novelLibraryShowContinueReadingButton = value;
    }
    state = value;
    isar.settings.first = appSettings;
  }
}

@riverpod
class SortLibraryMangaState extends _$SortLibraryMangaState {
  @override
  SortLibraryManga build({required ItemType itemType, required Settings settings}) {
    return switch (itemType) {
      ItemType.manga => settings.sortLibraryManga ?? SortLibraryManga(),
      ItemType.anime => settings.sortLibraryAnime ?? SortLibraryManga(),
      _ => settings.sortLibraryNovel ?? SortLibraryManga(),
    };
  }

  void update(bool reverse, int index) {
    Settings appSettings = Settings();
    var value = SortLibraryManga()
      ..index = index
      ..reverse = state.index == index ? !reverse : reverse;

    switch (itemType) {
      case ItemType.manga:
        appSettings = settings..sortLibraryManga = value;
        break;
      case ItemType.anime:
        appSettings = settings..sortLibraryAnime = value;
        break;
      default:
        appSettings = settings..sortLibraryNovel = value;
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
          isar.chapters.putSync(chapter..manga.value = manga);
          chapter.manga.saveSync();
        }
      });
    }

    ref.read(isLongPressedMangaStateProvider.notifier).update(false);
    ref.read(mangasListStateProvider.notifier).clear();
  }
}
