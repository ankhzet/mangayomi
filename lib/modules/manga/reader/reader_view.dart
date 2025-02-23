import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/manga_chapter_page_gallery.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/date.dart';

class MangaReaderView extends ConsumerWidget {
  final int chapterId;

  MangaReaderView({super.key, required this.chapterId});

  late final Chapter chapter = isar.chapters.getSync(chapterId)!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterData = ref.watch(getChapterPagesProvider(chapter: chapter));
    final isExternalSource = (chapter.manga.value!.isLocalArchive ?? false) == false;

    try {
      return chapterData.when(
        data: (data) {
          if (isExternalSource && data.pageUrls.isEmpty) {
            throw AssertionError('Failed to load');
          }

          return MangaChapterPageGallery(chapter: chapter, chapterUrlModel: data);
        },
        error: (error, stackTrace) => throw error,
        loading: () => _scaffold(context: context, body: const ProgressCenter()),
      );
    } catch (error) {
      var errorText = error.toString();
      final match = RegExp(r'Chapter would be published ([^\n]+)', caseSensitive: false).firstMatch(errorText);

      if (match != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(int.parse(match[1]!));
        final dateStr = dateFormat(
          null,
          datetimeDate: date,
          ref: ref,
          context: context,
          showHourOrMinute: true,
          useRelativeTimesTamps: false,
          // dateFormat: 'yyyy/MM/dd HH:mm',
        );
        final relative = dateFormat(
          null,
          datetimeDate: date,
          ref: ref,
          context: context,
          showHourOrMinute: true,
          useRelativeTimesTamps: true,
        );
        errorText = 'Chapter is scheduled to release:\n$dateStr ($relative)';
      } else if (kDebugMode) {
        print(error);
      }

      return _scaffold(context: context, body: Center(child: Text(errorText)));
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
