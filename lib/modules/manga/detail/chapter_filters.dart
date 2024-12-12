import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_filter_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ChapterFilters extends ConsumerStatefulWidget {
  final Manga manga;

  const ChapterFilters({
    super.key,
    required this.manga,
  });

  @override
  ConsumerState<ChapterFilters> createState() => _ChapterFiltersState();
}

class _ChapterFiltersState extends ConsumerState<ChapterFilters> {
  late final manga = widget.manga;
  late final mangaId = widget.manga.id!;
  late final isLocalArchive = widget.manga.isLocalArchive ?? false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final l10n = l10nLocalizations(context)!;
      final scanlators = ref.watch(scanlatorsFilterStateProvider(manga));

      return Column(
        children: [
          if (!isLocalArchive)
            ListTileChapterFilter(
              label: l10n.downloaded,
              type: ref.watch(chapterFilterDownloadedStateProvider(mangaId: mangaId)).type!,
              onTap: () {
                ref.read(chapterFilterDownloadedStateProvider(mangaId: mangaId).notifier).update();
              },
            ),
          ListTileChapterFilter(
            label: l10n.unread,
            type: ref.watch(chapterFilterUnreadStateProvider(mangaId: mangaId)).type!,
            onTap: () {
              ref.read(chapterFilterUnreadStateProvider(mangaId: mangaId).notifier).update();
            },
          ),
          ListTileChapterFilter(
            label: l10n.bookmarked,
            type: ref.watch(chapterFilterBookmarkedStateProvider(mangaId: mangaId)).type!,
            onTap: () {
              ref.read(chapterFilterBookmarkedStateProvider(mangaId: mangaId).notifier).update();
            },
          ),
          if (scanlators.$1.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(context: context, builder: _buildScanlatorsDialog);
                      },
                      child: Text(l10n.filter_scanlator_groups),
                    ),
                  ),
                ],
              ),
            )
        ],
      );
    });
  }

  Widget _buildScanlatorsDialog(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final scanlators = ref.watch(scanlatorsFilterStateProvider(manga));
      final l10n = l10nLocalizations(context)!;

      return AlertDialog(
        title: Text(l10n.filter_scanlator_groups),
        content: SizedBox(
          width: context.width(0.8),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: scanlators.$1.length,
            itemBuilder: (context, index) => ListTileChapterFilter(
              label: scanlators.$1[index],
              type: scanlators.$3.contains(scanlators.$1[index]) ? 2 : 0,
              onTap: () {
                ref
                    .read(scanlatorsFilterStateProvider(manga).notifier)
                    .setFilteredList(scanlators.$1[index]);
              },
            ),
          ),
        ),
        actions: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            ref.read(scanlatorsFilterStateProvider(manga).notifier).set([]);
                            Navigator.pop(context);
                          },
                          child: Text(
                            l10n.reset,
                            style: TextStyle(color: context.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          l10n.cancel,
                          style: TextStyle(color: context.primaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(scanlatorsFilterStateProvider(manga).notifier)
                              .set(scanlators.$3);
                          Navigator.pop(context);
                        },
                        child: Text(
                          l10n.filter,
                          style: TextStyle(color: context.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      );
    });
  }
}
