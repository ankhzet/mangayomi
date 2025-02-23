import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/manga_chapter_page_gallery.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/date.dart';

class MangaReaderView extends ConsumerWidget {
  final int chapterId;

  const MangaReaderView({
    super.key,
    required this.chapterId,
  });

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

class _CustomValueIndicatorShape extends SliderComponentShape {
  final _indicatorShape = const PaddleSliderValueIndicatorShape();
  final bool tranform;

  const _CustomValueIndicatorShape({this.tranform = false});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(40, 40);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final textSpan = TextSpan(
      text: labelPainter.text?.toPlainText(),
      style: sliderTheme.valueIndicatorTextStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: labelPainter.textAlign,
      textDirection: textDirection,
    );

    textPainter.layout();

    context.canvas.save();
    context.canvas.translate(center.dx, center.dy);
    context.canvas.scale(tranform ? -1.0 : 1.0, 1.0);
    context.canvas.translate(-center.dx, -center.dy);

    _indicatorShape.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      labelPainter: textPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
    );

    context.canvas.restore();
  }
}
