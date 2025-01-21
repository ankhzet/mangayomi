import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/manga/detail/widgets/custom_floating_action_btn.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/consumer_state.dart';

class MangaDetailsView extends ConsumerStatefulWidget {
  final Manga manga;
  final bool sourceExist;
  final Function(bool) checkForUpdate;

  const MangaDetailsView({
    super.key,
    required this.sourceExist,
    required this.manga,
    required this.checkForUpdate,
  });

  @override
  ConsumerState<MangaDetailsView> createState() => _MangaDetailsViewState();
}

class _MangaDetailsViewState extends ConsumerState<MangaDetailsView> {
  late final manga = widget.manga;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return Scaffold(
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final chaptersList = ref.watch(chaptersListttStateProvider);
          final isLongPressed = ref.watch(isLongPressedStateProvider) == true;
          final noContinue =
              isLongPressed || chaptersList.isEmpty || chaptersList.every((element) => element.isRead ?? false);

          if (noContinue) {
            return Container();
          }

          final isExtended = ref.watch(isExtendedStateProvider);
          final history = ref.watch(getMangaHistoryStreamProvider(isManga: manga.isManga!, mangaId: manga.id));

          return history.when(
            data: (data) {
              String buttonLabel = manga.isManga! ? l10n.read : l10n.watch;
              Chapter? chap = manga.chapters.firstOrNull;

              if (data.isNotEmpty) {
                final incognitoMode = ref.watch(incognitoModeStateProvider);

                if (!incognitoMode) {
                  final entry = data.lastOrNull;

                  if (entry != null) {
                    chap = entry.chapter.value!;
                    buttonLabel = l10n.resume;
                  }
                }
              }

              return CustomFloatingActionBtn(
                isExtended: !isExtended,
                label: buttonLabel,
                onPressed: () {
                  chap?.pushToReaderView(context);
                },
                textWidth: measureTextWidth(buttonLabel, Theme.of(context).textTheme.labelLarge!),
                width: measureTextWidth(buttonLabel, Theme.of(context).textTheme.labelLarge!,
                    padding: 50), // 50 Padding, else RenderFlex overflow Exception
              );
            },
            error: (Object error, StackTrace stackTrace) => ErrorText(error),
            loading: () => const ProgressCenter(),
          );
        },
      ),
      body: MangaDetailView(
        manga: manga,
        isExtended: (value) {
          ref.read(isExtendedStateProvider.notifier).update(value);
        },
        sourceExist: widget.sourceExist,
        checkForUpdate: widget.checkForUpdate,
        itemType: widget.manga.itemType,
      ),
    );
  }
}
