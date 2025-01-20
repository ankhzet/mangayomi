import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class TypeTabBarView<T> extends ConsumerStatefulWidget {
  final List<T> tabs;
  final Tab Function(T type) tab;
  final Widget Function(T type) content;
  final Widget Function(TabBar? tabBar, Widget view) wrap;
  final void Function(T type)? onChange;

  const TypeTabBarView({
    super.key,
    required this.tabs,
    required this.wrap,
    required this.tab,
    required this.content,
    this.onChange,
  });

  @override
  ConsumerState<TypeTabBarView<T>> createState() => _TypeTabBarState();
}

class _TypeTabBarState<T> extends ConsumerState<TypeTabBarView<T>> with TickerProviderStateMixin {
  late TabController _tabBarController;
  late List<T> types = widget.tabs;

  T get type => types[_tabBarController.index];

  @override
  void initState() {
    _tabBarController = TabController(length: types.length, vsync: this);
    _tabBarController.animateTo(0);

    final onChange = widget.onChange;

    if (onChange != null) {
      _tabBarController.addListener(() => onChange(type));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration.zero,
      length: types.length,
      child: widget.wrap(
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabBarController,
          tabs: types.mapToList(widget.tab),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(
            controller: _tabBarController,
            children: types.mapToList(widget.content),
          ),
        ),
      ),
    );
  }
}
