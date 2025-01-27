import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/view_queue_item.dart';
import 'package:mangayomi/modules/updates/widgets/update_chapter_list_tile_widget.dart';
import 'package:mangayomi/utils/extensions/view_queue_item.dart';

class QueueChaptersWidget extends ConsumerStatefulWidget {
  final UpdateChaptersGroup update;

  const QueueChaptersWidget({
    super.key,
    required this.update,
  });

  @override
  ConsumerState createState() => _QueueChaptersWidgetState();
}

class _QueueChaptersWidgetState extends ConsumerState<QueueChaptersWidget> {
  late final update = widget.update;
  late final unread = update.firstOrUnread;
  late final mangaId = update.mangaId;
  bool _isQueued = false;

  @override
  void initState() {
    _isQueued = isar.viewQueueItems.isQueuedSync(mangaId);
    super.initState();
  }

  void _queueChapter() async {
    if (_isQueued) {
      return;
    }

    await isar.writeTxn(() async {
      await isar.viewQueueItems.put(ViewQueueItem(
        mangaId: mangaId,
        chapterId: unread.id!,
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
