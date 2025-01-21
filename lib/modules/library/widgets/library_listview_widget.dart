import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/library/providers/isar_providers.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/modules/widgets/manga_image_card_widget.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/manga.dart';

class LibraryListViewWidget extends StatelessWidget {
  final List<Manga> entriesManga;
  final bool language;
  final bool downloadedChapter;
  final bool unreadChapter;
  final List<int> mangaIdsList;
  final bool continueReaderBtn;
  final bool localSource;

  const LibraryListViewWidget({
    super.key,
    required this.entriesManga,
    required this.language,
    required this.unreadChapter,
    required this.downloadedChapter,
    required this.continueReaderBtn,
    required this.mangaIdsList,
    required this.localSource,
  });

  @override
  Widget build(BuildContext context) {
    return ListViewWidget(
      itemCount: entriesManga.length,
      itemBuilder: (context, index) {
        final entry = entriesManga[index];
        bool isLocalArchive = entry.isLocalArchive ?? false;

        return Consumer(builder: (context, ref, child) {
          final isLongPressed = ref.watch(isLongPressedMangaStateProvider);

          return Material(
            borderRadius: BorderRadius.circular(5),
            color: Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: () async {
                if (isLongPressed) {
                  ref.read(mangasListStateProvider.notifier).update(entry);
                } else {
                  await pushToMangaReaderDetail(
                    archiveId: isLocalArchive ? entry.id : null,
                    context: context,
                    lang: entry.lang!,
                    mangaM: entry,
                    source: entry.source!,
                  );
                  ref.invalidate(getAllMangaWithoutCategoriesStreamProvider(isManga: entry.isManga));
                  ref.invalidate(getAllMangaStreamProvider(categoryId: null, isManga: entry.isManga));
                }
              },
              onLongPress: () {
                ref.read(mangasListStateProvider.notifier).update(entry);

                if (!isLongPressed) {
                  ref.read(isLongPressedMangaStateProvider.notifier).update(!isLongPressed);
                }
              },
              onSecondaryTap: () {
                ref.read(mangasListStateProvider.notifier).update(entry);

                if (!isLongPressed) {
                  ref.read(isLongPressedMangaStateProvider.notifier).update(!isLongPressed);
                }
              },
              child: Container(
                color:
                    mangaIdsList.contains(entry.id) ? context.primaryColor.withValues(alpha: 0.4) : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Material(
                                  child: Ink.image(
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 45,
                                    image: entry.imageProvider(ref),
                                    child: InkWell(
                                        child: Container(
                                      color: mangaIdsList.contains(entry.id)
                                          ? context.primaryColor.withValues(alpha: 0.4)
                                          : Colors.transparent,
                                    )),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(entry.name!, overflow: TextOverflow.ellipsis),
                                      Row(children: [
                                        Text.rich(
                                            TextSpan(children: [
                                              TextSpan(text: 'Added: '),
                                              TextSpan(
                                                  text: dateFormat(null,
                                                      ref: ref,
                                                      context: context,
                                                      datetimeDate:
                                                          DateTime.fromMillisecondsSinceEpoch(entry.dateAdded!))),
                                            ]),
                                            style: Theme.of(context).textTheme.labelSmall!)
                                      ]),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: _badges(context: context, entry: entry),
                        ),
                        if (continueReaderBtn)
                          Consumer(
                            builder: (context, ref, child) {
                              return StreamBuilder(
                                stream: isar.historys
                                    .filter()
                                    .idIsNotNull()
                                    .and()
                                    .chapter((q) => q.manga((q) => q.isMangaEqualTo(entry.isManga!)))
                                    .watch(fireImmediately: true),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                    final incognitoMode = ref.watch(incognitoModeStateProvider);
                                    final entries =
                                        snapshot.data!.where((element) => element.mangaId == entry.id).toList();
                                    if (entries.isNotEmpty && !incognitoMode) {
                                      final chap = entries.first.chapter.value!;
                                      return GestureDetector(
                                        onTap: () {
                                          chap.pushToReaderView(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: context.primaryColor.withValues(alpha: 0.9),
                                          ),
                                          child: const Padding(
                                              padding: EdgeInsets.all(7),
                                              child: Icon(
                                                Icons.play_arrow,
                                                size: 19,
                                                color: Colors.white,
                                              )),
                                        ),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        entry.chapters.toList().reversed.toList().last.pushToReaderView(context);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: context.primaryColor.withValues(alpha: 0.9),
                                        ),
                                        child: const Padding(
                                            padding: EdgeInsets.all(7),
                                            child: Icon(
                                              Icons.play_arrow,
                                              size: 19,
                                              color: Colors.white,
                                            )),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      entry.chapters.toList().reversed.toList().last.pushToReaderView(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: context.primaryColor.withValues(alpha: 0.9),
                                      ),
                                      child: const Padding(
                                          padding: EdgeInsets.all(7),
                                          child: Icon(
                                            Icons.play_arrow,
                                            size: 19,
                                            color: Colors.white,
                                          )),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  String unreadChapters(Manga entry) {
    int count = isar.chapters.filter().idIsNotNull().mangaIdEqualTo(entry.id).not().isReadEqualTo(true).countSync();

    return count > 0 ? '$count' : '';
  }

  String downloadedChapters(Manga entry) {
    int count = isar.downloads.filter().idIsNotNull().mangaIdEqualTo(entry.id).distinctByChapterId().countSync();

    return count > 0 ? '$count' : '';
  }

  Widget _badges({required BuildContext context, required Manga entry}) {
    final List<(String, TextStyle?)> samples = [
      if (localSource && (entry.isLocalArchive ?? false)) ('Local', null),
      if (downloadedChapter) (downloadedChapters(entry), const TextStyle(color: Colors.deepOrange)),
      if (unreadChapter) (unreadChapters(entry), const TextStyle(color: Colors.yellowAccent)),
      ('${entry.chapters.length}', null),
      if (language && entry.lang!.isNotEmpty) (entry.lang!.toUpperCase(), const TextStyle(color: Colors.green)),
    ];

    final items = samples.fold<List<Widget>>([], (result, item) {
      if (item.$1.isEmpty) {
        return result;
      }

      if (result.isEmpty) {
        result.add(_badge(item.$1, style: item.$2));
      } else {
        result.add(Padding(
          padding: const EdgeInsets.only(left: 5),
          child: _badge(item.$1, style: item.$2),
        ));
      }

      return result;
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: context.primaryColor,
      ),
      child: SizedBox(
        height: 22,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Row(children: items),
        ),
      ),
    );
  }

  Widget _badge(String text, {TextStyle? style}) {
    return Text(
      text,
      style: style ?? const TextStyle(color: Colors.white),
    );
  }
}
