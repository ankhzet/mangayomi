import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/options.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/chapter_sort_list_tile_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class ChapterSortType extends ConsumerStatefulWidget {
  final Manga manga;

  const ChapterSortType({super.key, required this.manga});

  @override
  ConsumerState<ChapterSortType> createState() => _ChapterSortTypeState();
}

class _ChapterSortTypeState extends ConsumerState<ChapterSortType> {
  late final manga = widget.manga;
  late final int mangaId;
  late final bool isLocalArchive;

  @override
  void initState() {
    super.initState();
    mangaId = widget.manga.id;
    isLocalArchive = widget.manga.isLocalArchive ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final sort = ref.watch(sortChapterStateProvider(mangaId: mangaId));
        final hasScanlators = ref
            .watch(scanlatorsFilterStateProvider(manga))
            .$1
            .isNotEmpty;

        return Column(
          children: [
            for (var type in SortType.values)
              if (type != SortType.scanlator || hasScanlators)
                ListTileChapterSort(
                  label: _getSortNameByIndex(type, context),
                  reverse: sort.reverse ?? false,
                  onTap: () {
                    ref
                        .read(
                          sortChapterStateProvider(mangaId: mangaId).notifier,
                        )
                        .set(type.index);
                  },
                  showLeading: sort.index == type.index,
                ),
          ],
        );
      },
    );
  }

  String _getSortNameByIndex(SortType type, BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return switch (type) {
      SortType.scanlator => l10n.by_scanlator,
      SortType.number => l10n.by_chapter_number,
      SortType.timestamp => l10n.by_upload_date,
      SortType.name => l10n.by_name,
    };
  }
}
