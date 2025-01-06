import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MediaTabs extends ConsumerStatefulWidget {
  final Widget Function(bool isManga) content;
  final Widget Function(TabBar? tabBar, Widget view) wrap;
  final AsyncValue<List<bool>>? types;
  final Tab Function(bool isManga)? tab;
  final List<bool>? defaultTypes;
  final void Function(bool isManga)? onChange;

  const MediaTabs({
    super.key,
    this.types,
    required this.content,
    required this.wrap,
    this.tab,
    this.defaultTypes,
    this.onChange,
  });

  @override
  ConsumerState<MediaTabs> createState() => _MediaTabsState();
}

class _MediaTabsState extends ConsumerState<MediaTabs> {
  late List<bool> defaultTypes = widget.defaultTypes ?? [true, false];

  @override
  Widget build(BuildContext context) {
    final async = widget.types;

    if (async != null) {
      return async.when(
        data: (types) => switch (types.length) {
          0 => _tabBar(context, defaultTypes),
          <= 1 => widget.wrap(null, widget.content(types.first)),
          _ => _tabBar(context, types),
        },
        error: (Object error, StackTrace stackTrace) => ErrorText(error),
        loading: () => const ProgressCenter(),
      );
    }

    return _tabBar(context, defaultTypes);
  }

  Widget _tabBar(BuildContext context, List<bool> types) {
    final l10n = l10nLocalizations(context)!;
    final tab = widget.tab ?? (bool type) => Tab(text: (type == true) ? l10n.manga : l10n.anime);

    return TypeTabBarView<bool>(
      types: types,
      tab: tab,
      content: widget.content,
      wrap: widget.wrap,
      onChange: widget.onChange,
    );
  }
}

class TypeTabBarView<T> extends ConsumerStatefulWidget {
  final List<T> types;
  final Tab Function(T type) tab;
  final Widget Function(T type) content;
  final Widget Function(TabBar? tabBar, Widget view) wrap;
  final void Function(T type)? onChange;

  const TypeTabBarView({
    super.key,
    required this.types,
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
  late List<T> types = widget.types;

  @override
  void initState() {
    _tabBarController = TabController(length: types.length, vsync: this);
    _tabBarController.animateTo(0);

    final onChange = widget.onChange;

    if (onChange != null) {
      _tabBarController.addListener(() => onChange(getTypeByIndex(index)));
    }

    super.initState();
  }

  get index => _tabBarController.index;

  getTypeByIndex(int index) {
    return types[index];
  }

  @override
  Widget build(BuildContext context) {
    return widget.wrap(
      TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabBarController,
        tabs: types.map(widget.tab).toList(growable: false),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TabBarView(
          controller: _tabBarController,
          children: types.map(widget.content).toList(growable: false),
        ),
      ),
    );
  }
}
