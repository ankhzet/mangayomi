import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/manga_details_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/manga/detail/providers/update_manga_detail_providers.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class MangaReaderDetail extends ConsumerStatefulWidget {
  final int mangaId;

  const MangaReaderDetail({super.key, required this.mangaId});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

class _MangaReaderDetailState extends ConsumerState<MangaReaderDetail> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await ref.read(updateMangaDetailProvider(mangaId: widget.mangaId, isInit: true).future);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final manga = ref.watch(getMangaDetailStreamProvider(mangaId: widget.mangaId));

    return Scaffold(
      body: manga.when(
        data: (manga) => manga != null ? _body(context, manga) : const ProgressCenter(),
        error: (error, stackTrace) => ErrorText(error),
        loading: () => const ProgressCenter(),
      ),
    );
  }

  Widget _body(BuildContext context, Manga manga) {
    final sources = isar.sources
        .filter()
        .idIsNotNull()
        .isActiveEqualTo(true)
        .and()
        .isAddedEqualTo(true)
        .and()
        .langContains(manga.lang!, caseSensitive: false)
        .and()
        .nameContains(manga.source!, caseSensitive: false)
        .watch(fireImmediately: true);

    return StreamBuilder(
      stream: sources,
      builder: (context, snapshot) {
        final sourceExist = snapshot.hasData && snapshot.data!.isNotEmpty;

        Future<void> update(bool manual, bool initial) async {
          if (_isLoading || !sourceExist) {
            return;
          }

          if (manual) {
            setState(() => _isLoading = true);
          }

          try {
            await ref.read(updateMangaDetailProvider(mangaId: manga.id, isInit: initial).future);
          } finally {
            if (mounted && manual) {
              setState(() => _isLoading = false);
            }
          }
        }

        return RefreshIndicator(
          onRefresh: () => update(false, false),
          child: Stack(
            children: [
              MangaDetailsView(
                manga: manga,
                sourceExist: sourceExist,
                checkForUpdate: (bool initial) => update(true, initial),
              ),
              if (_isLoading)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: RefreshProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
