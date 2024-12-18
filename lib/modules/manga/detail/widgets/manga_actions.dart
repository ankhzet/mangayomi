import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/categories_selector.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_search_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/tracker_widget.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/pure_black_dark_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/track/widgets/track_list_tile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_source_baseurl.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/utils.dart';

class MangaActions extends StatelessWidget {
  final Manga manga;
  final double width;
  final double height;

  const MangaActions({
    super.key,
    required this.manga,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final l10n = l10nLocalizations(context)!;

      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                ),
                onPressed: () {
                  if (manga.favorite!) {
                    _favorite(false);
                  } else {
                    final checkCategoryList =
                        isar.categorys.filter().idIsNotNull().and().forMangaEqualTo(manga.isManga).isNotEmptySync();

                    if (checkCategoryList) {
                      _openCategory(context);
                    } else {
                      _favorite(true);
                    }
                  }
                },
                child: Column(
                  children: manga.favorite!
                      ? [
                          const Icon(Icons.favorite, size: 20),
                          const SizedBox(height: 4),
                          Text(
                            l10n.in_library,
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ]
                      : [
                          Icon(Icons.favorite_border_rounded, size: 20, color: context.secondaryColor),
                          const SizedBox(height: 4),
                          Text(
                            l10n.add_to_library,
                            style: TextStyle(color: context.secondaryColor, fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: isar.trackPreferences.filter().syncIdIsNotNull().watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    List<TrackPreference>? entries = snapshot.hasData ? snapshot.data! : [];
                    if (entries.isEmpty) {
                      return Container();
                    }
                    return SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor, elevation: 0),
                        onPressed: () {
                          _trackingDraggableMenu(context, entries);
                        },
                        child: StreamBuilder(
                            stream: isar.tracks
                                .filter()
                                .idIsNotNull()
                                .mangaIdEqualTo(manga.id)
                                .watch(fireImmediately: true),
                            builder: (context, snapshot) {
                              final l10n = l10nLocalizations(context)!;
                              List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
                              bool isNotEmpty = trackRes!.isNotEmpty;
                              Color color = isNotEmpty ? context.primaryColor : context.secondaryColor;
                              return Column(
                                children: [
                                  Icon(
                                    isNotEmpty ? Icons.done_rounded : Icons.sync_outlined,
                                    size: 20,
                                    color: color,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    isNotEmpty
                                        ? trackRes.length == 1
                                            ? l10n.one_tracker
                                            : l10n.n_tracker(trackRes.length)
                                        : l10n.tracking,
                                    style: TextStyle(fontSize: 11, color: color),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            }),
                      ),
                    );
                  }),
            ),
            Expanded(
              child: SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor, elevation: 0),
                  onPressed: () async {
                    final source = getSource(manga.lang!, manga.source!)!;
                    final baseUrl = ref.watch(sourceBaseUrlProvider(source: source));
                    String url = manga.link!.startsWith('/') ? "$baseUrl${manga.link!}" : manga.link!;

                    Map<String, dynamic> data = {'url': url, 'sourceId': source.id.toString(), 'title': manga.name!};
                    context.push("/mangawebview", extra: data);
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.public,
                        size: 20,
                        color: context.secondaryColor,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'WebView',
                        style: TextStyle(fontSize: 11, color: context.secondaryColor),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  void _favorite(bool favorite, {List<int>? categoryIds}) {
    isar.writeTxnSync(() {
      manga.favorite = favorite;
      manga.dateAdded = favorite ? DateTime.now().millisecondsSinceEpoch : 0;

      if (favorite && categoryIds != null) {
        manga.categories = categoryIds;
      }

      isar.mangas.putSync(manga);
    });
  }

  void _openCategory(BuildContext context) {
    List<int> categoryIds = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final l10n = l10nLocalizations(context)!;

            void handleAction(int index) {
              switch (index) {
                case 1:
                  context.push("/categories", extra: (true, manga.isManga! ? 0 : 1));
                  break;
                case 2:
                  _favorite(true, categoryIds: categoryIds);
                  break;
              }

              if (context.mounted) {
                Navigator.pop(context);
              }
            }

            return AlertDialog(
              title: Text(l10n.set_categories),
              content: SizedBox(
                width: context.width(0.8),
                child: CategoriesSelector(
                  isManga: manga.isManga,
                  onSelect: (category, select) => setState(() {
                    if (select) {
                      categoryIds.add(category.id!);
                    } else {
                      categoryIds.remove(category.id);
                    }
                  }),
                ),
              ),
              actions: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TextButton(onPressed: () => handleAction(1), child: Text(l10n.edit)),
                  Row(children: [
                    TextButton(onPressed: () => handleAction(0), child: Text(l10n.cancel)),
                    const SizedBox(width: 15),
                    TextButton(onPressed: () => handleAction(2), child: Text(l10n.ok)),
                  ]),
                ])
              ],
            );
          },
        );
      },
    );
  }

  void _trackingDraggableMenu(BuildContext context, List<TrackPreference>? entries) {
    DraggableMenu.open(
      context,
      DraggableMenu(
        ui: ClassicDraggableMenu(radius: 20, barItem: Container(), color: Theme.of(context).scaffoldBackgroundColor),
        allowToShrink: true,
        child: Consumer(
          builder: (context, ref, _) => Material(
            color: context.isLight
                ? Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9)
                : !ref.watch(pureBlackDarkModeStateProvider)
                    ? Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9)
                    : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                padding: const EdgeInsets.all(0),
                itemCount: entries!.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                      stream: isar.tracks
                          .filter()
                          .idIsNotNull()
                          .syncIdEqualTo(entries[index].syncId)
                          .mangaIdEqualTo(manga.id)
                          .watch(fireImmediately: true),
                      builder: (context, snapshot) {
                        List<Track>? trackRes = snapshot.hasData ? snapshot.data : [];
                        return trackRes!.isNotEmpty
                            ? TrackerWidget(
                                mangaId: manga.id,
                                syncId: entries[index].syncId!,
                                trackRes: trackRes.first,
                                isManga: manga.isManga!)
                            : TrackListTile(
                                text: l10nLocalizations(context)!.add_tracker,
                                onTap: () async {
                                  final trackSearch = await trackersSearchDraggableMenu(
                                    context,
                                    isManga: manga.isManga!,
                                    track: Track(
                                      status: TrackStatus.planToRead,
                                      syncId: entries[index].syncId!,
                                      title: manga.name!,
                                    ),
                                  );

                                  if (trackSearch != null) {
                                    await ref
                                        .read(trackStateProvider(track: null, isManga: manga.isManga!).notifier)
                                        .setTrackSearch(trackSearch, manga.id, entries[index].syncId!);
                                  }
                                },
                                id: entries[index].syncId!,
                                entries: const [],
                              );
                      });
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
