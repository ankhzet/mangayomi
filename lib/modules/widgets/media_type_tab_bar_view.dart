import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/type_tab_bar_view.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MediaTabs extends ConsumerStatefulWidget {
  final Widget Function(bool isManga) content;
  final Widget Function(TabBar? tabBar, Widget view) wrap;
  final Tab Function(bool isManga)? tab;
  final List<bool>? types;
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
    final types = widget.types ?? defaultTypes;

    return switch (types.length) {
      0 => _tabBar(context, defaultTypes),
      <= 1 => widget.wrap(null, widget.content(types.first)),
      _ => _tabBar(context, types),
    };
  }

  Widget _tabBar(BuildContext context, List<bool> types) {
    final l10n = l10nLocalizations(context)!;
    final tab = widget.tab ?? (bool type) => Tab(text: (type == true) ? l10n.manga : l10n.anime);

    return TypeTabBarView(
      tabs: types,
      tab: tab,
      content: widget.content,
      wrap: widget.wrap,
      onChange: widget.onChange,
    );
  }
}
