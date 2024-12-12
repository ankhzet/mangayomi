import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/widgets/custom_floating_action_btn.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/consumer_state.dart';

class MangaDetailsView extends ConsumerStatefulWidget {
  final Manga manga;
  final bool sourceExist;
  final Function(bool) checkForUpdate;

  const MangaDetailsView({
    super.key,
    required this.sourceExist,
    required this.manga,
    required this.checkForUpdate,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  late final manga = widget.manga;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    bool? isLocalArchive = manga.isLocalArchive ?? false;

    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final chaptersList = ref.watch(chaptersListttStateProvider);
          final isLongPressed = ref.watch(isLongPressedStateProvider) == true;
          final noContinue =
              isLongPressed || chaptersList.isEmpty || chaptersList.every((element) => element.isRead ?? false);

          if (noContinue) {
            return Container();
          }

          final isExtended = ref.watch(isExtendedStateProvider);
          final history = ref.watch(getMangaHistoryStreamProvider(isManga: manga.isManga!, mangaId: manga.id));

          return history.when(
            data: (data) {
              String buttonLabel = manga.isManga! ? l10n.read : l10n.watch;
              Chapter? chap = manga.chapters.firstOrNull;

              if (data.isNotEmpty) {
                final incognitoMode = ref.watch(incognitoModeStateProvider);

                if (!incognitoMode) {
                  final entry = data.lastOrNull;

                  if (entry != null) {
                    chap = entry.chapter.value!;
                    buttonLabel = l10n.resume;
                  }
                }
              }

              return CustomFloatingActionBtn(
                isExtended: !isExtended,
                label: buttonLabel,
                onPressed: () {
                  chap?.pushToReaderView(context);
                },
                textWidth: measureTextWidth(buttonLabel, Theme.of(context).textTheme.labelLarge!),
                width: measureTextWidth(buttonLabel, Theme.of(context).textTheme.labelLarge!,
                    padding: 50), // 50 Padding, else RenderFlex overflow Exception
              );
            },
            error: (Object error, StackTrace stackTrace) => ErrorText(error),
            loading: () => const ProgressCenter(),
          );
        },
      ),
      body: MangaDetailView(
        titleDescription: isLocalArchive
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.author!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(getMangaStatusIcon(manga.status), size: 14),
                      const SizedBox(width: 4),
                      Text(getMangaStatusName(manga.status, context)),
                      const Text(' • '),
                      Text(manga.source!),
                      Text(' (${manga.lang!.toUpperCase()})'),
                      if (!widget.sourceExist)
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(Icons.warning_amber, color: Colors.deepOrangeAccent, size: 14),
                        )
                    ],
                  )
                ],
              ),
        action: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).scaffoldBackgroundColor, elevation: 0),
          onPressed: () {
            if (manga.favorite!) {
              _favorite(false);
            } else {
              final checkCategoryList =
                  isar.categorys.filter().idIsNotNull().and().forMangaEqualTo(manga.isManga).isNotEmptySync();

              if (checkCategoryList) {
                _openCategory();
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
        manga: manga,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
        sourceExist: widget.sourceExist,
        checkForUpdate: widget.checkForUpdate,
      ),
    );
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

  void _openCategory() {
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

              if (mounted) {
                Navigator.pop(context);
              }
            }

            return AlertDialog(
              title: Text(l10n.set_categories),
              content: SizedBox(
                width: context.width(0.8),
                child: StreamBuilder(
                  stream: isar.categorys
                      .filter()
                      .idIsNotNull()
                      .and()
                      .forMangaEqualTo(manga.isManga)
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container();
                    }

                    final entries = snapshot.data!;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final category = entries[index];
                        final id = category.id;

                        return ListTileChapterFilter(
                          label: category.name!,
                          type: categoryIds.contains(id) ? 1 : 0,
                          onTap: () {
                            setState(() {
                              if (categoryIds.contains(id)) {
                                categoryIds.remove(id);
                              } else {
                                categoryIds.add(id!);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => handleAction(1),
                      child: Text(l10n.edit),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => handleAction(0),
                          child: Text(l10n.cancel),
                        ),
                        const SizedBox(width: 15),
                        TextButton(
                          onPressed: () => handleAction(2),
                          child: Text(l10n.ok),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}
