import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/utils/extensions/others.dart';

bool isRead(Chapter chapter) => chapter.isRead ?? false;

typedef StateListener<State> = void Function(State next);

class Provider<State> {
  List<StateListener<State>>? _listeners;
  State _state;

  Provider(State state): _state = state;

  State get state => _state;

  set state(State state) {
    if (_state == state) {
      return;
    }

    _state = state;

    if (_listeners != null) {
      for (final listener in _listeners!) {
        listener(state);
      }
    }
  }

  Function() addListener(StateListener<State> listener, { bool fireImmediately = false }) {
    if (_listeners == null) {
      _listeners = [listener];
    } else {
      _listeners!.add(listener);
    }

    if (fireImmediately) {
      listener(state);
    }

    return () {
      if (_listeners != null) {
        _listeners!.remove(listener);
      }
    };
  }

  void close() {
    _listeners = null;
  }
}

class Group<Item, T> extends Provider<List<Item>> {
  T group;

  Group(super.state, this.group);

  bool get isEmpty => state.isEmpty;
  bool get isNotEmpty => state.isNotEmpty;
  Item? get first => state.first;
  String get label => first?.toString() ?? '';

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
        bucket.state.add(item);
      } else {
        list.add(makeGroup([item], group));
      }
    }

    return list;
  }

  void clear() {
    state = [];
  }
}

class GroupChanges<Item, T> extends ConsumerStatefulWidget {
  final Group <Item, T> group;
  final Widget child;

  const GroupChanges(this.group, { super.key, required this.child });

  @override
  ConsumerState createState() => _GroupChangesState();
}

class _GroupChangesState<Item, T> extends ConsumerState<GroupChanges<Item, T>> {
  final StreamController<List<Item>> ctl = StreamController<List<Item>>.broadcast();

  @override
  void initState() {
    super.initState();
    widget.group.addListener((_) {
      ctl.add(widget.group.state);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: ctl.stream, builder: (_, _) => widget.child);
  }
}
