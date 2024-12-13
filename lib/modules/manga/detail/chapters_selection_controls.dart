import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ChaptersSelectionBar extends ConsumerStatefulWidget {
  final Manga manga;
  final List<Chapter> chapters;
  final List<Chapter> selection;

  const ChaptersSelectionBar({
    super.key,
    required this.manga,
    required this.chapters,
    required this.selection,
  });

  @override
  ConsumerState<ChaptersSelectionBar> createState() => _ChaptersSelectionBarState();
}

class _ChaptersSelectionBarState extends ConsumerState<ChaptersSelectionBar> {
  late final mangaId = widget.manga.id;

  void _selectAll() {
    ref.read(chaptersListStateProvider.notifier).selectAll(widget.chapters);
  }

  void _toggleSelection() {
    ref.read(chaptersListStateProvider.notifier).toggle(widget.chapters);
  }

  void _clearSelection() {
    ref.read(chaptersListStateProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: AppBar(
          title: Text(widget.selection.length.toString()),
          backgroundColor: context.primaryColor.withOpacity(0.2),
          leading: IconButton(onPressed: _clearSelection, icon: const Icon(Icons.clear)),
          actions: [
            IconButton(onPressed: _selectAll, icon: const Icon(Icons.select_all)),
            IconButton(onPressed: _toggleSelection, icon: const Icon(Icons.flip_to_back_rounded)),
          ],
        ),
      ),
    );
  }
}
