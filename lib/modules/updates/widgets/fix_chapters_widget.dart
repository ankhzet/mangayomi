import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/utils/extensions/manga.dart';

class ChaptersFix extends ConsumerStatefulWidget {
  final ChapterGroup update;

  const ChaptersFix({
    super.key,
    required this.update,
  });

  @override
  ConsumerState createState() => _ChaptersFixState();
}

class _ChaptersFixState extends ConsumerState<ChaptersFix> {
  late final update = widget.update;
  late final manga = update.manga;
  late final favorite = manga.favorite ?? false;
  bool _isStarted = false;

  void _deleteChapters(Iterable<Chapter> chapters) async {
    setState(() {
      _isStarted = true;
    });

    try {
      final ids = chapters.map((chapter) => chapter.id!).toList(growable: false);

      await isar.writeTxn(() async {
        await isar.updates.where().filter().chapter((q) => q.oneOf(ids, (q, id) => q.idEqualTo(id))).deleteAll();
        await isar.historys.where().filter().oneOf(ids, (q, id) => q.chapterIdEqualTo(id)).deleteAll();
        await isar.chapters.deleteAll(ids);
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
        await isar.updates.where().filter().mangaIdEqualTo(manga.id).deleteAll();
        await isar.historys.where().filter().mangaIdEqualTo(manga.id).deleteAll();
        await isar.chapters.where().filter().mangaIdEqualTo(manga.id).deleteAll();
      });
    } finally {
      setState(() {
        _isStarted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: manga.chapters.filter().watch(fireImmediately: true),
      builder: (context, snapshot) {
        final List<Chapter> chapters = snapshot.hasData ? snapshot.data! : [];
        final List<Chapter> duplicates = manga.getDuplicateChapters(all: chapters);
        final List<Chapter> unread = manga.getUnreadChapters(update.items, all: chapters);
        final List<Chapter> ghosts =
            chapters.where((chapter) => chapter.name == null || chapter.name!.isEmpty).toList();
        final int readUpdates = update.items.length - unread.length;

        if (duplicates.isEmpty && ghosts.isEmpty && (readUpdates <= 0) && favorite) {
          return Container();
        }

        return SizedBox(
          height: 41,
          width: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: IconButton(
              splashRadius: 5,
              iconSize: 17,
              onPressed: () {
                if (!favorite) {
                  _deleteUpdate();
                }

                if (duplicates.isNotEmpty) {
                  _deleteChapters(duplicates);
                }

                if (ghosts.isNotEmpty) {
                  _deleteChapters(ghosts);
                }

                if (readUpdates > 0) {
                  _deleteChapters(update.items.where((chapter) => !unread.any((item) => item.id == chapter.id)));
                }
              },
              icon: _fixWidget(
                context,
                duplicates.length + ghosts.length + readUpdates,
                _isStarted,
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _fixWidget(BuildContext context, int items, bool isLoading) {
  final color = Theme.of(context).iconTheme.color!.withValues(alpha: 0.7);

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
            backgroundColor: Theme.of(context).badgeTheme.backgroundColor,
            textColor: Theme.of(context).badgeTheme.textColor,
            smallSize: 8,
            largeSize: 8,
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
            label: Text(items > 0 ? items.toString() : '!', style: const TextStyle(fontSize: 6))),
      ),
    ],
  );
}
