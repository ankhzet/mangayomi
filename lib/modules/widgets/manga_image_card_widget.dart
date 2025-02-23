import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/changed.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/manga.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class MangaImageCardWidget extends ConsumerWidget {
  final Source source;
  final ItemType itemType;
  final bool isComfortableGrid;
  final MManga? getMangaDetail;

  const MangaImageCardWidget(
      {required this.source,
      super.key,
      required this.getMangaDetail,
      required this.isComfortableGrid,
      required this.itemType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: isar.mangas
            .filter()
            .langEqualTo(source.lang)
            .nameEqualTo(getMangaDetail!.name)
            .sourceEqualTo(source.name)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          final hasData = snapshot.hasData && snapshot.data!.isNotEmpty;
          final manga = hasData
              ? snapshot.data!.first
              : Manga(
                  imageUrl: getMangaDetail!.imageUrl ?? "",
                  source: source.name,
                  lang: source.lang,
                );

          return CoverViewWidget(
              bottomTextWidget: BottomTextWidget(
                maxLines: 1,
                text: getMangaDetail!.name!,
                isComfortableGrid: isComfortableGrid,
              ),
              isComfortableGrid: isComfortableGrid,
              image: manga.imageProvider(ref, cacheMaxAge: const Duration(days: 7)),
              onTap: () {
                pushToMangaReaderDetail(
                    ref: ref,
                    context: context,
                    getManga: getMangaDetail!,
                    lang: source.lang!,
                    source: source.name!,
                    itemType: itemType);
              },
              onLongPress: () {
                pushToMangaReaderDetail(
                    ref: ref,
                    context: context,
                    getManga: getMangaDetail!,
                    lang: source.lang!,
                    source: source.name!,
                    itemType: itemType,
                    addToFavourite: true);
              },
              onSecondaryTap: () {
                pushToMangaReaderDetail(
                    ref: ref,
                    context: context,
                    getManga: getMangaDetail!,
                    lang: source.lang!,
                    source: source.name!,
                    itemType: itemType,
                    addToFavourite: true);
              },
              children: [
                Container(color: manga.favorite! ? Colors.black.withValues(alpha: 0.5) : null),
                if (manga.favorite!)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.collections_bookmark_outlined,
                              size: 16, color: context.dynamicWhiteBlackColor),
                        ),
                      ),
                    ),
                  ),
                if (!isComfortableGrid) BottomTextWidget(isTorrent: source.isTorrent, text: getMangaDetail!.name!)
              ]);
        });
  }
}

class MangaImageCardListTileWidget extends ConsumerWidget {
  final Source source;
  final ItemType itemType;
  final MManga? getMangaDetail;

  const MangaImageCardListTileWidget({
    super.key,
    required this.source,
    required this.itemType,
    required this.getMangaDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: isar.mangas
            .filter()
            .langEqualTo(source.lang)
            .nameEqualTo(getMangaDetail!.name)
            .sourceEqualTo(source.name)
            .linkEqualTo(getMangaDetail!.link)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          final manga = (snapshot.hasData && snapshot.data!.isNotEmpty)
              ? snapshot.data!.first
              : Manga(
                  imageUrl: getMangaDetail!.imageUrl ?? "",
                  source: source.name,
                  lang: source.lang,
                );
          final image = manga.imageProvider(ref);

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () => pushToMangaReaderDetail(
                  ref: ref,
                  context: context,
                  getManga: getMangaDetail!,
                  lang: source.lang!,
                  source: source.name!,
                  itemType: itemType,
                ),
                onLongPress: () => pushToMangaReaderDetail(
                  ref: ref,
                  context: context,
                  getManga: getMangaDetail!,
                  lang: source.lang!,
                  source: source.name!,
                  itemType: itemType,
                  addToFavourite: true,
                ),
                onSecondaryTap: () => pushToMangaReaderDetail(
                  ref: ref,
                  context: context,
                  getManga: getMangaDetail!,
                  lang: source.lang!,
                  source: source.name!,
                  itemType: itemType,
                  addToFavourite: true,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image(height: 55, width: 40, fit: BoxFit.cover, image: image),
                          ),
                          Container(
                            height: 55,
                            width: 40,
                            color: manga.favorite! ? Colors.black.withValues(alpha: 0.5) : null,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        getMangaDetail!.name!,
                        maxLines: 2,
                        style: TextStyle(overflow: TextOverflow.ellipsis, color: context.textColor),
                      ),
                    ),
                    if (manga.favorite!)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.collections_bookmark_outlined,
                              size: 16,
                              color: context.dynamicWhiteBlackColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Future<void> pushToMangaReaderDetail({
  required WidgetRef ref,
  required String lang,
  required BuildContext context,
  required String source,
  MManga? getManga,
  int? archiveId,
  Manga? mangaM,
  ItemType? itemType,
  bool useMaterialRoute = false,
  bool addToFavourite = false,
}) async {
  int mangaId = 0;

  if (archiveId == null) {
    final manga = mangaM ??
        Manga(
          imageUrl: getManga!.imageUrl,
          name: getManga.name!.normalize(),
          genre: getManga.genre?.map((e) => e.toString()).toList() ?? [],
          author: getManga.author ?? "",
          status: getManga.status ?? Status.unknown,
          description: getManga.description ?? "",
          link: getManga.link,
          source: source,
          lang: lang,
          lastUpdate: 0,
          itemType: itemType ?? ItemType.manga,
          artist: getManga.artist ?? '',
        );

    final existing =
        isar.mangas.filter().langEqualTo(lang).nameEqualTo(manga.name).sourceEqualTo(manga.source).findFirstSync();

    if (existing == null) {
      isar.writeTxnSync(() {
        mangaId = isar.mangas.putSync(manga);
        ref.read(synchingProvider(syncId: 1).notifier).addChangedPart(ActionType.addItem, null, manga.toJson(), false);
      });
    } else {
      mangaId = existing.id;
    }
  } else {
    mangaId = archiveId;
  }

  final settings = isar.settings.first;
  final sortList = settings.sortChapterList ?? [];
  final existing = sortList.firstWhereOrNull(OfManga.isManga(mangaId));

  if (existing == null) {
    isar.settings.first = settings
      ..sortChapterList = [...sortList, SortChapter()..mangaId = mangaId]
      ..chapterFilterBookmarkedList = [
        ...settings.chapterFilterBookmarkedList ?? [],
        ChapterFilterBookmarked()..mangaId = mangaId
      ]
      ..chapterFilterDownloadedList = [
        ...settings.chapterFilterDownloadedList ?? [],
        ChapterFilterDownloaded()..mangaId = mangaId
      ]
      ..chapterFilterUnreadList = [...settings.chapterFilterUnreadList ?? [], ChapterFilterUnread()..mangaId = mangaId];
  }
  if (addToFavourite) {
    final getManga = isar.mangas.filter().idEqualTo(mangaId).findFirstSync()!;

    isar.writeTxnSync(() {
      isar.mangas.putSync(getManga..favorite = !getManga.favorite!);
      ref
          .read(synchingProvider(syncId: 1).notifier)
          .addChangedPart(ActionType.updateItem, getManga.id, getManga.toJson(), false);
    });
  } else if (useMaterialRoute) {
    await Navigator.push(
      context,
      createRoute(page: MangaReaderDetail(mangaId: mangaId)),
    );
  } else {
    await context.push('/manga-reader/detail', extra: mangaId);
  }
}
