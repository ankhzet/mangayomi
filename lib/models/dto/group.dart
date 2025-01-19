import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/extensions/others.dart';

bool isRead(Chapter chapter) => chapter.isRead ?? false;

class Group<Item, T> {
  final List<Item> items;
  T group;

  Group(this.items, this.group);

  static T groupBy<T>(Group<dynamic, T> element) => element.group;

  static List<G> groupItems<G extends Group<Item, T>, Item, T>(
    Iterable<Item> items,
    T Function(Item item) groupBy,
    G Function(List<Item> items, T group) makeGroup, {
    bool Function(Item item, G group)? belongsTo,
  }) {
    final List<G> list = [];

    for (final item in items) {
      final group = groupBy(item);
      final bucket = list.firstWhereOrNull(
        (itemGroup) => (itemGroup.group == group) && (belongsTo == null || belongsTo(item, itemGroup)),
      );

      if (bucket != null) {
        bucket.items.add(item);
      } else {
        list.add(makeGroup([item], group));
      }
    }

    return list;
  }

  Item? get first => items.first;

  String get label => first?.toString() ?? '';
}
