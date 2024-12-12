import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';

class ChaptersFix extends ConsumerStatefulWidget {
  final Manga manga;
  final List<Chapter> duplicates;

  const ChaptersFix({
    super.key,
    required this.manga,
    required this.duplicates,
  });

  @override
  ConsumerState createState() => _ChaptersFixState();
}

class _ChaptersFixState extends ConsumerState<ChaptersFix> with AutomaticKeepAliveClientMixin<ChaptersFix> {
  void _deleteDuplicates() async {
    setState(() {
      _isStarted = true;
    });

    try {
      final duplicates = widget.duplicates.map((chapter) => chapter.id!).toList(growable: false);

      await isar.writeTxn(() async {
        await isar.updates.where().filter().chapter((q) => q.oneOf(duplicates, (q, id) => q.idEqualTo(id))).deleteAll();
        await isar.historys.where().filter().oneOf(duplicates, (q, id) => q.chapterIdEqualTo(id)).deleteAll();
        await isar.chapters.deleteAll(duplicates);
      });
    } finally {
      setState(() {
        _isStarted = false;
      });
    }
  }

  void _deleteUpdate() async {
    setState(() {
      _isStarted = true;
    });

    try {
      await isar.writeTxn(() async {
        await isar.updates.where().filter().mangaIdEqualTo(widget.manga.id).deleteAll();
        await isar.historys.where().filter().mangaIdEqualTo(widget.manga.id).deleteAll();
        await isar.chapters.where().filter().mangaIdEqualTo(widget.manga.id).deleteAll();
      });
    } finally {
      setState(() {
        _isStarted = false;
      });
    }
  }

  late final chapters = widget.manga.chapters;
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      height: 41,
      width: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: IconButton(
          splashRadius: 5,
          iconSize: 17,
          onPressed: () {
            if (widget.duplicates.isNotEmpty) {
              _deleteDuplicates();
            }

            if (widget.manga.favorite != true) {
              _deleteUpdate();
            }
          },
          icon: _fixWidget(context, widget.duplicates.length, _isStarted),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _fixWidget(BuildContext context, int items, bool isLoading) {
  final color = Theme.of(context).iconTheme.color!.withOpacity(0.7);

  return Stack(
    children: [
      Align(
          alignment: Alignment.center,
          child: Icon(
            size: 12,
            Icons.medical_services_outlined,
            color: color,
          )),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            value: isLoading ? null : 1,
            color: color,
            strokeWidth: 2,
          ),
        ),
      ),
      Align(
        alignment: const Alignment(2, 2),
        child: Badge(
            backgroundColor: Theme.of(context)
                .badgeTheme
                .backgroundColor,
            textColor: Theme.of(context)
                .badgeTheme
                .textColor,
            smallSize: 8,
            largeSize: 8,
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            label: Text(items > 0 ? items.toString() : '!', style: const TextStyle(fontSize: 6))
        ),
      ),
    ],
  );
}
