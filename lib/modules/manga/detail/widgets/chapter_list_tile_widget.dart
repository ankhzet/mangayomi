import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

class ChapterListTileWidget extends ConsumerWidget {
  final Manga manga;
  final ChapterGroup group;
  final bool sourceExist;
  final bool isSelected;

  const ChapterListTileWidget({
    required this.manga,
    required this.group,
    required this.sourceExist,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final isLongPressed = ref.watch(isLongPressedStateProvider);
    final isLocalArchive = manga.isLocalArchive ?? false;
    final isBookmarked = group.isAnyBookmarked;
    final isRead = group.isAnyRead;
    final chapter = group.firstOrRead;
    final hasScanlators = group.hasAnyScanlators;
    final progress = isRead ? '' : chapter.progress();
    final dateUpload = !isLocalArchive ? group.dateUpload : null;
    final textColor = context.isLight ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.3);

    return Container(
      color: isSelected ? context.primaryColor.withValues(alpha: 0.4) : null,
      child: ListTile(
        textColor: isRead ? textColor : null,
        selectedColor: isRead ? Colors.white.withValues(alpha: 0.3) : Colors.white,
        onLongPress: () {
          ref.read(chaptersListStateProvider.notifier).updateAll(group.items);

          if (!isLongPressed) {
            ref.read(isLongPressedStateProvider.notifier).update(true);
          }
        },
        onTap: () async {
          if (isLongPressed) {
            ref.read(chaptersListStateProvider.notifier).updateAll(group.items);
          } else {
            chapter.pushToReaderView(context, ignoreIsRead: true);
          }
        },
        title: Row(
          children: [
            if (isBookmarked) Icon(Icons.bookmark, size: 16, color: context.primaryColor),
            Flexible(
              child: Text(
                group.fullTitle,
                style: const TextStyle(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: SeparatedRow(
          separator: const Text(' • '),
          children: [
            if (dateUpload != null)
              Text(
                dateFormat(null, datetimeDate: dateUpload, ref: ref, context: context),
                style: const TextStyle(fontSize: 11),
              ),
            if (progress.isNotEmpty)
              Text(
                manga.itemType == ItemType.anime ? l10n.episode_progress(progress) : l10n.page(progress),
                style: TextStyle(fontSize: 11, color: textColor),
              ),
            if (hasScanlators)
              Flexible(
                child: Text(
                  group.scanlators,
                  style: TextStyle(fontSize: 11, color: isRead ? textColor : null),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        trailing: sourceExist && !isLocalArchive ? ChapterPageDownload(chapter: chapter) : null,
      ),
    );
  }
}
