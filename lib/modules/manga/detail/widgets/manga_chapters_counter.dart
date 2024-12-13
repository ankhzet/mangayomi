import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_import_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MangaChaptersCounter extends StatelessWidget {
  final Manga manga;
  final int chapters;

  const MangaChaptersCounter({
    super.key,
    required this.manga,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final isLocalArchive = manga.isLocalArchive ?? false;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    manga.isManga! ? l10n.n_chapters(chapters) : l10n.n_episodes(chapters),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (isLocalArchive) MangaImportWidget(manga: manga),
            ],
          ),
        ),
      ],
    );
  }
}
