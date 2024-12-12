import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/library_screen.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class MangaImportWidget extends StatelessWidget {
  final Manga manga;

  const MangaImportWidget({
    super.key,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Consumer(
      builder: (context, ref, child) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        icon: Icon(Icons.add, color: context.secondaryColor),
        label: Text(
          manga.isManga! ? l10n.add_chapters : l10n.add_episodes,
          style: TextStyle(fontWeight: FontWeight.bold, color: context.secondaryColor),
        ),
        onPressed: () async {
          if (manga.source == "torrent") {
            addTorrent(context, manga: manga);
          } else {
            await ref.watch(
              importArchivesFromFileProvider(isManga: manga.isManga!, manga, init: false).future,
            );
          }
        },
      ),
    );
  }
}
