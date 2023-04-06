import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/source/source_list.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'refresh_filter_data.g.dart';

@riverpod
Future<bool> refreshFilterData(RefreshFilterDataRef ref) async {
  final lf = ref
      .watch(hiveBoxMangaFilterProvider)
      .get("language_filter", defaultValue: []);
  if (lf.isEmpty) {
    for (var element in sourcesList) {
      final sP = ref.watch(hiveBoxMangaSourceProvider);
      if (sP.containsKey("${element.sourceName}${element.lang}")) {
        final oldSp = ref
            .watch(hiveBoxMangaSourceProvider)
            .get("${element.sourceName}${element.lang}");
        ref.watch(hiveBoxMangaSourceProvider).put(
            "${element.sourceName}${element.lang}",
            SourceModel(
                sourceName: element.sourceName,
                url: element.url,
                lang: element.lang,
                typeSource: element.typeSource,
                logoUrl: element.logoUrl,
                isFullData: element.isFullData,
                isActive: oldSp!.isActive,
                isAdded: oldSp.isAdded,
                isNsfw: oldSp.isNsfw));
      } else {
        ref
            .watch(hiveBoxMangaSourceProvider)
            .put("${element.sourceName}${element.lang}", element);
      }
    }
  } else {
    for (var element in sourcesList) {
      final sP = ref.watch(hiveBoxMangaSourceProvider);
      if (sP.containsKey("${element.sourceName}${element.lang}")) {
        final oldSp = ref
            .watch(hiveBoxMangaSourceProvider)
            .get("${element.sourceName}${element.lang}");
        ref.watch(hiveBoxMangaSourceProvider).put(
            "${element.sourceName}${element.lang}",
            SourceModel(
                sourceName: element.sourceName,
                url: element.url,
                lang: element.lang,
                typeSource: element.typeSource,
                logoUrl: element.logoUrl,
                isFullData: element.isFullData,
                isActive: oldSp!.isActive,
                isAdded: oldSp.isAdded,
                isNsfw: oldSp.isNsfw));
      } else {
        ref
            .watch(hiveBoxMangaSourceProvider)
            .put("${element.sourceName}${element.lang}", element);
      }
    }
    for (var element in sourcesList) {
      for (var lang in lf) {
        if (element.lang.toLowerCase() == lang) {
          ref
              .watch(hiveBoxMangaSourceProvider)
              .delete("${element.sourceName}${element.lang}");
        }
      }
    }
  }
  return true;
}
