import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/view_queue_item.dart';
import 'package:mangayomi/utils/extensions/view_queue_item.dart';

class QueueChaptersWidget extends ConsumerStatefulWidget {
  final Chapter chapter;

  const QueueChaptersWidget({
    super.key,
    required this.chapter,
  });

  @override
  ConsumerState createState() => _QueueChaptersWidgetState();
}

class _QueueChaptersWidgetState extends ConsumerState<QueueChaptersWidget> {
  late final chapter = widget.chapter;
  late final manga = chapter.manga.value!;
  bool _isQueued = false;

  @override
  void initState() {
    _isQueued = isar.viewQueueItems.isQueuedSync(chapter.id!);
    super.initState();
  }

  void _queueChapter() async {
    if (_isQueued) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.viewQueueItems.put(ViewQueueItem(
        mangaId: manga.id,
        chapterId: chapter.id!,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    });

    setState(() {
      _isQueued = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      width: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: IconButton(
          splashRadius: 5,
          iconSize: 17,
          onPressed: _queueChapter,
          icon: Icon(
            _isQueued ? Icons.playlist_add_check : Icons.queue_outlined,
            color: _isQueued
                ? Theme.of(context).buttonTheme.colorScheme!.primary
                : Theme.of(context).iconTheme.color!.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
