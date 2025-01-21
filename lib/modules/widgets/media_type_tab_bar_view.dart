import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/widgets/type_tab_bar_view.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class MediaTabs extends ConsumerStatefulWidget {
  final Widget Function(ItemType type) content;
  final Widget Function(TabBar? tabBar, Widget view) wrap;
  final Tab Function(ItemType type)? tab;
  final List<ItemType>? types;
  final List<ItemType>? defaultTypes;
  final void Function(ItemType type)? onChange;

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
  late List<ItemType> defaultTypes = widget.defaultTypes ?? [ItemType.manga, ItemType.anime, ItemType.novel];

  @override
  Widget build(BuildContext context) {
    final types = widget.types ?? defaultTypes;

    return switch (types.length) {
      0 => _tabBar(context, defaultTypes),
      <= 1 => widget.wrap(null, widget.content(types.first)),
      _ => _tabBar(context, types),
    };
  }

  Widget _tabBar(BuildContext context, List<ItemType> types) {
    final l10n = l10nLocalizations(context)!;
    final tab = widget.tab ??
        (ItemType type) => Tab(
                text: switch (type) {
              ItemType.manga => l10n.manga,
              ItemType.anime => l10n.anime,
              ItemType.novel => l10n.novel,
            });

    return TypeTabBarView(
      tabs: types,
      tab: tab,
      content: widget.content,
      wrap: widget.wrap,
      onChange: widget.onChange,
    );
  }
}
