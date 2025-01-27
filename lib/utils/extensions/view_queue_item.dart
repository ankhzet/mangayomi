import 'package:isar/isar.dart';
import 'package:mangayomi/models/view_queue_item.dart';

extension ViewQueueIterableUtils on Iterable<ViewQueueItem> {
  Map<int, bool> mapQueueItems(Iterable<int> entities) {
    return fold({for (final id in entities) id: false}, (map, item) => map..[item.mangaId] = true);
  }
}

extension ViewQueueUtils on IsarCollection<ViewQueueItem> {
  Future<bool> isQueued(int mangaId) {
    return where().mangaIdEqualTo(mangaId).isNotEmpty();
  }

  bool isQueuedSync(int mangaId) {
    return where().mangaIdEqualTo(mangaId).isNotEmptySync();
  }

  QueryBuilder<ViewQueueItem, ViewQueueItem, QAfterWhereClause> queryQueued(Iterable<int> entities) {
    return where().anyOf(entities, (q, id) => q.mangaIdEqualTo(id));
  }

  Map<int, bool> getQueuedSync(Iterable<int> entities) {
    return queryQueued(entities).findAllSync().mapQueueItems(entities);
  }
}
