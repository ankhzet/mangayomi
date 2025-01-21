import 'package:isar/isar.dart';

part 'view_queue_item.g.dart';

@collection
@Name("ViewQueueItem")
class ViewQueueItem {
  Id id;

  @Index(name: 'mangaId')
  int mangaId;

  @Index(name: 'chapterId')
  int chapterId;

  @Index(name: 'timestamp')
  int timestamp;

  ViewQueueItem({
    this.id = Isar.autoIncrement,
    required this.mangaId,
    required this.chapterId,
    required this.timestamp,
  });

  ViewQueueItem.fromJson(Map<String, dynamic> json)
      : id = json['id']!,
        mangaId = json['mangaId']!,
        chapterId = json['chapterId']!,
        timestamp = json['timestamp']!;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mangaId': mangaId,
        'chapterId': chapterId,
        'timestamp': timestamp,
      };
}
