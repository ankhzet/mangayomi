import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/main_view/widgets/navbar.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/fetch_anime_sources.dart';
import 'package:mangayomi/services/fetch_manga_sources.dart';
import 'package:mangayomi/services/fetch_novel_sources.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.content});

  final Widget content;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final navigationOrder = ref.watch(navigationOrderStateProvider);
  late final autoSyncFrequency = ref.watch(synchingProvider(syncId: 1)).autoSyncFrequency;
  late String? location = ref.watch(routerCurrentLocationStateProvider(context));
  late String defaultLocation = navigationOrder.first;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(defaultLocation);

      Timer.periodic(Duration(minutes: 5), (timer) {
        ref.read(checkAndBackupProvider);
      });

      if (autoSyncFrequency != 0) {
        final l10n = l10nLocalizations(context)!;
        Timer.periodic(Duration(seconds: autoSyncFrequency), (timer) {
          try {
            ref.read(syncServerProvider(syncId: 1).notifier).startSync(l10n, true);
          } catch (e) {
            botToast("Failed to sync! Maybe the sync server is down. Restart the app to resume auto sync.");
            timer.cancel();
          }
        });
      }

      ref.watch(checkForUpdateProvider(context: context));
      ref.watch(fetchMangaSourcesListProvider(id: null, reFresh: false));
      ref.watch(fetchAnimeSourcesListProvider(id: null, reFresh: false));
      ref.watch(fetchNovelSourcesListProvider(id: null, reFresh: false));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final hideItems = ref.watch(hideItemsStateProvider);

    return ref.watch(migrationProvider).when(data: (_) {
      return Consumer(builder: (context, ref, _) {
        final location = ref.watch(routerCurrentLocationStateProvider(context));
        bool isReadingScreen = location == '/mangareaderview' || location == '/animePlayerView' || location == '/novelReaderView';

        final dest = navigationOrder.where((nav) => !hideItems.contains(nav)).toList();

        int currentIndex = dest.indexOf(location ?? defaultLocation);
        if (currentIndex == -1) {
          currentIndex = dest.length - 1;
        }

        final incognitoMode = ref.watch(incognitoModeStateProvider);

        return Column(
          children: [
            if (!isReadingScreen)
              Material(
                child: AnimatedContainer(
                  height: incognitoMode
                      ? Platform.isAndroid || Platform.isIOS
                          ? MediaQuery.of(context).padding.top * 2
                          : 50
                      : 0,
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 150),
                  color: context.primaryColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          l10n.incognito_mode,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: GoogleFonts.aBeeZee().fontFamily,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            Flexible(
              child: Scaffold(
                body: context.isTablet
                    ? Row(
                        children: [const Navbar(horizontal: false), Expanded(child: content)],
                      )
                    : content,
                bottomNavigationBar: context.isTablet ? null : const Navbar(horizontal: true),
              ),
            ),
          ],
        );
      });
    }, error: (error, _) {
      return const LoadingIcon();
    }, loading: () {
      return const LoadingIcon();
    });
  }
}
