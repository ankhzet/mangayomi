import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/widgets/genre_badges_widget.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_actions.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_chapters_counter.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_cover.dart';
import 'package:mangayomi/modules/manga/detail/widgets/readmore.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class MangaInfo extends ConsumerStatefulWidget {
  final Manga manga;
  final int chapters;
  final bool sourceExist;

  const MangaInfo({
    super.key,
    required this.manga,
    required this.sourceExist,
    required this.chapters,
  });

  @override
  ConsumerState<MangaInfo> createState() => _MangaInfoState();
}

class _MangaInfoState extends ConsumerState<MangaInfo> with TickerProviderStateMixin {
  final offsetProvider = StateProvider((ref) => 0.0);
  late final isLocalArchive = widget.manga.isLocalArchive ?? false;
  late final manga = widget.manga;
  late final mangaId = manga.id;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.05),
                Theme.of(context).scaffoldBackgroundColor
              ],
              stops: const [0, .3],
            ),
          ),
        ),
        Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: context.width(1),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
                        child: MangaCover(
                          manga: manga,
                          width: 65 * 1.5,
                          height: 65 * 2.3,
                        ),
                      ),
                      Expanded(child: _titles()),
                    ],
                  ),
                ),
                if (isLocalArchive)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: _editLocalArchiveInfos,
                      icon: const CircleAvatar(child: Icon(Icons.edit_outlined)),
                    ),
                  )
              ],
            ),
            if (!isLocalArchive)
              MangaActions(
                manga: manga,
                width: 65 * 1.5,
                height: 65 * 2.3,
              ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (manga.description != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReadMoreWidget(
                        text: manga.description!,
                        initial: _expanded,
                        onChanged: (value) {
                          setState(() {
                            _expanded = value;
                          });
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GenreBadgesWidget(genres: manga.genre!, multiline: _expanded || context.isTablet),
                  ),
                  if (!context.isTablet) MangaChaptersCounter(manga: manga, chapters: widget.chapters),
                ],
              ),
            ),
            if (widget.chapters == 0)
              Container(
                width: context.width(1),
                height: context.height(1),
                color: Theme.of(context).scaffoldBackgroundColor,
              )
          ],
        ),
      ],
    );
  }

  Widget _titles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: manga.name!));

            botToast('Copied!', second: 3);
          },
          child: Tooltip(
            message: 'ID: @${manga.id}\nTap to copy name',
            preferBelow: false,
            child: Text(manga.name!,
                style: const TextStyle(
                  fontSize: 20,
                )),
          ),
        ),
        isLocalArchive
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.author!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(getMangaStatusIcon(manga.status), size: 14),
                      const SizedBox(width: 4),
                      Text(getMangaStatusName(manga.status, context)),
                      const Text(' • '),
                      Text(manga.source!),
                      Text(' (${manga.lang!.toUpperCase()})'),
                      if (!widget.sourceExist)
                        const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(Icons.warning_amber, color: Colors.deepOrangeAccent, size: 14),
                        )
                    ],
                  )
                ],
              ),
      ],
    );
  }

  void _editLocalArchiveInfos() {
    final l10n = l10nLocalizations(context)!;
    TextEditingController? name = TextEditingController(text: manga.name!);
    TextEditingController? description = TextEditingController(text: manga.description!);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              l10n.edit,
            ),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(l10n.name),
                        ),
                        TextFormField(
                          controller: name,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(l10n.description),
                        ),
                        TextFormField(
                          controller: description,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(l10n.cancel)),
                  const SizedBox(
                    width: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        isar.writeTxnSync(() {
                          manga.description = description.text;
                          manga.name = name.text;
                          isar.mangas.putSync(manga);
                        });
                        Navigator.pop(context);
                      },
                      child: Text(l10n.edit)),
                ],
              )
            ],
          );
        });
  }
}
