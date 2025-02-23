import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fetch_anime_sources.g.dart';

@Riverpod(keepAlive: true)
Future<void> fetchAnimeSourcesList(Ref ref, {int? id, required bool reFresh}) async {
  if (ref.watch(checkForExtensionsUpdateStateProvider) || reFresh) {
    final repos = ref.watch(extensionsRepoStateProvider(ItemType.anime));
    for (Repo repo in repos) {
      await fetchSourcesList(repo: repo, refresh: reFresh, id: id, ref: ref, itemType: ItemType.anime);
    }
  }
}
