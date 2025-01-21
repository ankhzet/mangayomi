import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/manga_chapter_page_gallery.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

class MangaReaderView extends ConsumerWidget {
  final Chapter chapter;

  const MangaReaderView({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterData = ref.watch(getChapterPagesProvider(chapter: chapter));
    final isLocalArchive = (chapter.manga.value!.isLocalArchive ?? false) == false;

    try {
      return chapterData.when(
        data: (data) {
          if (isLocalArchive) {
            if (data.pageUrls.isEmpty) {
              throw AssertionError('Failed to load');
            }
          } else {
            if (data.pageUrls.every((task) => task.isValid)) {}
          }

          return MangaChapterPageGallery(chapter: chapter, chapterUrlModel: data);
        },
        error: (error, stackTrace) => throw error,
        loading: () => _scaffold(context: context, body: const ProgressCenter()),
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      return _scaffold(context: context, body: Center(child: Text(error.toString())));
    }
  }

  _scaffold({required BuildContext context, required Widget body, bool systemUI = false}) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(chapter.manga.value!.name ?? 'Loading error'),
        leading: BackButton(
          onPressed: () {
            if (systemUI) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
            }

            Navigator.pop(context);
          },
        ),
      ),
      body: body,
    );
  }
}
