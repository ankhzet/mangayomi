import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/type_tab_bar_view.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

enum UpdateInfoType {
  updates,
  updateQueue,
  viewQueue,
}

class UpdateInfoTabs extends ConsumerStatefulWidget {
  final Widget Function(UpdateInfoType type) content;
  final Widget Function(TabBar? tabBar, Widget view) wrap;
  final Tab Function(UpdateInfoType type)? tab;
  final List<UpdateInfoType>? types;
  final void Function(UpdateInfoType type)? onChange;

  const UpdateInfoTabs({
    super.key,
    this.types,
    required this.content,
    required this.wrap,
    this.tab,
    this.onChange,
  });

  @override
  ConsumerState<UpdateInfoTabs> createState() => _UpdateInfoTabsState();
}

class _UpdateInfoTabsState extends ConsumerState<UpdateInfoTabs> {
  @override
  Widget build(BuildContext context) {
    final types = widget.types ?? [UpdateInfoType.updateQueue];

    return switch (types.length) {
      1 => widget.wrap(null, widget.content(types.first)),
      _ => _tabBar(context, types),
    };
  }

  Widget _tabBar(BuildContext context, List<UpdateInfoType> types) {
    final l10n = l10nLocalizations(context)!;
    final tab = widget.tab ?? (UpdateInfoType type) => Tab(text: switch (type) {
      UpdateInfoType.updates => l10n.updates,
      UpdateInfoType.updateQueue => l10n.updateQueue,
      UpdateInfoType.viewQueue => l10n.viewQueue,
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
