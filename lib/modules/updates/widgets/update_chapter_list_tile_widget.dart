import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/update_group.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/tv_row_button.dart';

class UpdateChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final bool sourceExist;
  final UpdateGroup<int?>? chapterGroup;
  const UpdateChapterListTileWidget({
    required this.chapter,
    required this.sourceExist,
    this.chapterGroup,
    super.key,
  });

  /// The cover, title and chapter name: the row's main target.
  Widget _body(BuildContext context, WidgetRef ref, Manga manga) {
    final chapterLabel = chapterGroup?.label ?? chapter.name ?? '';
    final uniqueChapterCount = chapterGroup != null
        ? chapterGroup!.chapters.map((c) => c.compositeOrder).toSet().length
        : 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: manga.customCoverImage != null
                  ? MemoryImage(manga.customCoverImage as Uint8List) as ImageProvider
                  : CustomExtendedNetworkImageProvider(
                      toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl!),
                      headers: ref.watch(
                        headersProvider(
                          source: manga.source!,
                          lang: manga.lang!,
                          sourceId: manga.sourceId,
                        ),
                      ),
                    ),
              fit: BoxFit.cover,
              width: 40,
              height: 45,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manga.name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                Text(
                  uniqueChapterCount > 1
                      ? '$chapterLabel ($uniqueChapterCount chapters)'
                      : chapterLabel,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: chapter.isRead ?? false ? Colors.grey : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChapterSelection(BuildContext context, UpdateGroup<int?> group) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: group.chapters.length,
          itemBuilder: (context, index) {
            final ch = group.chapters[index];
            return ListTile(
              title: Text(ch.name ?? ''),
              subtitle: Text(ch.scanlator ?? ''),
              onTap: () {
                Navigator.pop(context);
                ch.pushToReaderView(context, ignoreIsRead: true);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = chapter.manga.value!;
    // Two focusable targets on TV, matching the Browse source rows: the entry
    // itself, and its download control. The cover's tap-to-detail is folded
    // into the entry, since a third stop for it would only slow the remote
    // down, and the detail is a press away from the reader anyway.
    final chapterCount = chapterGroup?.chapters.length ?? 1;

    void handleTap() {
      if (chapterGroup != null && chapterCount > 1) {
        _showChapterSelection(context, chapterGroup!);
      } else {
        chapter.pushToReaderView(context, ignoreIsRead: true);
      }
    }

    if (isTv) {
      return TvListRow(
        children: [
          Expanded(
            child: TvRowButton(
              onTap: handleTap,
              child: _body(context, ref, manga),
            ),
          ),
          if (sourceExist)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChapterPageDownload(chapter: chapter),
            ),
        ],
      );
    }
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        focusColor: isTv ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2) : null,
        onTap: handleTap,
        onLongPress: () {},
        onSecondaryTap: () {},
        child: Row(
          children: [
            Expanded(child: _body(context, ref, manga)),
            if (sourceExist)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChapterPageDownload(chapter: chapter),
              ),
          ],
        ),
      ),
    );
  }
}
