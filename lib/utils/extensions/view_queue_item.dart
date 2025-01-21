import 'package:isar/isar.dart';
import 'package:mangayomi/models/view_queue_item.dart';

extension ViewQueueUtils on IsarCollection<ViewQueueItem> {
  Future<bool> isQueued(int chapterId) {
    return where().chapterIdEqualTo(chapterId).isNotEmpty();
  }

  bool isQueuedSync(int chapterId) {
    return where().chapterIdEqualTo(chapterId).isNotEmptySync();
  }

  Map<int, bool> getQueuedSync(Iterable<int> chapters) {
    return where()
        .anyOf(chapters, (q, id) => q.chapterIdEqualTo(id))
        .findAllSync()
        .fold({for (final id in chapters) id: false}, (map, item) => map..[item.chapterId] = true);
  }
}
