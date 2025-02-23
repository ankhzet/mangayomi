import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class MangaActionsMenu extends ConsumerStatefulWidget {
  final Manga manga;
  final Function(bool) checkForUpdate;

  const MangaActionsMenu({
    super.key,
    required this.manga,
    required this.checkForUpdate,
  });

  @override
  ConsumerState<MangaActionsMenu> createState() => _MangaActionsMenuState();
}

class _MangaActionsMenuState extends ConsumerState<MangaActionsMenu> {
  late final manga = widget.manga;
  late final mangaId = widget.manga.id;
  late final isLocalArchive = widget.manga.isLocalArchive ?? false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isVideo = manga.itemType == ItemType.anime;

    return PopupMenuButton(
      popUpAnimationStyle: popupAnimationStyle,
      itemBuilder: (_) => <PopupMenuEntry<int>>[
        if (!isLocalArchive) PopupMenuItem<int>(value: 0, child: Text(l10n.refresh)),
        if (!isLocalArchive) PopupMenuItem<int>(value: 1, child: Text(l10n.share)),
        if (manga.favorite!) PopupMenuItem<int>(value: 2, child: Text(l10n.edit_categories)),
        if (!isLocalArchive) ...[
          const PopupMenuDivider(),
          PopupMenuItem<int>(value: -1, child: Text(isVideo ? l10n.next_episode : l10n.next_chapter)),
          PopupMenuItem<int>(value: -5, child: Text(isVideo ? l10n.next_5_episodes : l10n.next_5_chapters)),
          PopupMenuItem<int>(value: -10, child: Text(isVideo ? l10n.next_10_episodes : l10n.next_10_chapters)),
          PopupMenuItem<int>(value: -25, child: Text(isVideo ? l10n.next_25_episodes : l10n.next_25_chapters)),
        ],
        const PopupMenuDivider(),
        PopupMenuItem<int>(value: 3, child: Text(isVideo ? l10n.unwatched : l10n.unread)),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            widget.checkForUpdate(true);
          case 1:
            _share();
          case 2:
            context.push("/categories", extra: (
              true,
              switch (manga.itemType) {
                ItemType.manga => 0,
                ItemType.anime => 1,
                ItemType.novel => 2,
              }
            ));
          case 3:
            _unreadChapters();
          case < 0:
            _downloadChapters(-value);
        }
      },
    );
  }

  void _share() {
    final source = getSource(manga.lang!, manga.source!);
    String url = source!.apiUrl!.isEmpty ? manga.link! : "${source.baseUrl}${manga.link!.getUrlWithoutDomain}";

    Share.share(url);
  }

  void _downloadChapters(int value) {
    final chapters = isar.chapters.filter().idIsNotNull().mangaIdEqualTo(mangaId).findAllSync();
    final lastChapterReadIndex = chapters.lastIndexWhere((element) => element.isRead == true);

    if (lastChapterReadIndex == -1 || chapters.length == 1) {
      final chapter = chapters.first;
      final entry = isar.downloads.filter().idEqualTo(chapter.id).findFirstSync();

      if (entry == null || !entry.isDownload!) {
        ref.watch(downloadChapterProvider(chapter: chapter));
      }
    } else {
      for (var i = 1; i < value + 1; i++) {
        if (chapters.length > 1 && chapters.elementAtOrNull(lastChapterReadIndex + i) != null) {
          final chapter = chapters[lastChapterReadIndex + i];
          final entry = isar.downloads.filter().idEqualTo(chapter.id).findFirstSync();

          if (entry == null || !entry.isDownload!) {
            ref.watch(downloadChapterProvider(chapter: chapter));
          }
        }
      }
    }
  }

  void _unreadChapters() {
    final unreadChapters =
        isar.chapters.filter().idIsNotNull().mangaIdEqualTo(mangaId).isReadEqualTo(false).findAllSync();

    for (var chapter in unreadChapters) {
      final entry = isar.downloads.filter().idEqualTo(chapter.id).findFirstSync();

      if (entry == null || !entry.isDownload!) {
        ref.watch(downloadChapterProvider(chapter: chapter));
      }
    }
  }
}
