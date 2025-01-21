import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
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
    return PopupMenuButton(
      popUpAnimationStyle: popupAnimationStyle,
      itemBuilder: (_) => <PopupMenuEntry<int>>[
        if (!isLocalArchive) PopupMenuItem<int>(value: 0, child: Text(context.l10n.refresh)),
        if (!isLocalArchive) PopupMenuItem<int>(value: 1, child: Text(context.l10n.share)),
        if (manga.favorite!) PopupMenuItem<int>(value: 2, child: Text(context.l10n.edit_categories)),
        if (!isLocalArchive) ...[
          const PopupMenuDivider(),
          PopupMenuItem<int>(value: -1, child: Text(context.l10n.next_chapter)),
          PopupMenuItem<int>(value: -5, child: Text(context.l10n.next_5_chapters)),
          PopupMenuItem<int>(value: -10, child: Text(context.l10n.next_10_chapters)),
          PopupMenuItem<int>(value: -25, child: Text(context.l10n.next_25_chapters)),
        ],
        const PopupMenuDivider(),
        PopupMenuItem<int>(value: 3, child: Text(context.l10n.unread)),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            widget.checkForUpdate(true);
          case 1:
            _share();
          case 2:
            context.push("/categories", extra: (true, manga.isManga! ? 0 : 1));
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
    String url = source!.apiUrl!.isEmpty ? manga.link! : "${source.baseUrl}${manga.link!}";

    Share.share(url);
  }

  void _downloadChapters(int value) {
    final chapters = isar.chapters.filter().idIsNotNull().mangaIdEqualTo(mangaId).findAllSync();
    final lastChapterReadIndex = chapters.lastIndexWhere((element) => element.isRead == true);

    if (lastChapterReadIndex == -1 || chapters.length == 1) {
      final chapter = chapters.first;
      final entry = isar.downloads.filter().idIsNotNull().chapterIdEqualTo(chapter.id).findFirstSync();

      if (entry == null || !entry.isDownload!) {
        ref.watch(downloadChapterProvider(chapter: chapter));
      }
    } else {
      for (var i = 1; i < value + 1; i++) {
        if (chapters.length > 1 && chapters.elementAtOrNull(lastChapterReadIndex + i) != null) {
          final chapter = chapters[lastChapterReadIndex + i];
          final entry = isar.downloads.filter().idIsNotNull().chapterIdEqualTo(chapter.id).findFirstSync();

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
      final entry = isar.downloads.filter().idIsNotNull().chapterIdEqualTo(chapter.id).findFirstSync();

      if (entry == null || !entry.isDownload!) {
        ref.watch(downloadChapterProvider(chapter: chapter));
      }
    }
  }
}
