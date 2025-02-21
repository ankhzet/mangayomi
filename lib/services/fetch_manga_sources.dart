import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_manga_sources.g.dart';

@Riverpod(keepAlive: true)
Future fetchMangaSourcesList(Ref ref, {int? id, required reFresh}) async {
  if (reFresh || ref.watch(checkForExtensionsUpdateStateProvider)) {
    await fetchSourcesList(
        sourcesIndexUrl: "https://kodjodevf.github.io/mangayomi-extensions/index.json",
        refresh: reFresh,
        id: id,
        ref: ref,
        itemType: ItemType.manga);
  }
}
