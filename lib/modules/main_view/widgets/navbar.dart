import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/dto/chapter_group.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/widgets/count_badge.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

const double minVerticalWidth = 100;

class Navbar extends StatelessWidget {
  final bool horizontal;

  const Navbar({
    super.key,
    required this.horizontal,
  });

  static String getHyphenatedUpdatesLabel(String languageCode, String defaultLabel) {
    switch (languageCode) {
      case 'de':
        return "Aktuali-\nsierungen";
      case 'es':
      case 'es_419':
        return "Actuali-\nzaciones";
      case 'it':
        return "Aggiorna-\nmenti";
      case 'tr':
        return "Güncel-\nlemeler";
      default:
        return defaultLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isLongPressed = ref.watch(isLongPressedMangaStateProvider);

      if (isLongPressed || (context.isTablet && horizontal)) {
        return Container();
      }

      final items = _buildItems(context, ref);

      int? locationIndex = _getLocation(context, ref, items);
      int currentIndex = locationIndex ?? 0;

      double? sized(bool horizontal, double value) {
        if (locationIndex == null) {
          return 0;
        }

        if (context.isTablet) {
          return horizontal ? value : null;
        }

        return horizontal ? null : value;
      }

      double? width = sized(true, minVerticalWidth);
      double? height = sized(false, 64);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        width: width,
        height: height,
        child: horizontal
            ? _buildHorizontal(ref: ref, context: context, items: items, index: currentIndex)
            : _buildVertical(ref: ref, context: context, items: items, index: currentIndex),
      );
    });
  }

  Widget _buildHorizontal({
    required WidgetRef ref,
    required BuildContext context,
    required List<NavItem> items,
    required int index,
  }) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: NavigationBar(
        animationDuration: const Duration(milliseconds: 500),
        selectedIndex: index,
        onDestinationSelected: _navigate(context, items),
        destinations: items.map((NavItem item) {
          final widget = NavigationDestination(
            icon: item.icon,
            selectedIcon: item.selectedIcon,
            label: item.label,
          );

          if (item.badge != null) {
            return Stack(
              children: [
                widget,
                Positioned(right: 14, top: 3, child: item.badge!),
              ],
            );
          }

          return widget;
        }).toList(growable: false),
      ),
    );
  }

  Widget _buildVertical({
    required WidgetRef ref,
    required BuildContext context,
    required List<NavItem> items,
    required int index,
  }) {
    final badges = items.indexed
        .map((entry) => entry.$2.badge != null
            ? Positioned(left: minVerticalWidth / 2, top: 4 + entry.$1 * 70, child: entry.$2.badge!)
            : null)
        .whereType<Widget>();

    return Stack(children: [
      NavigationRailTheme(
        data: NavigationRailThemeData(
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: NavigationRail(
          labelType: NavigationRailLabelType.all,
          useIndicator: true,
          selectedIndex: index,
          onDestinationSelected: _navigate(context, items),
          destinations: items
              .map((NavItem item) => NavigationRailDestination(
                    icon: item.icon,
                    selectedIcon: item.selectedIcon,
                    label: Padding(padding: const EdgeInsets.only(top: 5), child: Text(item.label)),
                  ))
              .toList(growable: false),
        ),
      ),
      ...badges,
    ]);
  }

  int? _getLocation(BuildContext context, WidgetRef ref, List<NavItem> items) {
    final location = ref.watch(routerCurrentLocationStateProvider(context));

    if (location == null) {
      return 0;
    }

    final index = items.indexWhere((item) => item.route == location);

    return index < 0 ? null : index;
  }

  void Function(int index) _navigate(BuildContext context, List<NavItem> items) {
    return (int index) => GoRouter.of(context).go(items[index].route);
  }

  List<NavItem> _buildItems<T>(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final lang = ref.watch(l10nLocaleStateProvider).languageCode;

    return [
      NavItem(
        selectedIcon: const Icon(Icons.collections_bookmark),
        icon: const Icon(Icons.collections_bookmark_outlined),
        label: l10n.manga,
        route: '/MangaLibrary',
      ),
      NavItem(
        selectedIcon: const Icon(Icons.video_collection),
        icon: const Icon(Icons.video_collection_outlined),
        label: l10n.anime,
        route: '/AnimeLibrary',
      ),
      NavItem(
        selectedIcon: const Icon(Icons.local_library),
        icon: const Icon(Icons.local_library_outlined),
        label: l10n.novel,
        route: '/NovelLibrary',
      ),
      NavItem(
        selectedIcon: const Icon(Icons.new_releases),
        icon: const Icon(Icons.new_releases_outlined),
        label: context.isTablet ? getHyphenatedUpdatesLabel(lang, l10n.updates) : l10n.updates,
        route: '/updates',
        badge: _updatesTotalNumbers(ref),
      ),
      NavItem(
        selectedIcon: const Icon(Icons.history),
        icon: const Icon(Icons.history_outlined),
        label: l10n.history,
        route: '/history',
      ),
      NavItem(
        selectedIcon: const Icon(Icons.explore),
        icon: const Icon(Icons.explore_outlined),
        label: l10n.browse,
        route: '/browse',
        badge: _extensionUpdateTotalNumbers(ref),
      ),
      NavItem(
        selectedIcon: const Icon(Icons.more_horiz),
        icon: const Icon(Icons.more_horiz_outlined),
        label: l10n.more,
        route: '/more',
      ),
    ];
  }
}

Widget _extensionUpdateTotalNumbers(WidgetRef ref) {
  return StreamBuilder(
    stream: isar.sources.filter().idIsNotNull().and().isActiveEqualTo(true).watch(fireImmediately: true),
    builder: (context, snapshot) => CountBadge(
      count: ((snapshot.hasData && snapshot.data!.isNotEmpty)
          ? snapshot.data!.where((element) => compareVersions(element.version!, element.versionLast!) < 0).length
          : 0),
    ),
  );
}

Widget _updatesTotalNumbers(WidgetRef ref) {
  return StreamBuilder(
    stream: isar.updates
        .filter()
        .idIsNotNull()
        .chapter((q) => q.not().group((q) => q.isReadEqualTo(true).and().idIsNotNull()))
        .watch(fireImmediately: true),
    builder: (context, snapshot) {
      int count = 0;

      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        final groups = ChapterGroup.groupChapters(
          snapshot.data!.map((update) => update.chapter.value).whereType<Chapter>(),
          (Chapter chapter) => '${chapter.mangaId!}-${chapter.order}',
        );

        count = groups.length;
      }

      return CountBadge(
        count: count,
      );
    },

    // builder: (context, snapshot) => UpdateBadge(
    //   count: snapshot.hasData && snapshot.data!.isNotEmpty
    //       ? UpdateGroup.groupUpdates(
    //           snapshot.data!,
    //           (Update update) => '${update.mangaId!}-${update.chapter.value!.order}',
    //         ).length
    //       : 0,
    // ),
  );
}

class NavItem {
  final String route;
  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget? badge;

  const NavItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badge,
  });
}
