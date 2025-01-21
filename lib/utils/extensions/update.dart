import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/update.dart';

extension UpdateExtension on IsarCollection<Update> {
  int deleteForChaptersSync(int mangaId, Iterable<int> ids) {
    return isar.writeTxnSync(() => isar.updates
        .where()
        .filter()
        .mangaIdEqualTo(mangaId)
        .and()
        .chapter((q) => q.anyOf(ids, (q, id) => q.idEqualTo(id)))
        .deleteAllSync());
  }
}
