import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/more/settings/providers/incognito_mode_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';
part 'reader_controller_provider.g.dart';

@HiveType(typeId: 5)
enum ReaderMode {
  @HiveField(1)
  vertical,
  @HiveField(2)
  ltr,
  @HiveField(3)
  rtl,
  @HiveField(4)
  verticalContinuous,
  @HiveField(5)
  webtoon
}

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build() {
    return 0;
  }

  setCurrentIndex(int currentIndex) {
    state = currentIndex;
  }
}

@riverpod
class ReaderController extends _$ReaderController {
  @override
  void build({required MangaReaderModel mangaReaderModel}) {}

  ModelManga getModelManga() {
    return mangaReaderModel.modelManga;
  }

  ReaderMode getReaderMode() {
    return ref.watch(hiveBoxReaderModeProvider).get(
                "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
                defaultValue: null) !=
            null
        ? ref.watch(hiveBoxReaderModeProvider).get(
              "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
            )!
        : ref.watch(hiveBoxReaderModeProvider).get("globalMangaReaderModeValue",
            defaultValue: ReaderMode.vertical)!;
  }

  String getReaderModeValue(ReaderMode readerMode) {
    return readerMode == ReaderMode.vertical
        ? 'Vertical'
        : readerMode == ReaderMode.verticalContinuous
            ? 'Verical continuous'
            : readerMode == ReaderMode.ltr
                ? 'Left to Right'
                : readerMode == ReaderMode.rtl
                    ? 'Right to Left'
                    : 'Webtoon';
  }

  void setReaderMode(ReaderMode newReaderMode) {
    ref.watch(hiveBoxReaderModeProvider).put(
        "${getSourceName()}/${getMangaName()}-singleMangaReaderModeValue",
        newReaderMode);
  }

  void setShowPageNumber(bool value) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref
          .watch(hiveBoxMangaInfoProvider)
          .put("${getSourceName()}/${getMangaName()}-showPagesNumber", value);
    }
  }

  bool getShowPageNumber() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxMangaInfoProvider).get(
          "${getSourceName()}/${getMangaName()}-showPagesNumber",
          defaultValue: true);
    }
    return true;
  }

  void setMangaHistoryUpdate() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaHistoryProvider).put(
          '${getModelManga().lang}-${getModelManga().link}',
          MangaHistoryModel(
              date: DateTime.now().toString(), modelManga: getModelManga()));
    }
  }

  void setChapterPageLastRead(int pageIndex) async {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      List<ModelChapters> chapter = getModelManga().chapters!;
      chapter[getChapterIndex()].lastPageRead = (pageIndex + 1).toString();
      getModelManga().save();
    }
  }

  void setChapterBookmarked() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      final isBookmarked = getChapterBookmarked();
      List<ModelChapters> chapter = getModelManga().chapters!;
      chapter[getChapterIndex()].isBookmarked = !isBookmarked;
      getModelManga().save();
    }
  }

  bool getChapterBookmarked() {
    return ref
        .watch(hiveBoxMangaProvider)
        .get('${getModelManga().lang}-${getModelManga().link}',
            defaultValue: getModelManga())!
        .chapters![getChapterIndex()]
        .isBookmarked;
  }

  int getChapterIndex() {
    return mangaReaderModel.index;
  }

  void setChapterIndex() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaInfoProvider).put(
          "${getSourceName()}/${getMangaName()}-chapter_index",
          mangaReaderModel.index.toString());
    }
  }

  int getPageIndex() {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      return ref.watch(hiveBoxMangaInfoProvider).get(
          "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
          defaultValue: 0);
    }
    return 0;
  }

  int getPageLength(List incognitoPageLength) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      List<dynamic> page = ref.watch(hiveBoxMangaInfoProvider).get(
            "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-pageurl",
          );
      return page.length;
    }
    return incognitoPageLength.length;
  }

  void setPageIndex(int newIndex) {
    final incognitoMode = ref.watch(incognitoModeStateProvider);
    if (!incognitoMode) {
      ref.watch(hiveBoxMangaInfoProvider).put(
          "${getSourceName()}/${getMangaName()}/${getChapterTitle()}-page_index",
          newIndex);
    }
  }

  String getMangaName() {
    return getModelManga().name!;
  }

  String getSourceName() {
    return '${getModelManga().lang}-${getModelManga().source!}';
  }

  String getChapterTitle() {
    return getModelManga().chapters![mangaReaderModel.index].name!;
  }
}
