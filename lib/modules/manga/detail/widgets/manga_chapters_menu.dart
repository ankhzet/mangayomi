import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/chapter_filters.dart';
import 'package:mangayomi/modules/manga/detail/chapter_sort_type.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MangaChaptersMenu extends ConsumerStatefulWidget {
  final Manga manga;

  const MangaChaptersMenu({
    super.key,
    required this.manga,
  });

  @override
  ConsumerState<MangaChaptersMenu> createState() => _MangaChaptersMenuState();
}

class _MangaChaptersMenuState extends ConsumerState<MangaChaptersMenu> with TickerProviderStateMixin {
  late final manga = widget.manga;
  late final mangaId = widget.manga.id;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final isNotFiltering = ref.watch(chapterFilterResultStateProvider(manga: manga));

      return IconButton(
        splashRadius: 20,
        onPressed: _showDraggableMenu,
        icon: Icon(
          Icons.filter_list_sharp,
          color: isNotFiltering ? null : Theme.of(context).colorScheme.error,
        ),
      );
    });
  }

  void _showDraggableMenu() {
    final l10n = l10nLocalizations(context)!;

    customDraggableTabBar(
      context: context,
      vsync: this,
      tabs: [
        Tab(text: l10n.filter),
        Tab(text: l10n.sort),
        Tab(text: l10n.display),
      ],
      children: [
        ChapterFilters(manga: manga),
        ChapterSortType(manga: manga),
        Consumer(builder: (context, ref, child) {
          return Column(
            children: [
              RadioListTile(
                dense: true,
                title: Text(l10n.source_title),
                value: "e",
                groupValue: "e",
                selected: true,
                onChanged: (value) {},
              ),
              RadioListTile(
                dense: true,
                title: Text(l10n.chapter_number),
                value: "ej",
                groupValue: "e",
                selected: false,
                onChanged: (value) {},
              ),
            ],
          );
        }),
      ],
    );
  }
}
