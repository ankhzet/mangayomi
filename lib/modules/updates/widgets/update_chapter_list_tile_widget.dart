import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/download/download_page_widget.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/manga.dart';

class UpdateChapterListTileWidget extends ConsumerWidget {
  final Chapter chapter;
  final bool sourceExist;
  const UpdateChapterListTileWidget({
    required this.chapter,
    required this.sourceExist,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = chapter.manga.value!;
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: Colors.transparent,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () async {
          chapter.pushToReaderView(context, ignoreIsRead: true);
        },
        onLongPress: () {},
        onSecondaryTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
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
                          child: GestureDetector(
                            onTap: () {
                              context.push('/manga-reader/detail', extra: manga.id);
                            },
                            child: Ink.image(
                              fit: BoxFit.cover,
                              width: 40,
                              height: 45,
                              image: manga.imageProvider(ref),
                              child: InkWell(child: Container()),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(manga.name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: regularColor
                                  )),
                              Text(update.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: chapter.isRead ?? false
                                          ? Colors.grey
                                          : regularColor
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (sourceExist) ChapterPageDownload(chapter: chapter)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
