import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/manga_details_view.dart';
import 'package:mangayomi/modules/widgets/async_value_widget.dart';
import 'package:mangayomi/modules/widgets/overlay_refresh_center.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class MangaReaderDetail extends ConsumerStatefulWidget {
  final int mangaId;

  const MangaReaderDetail({super.key, required this.mangaId});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

class _MangaReaderDetailState extends ConsumerState<MangaReaderDetail> {
  @override
  void initState() {
    const Duration(milliseconds: 10).waitFor(() => _update(true, true));
    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final manga = ref.watch(getMangaDetailStreamProvider(mangaId: widget.mangaId)).combiner();

    return Scaffold(
      body: AsyncValueWidget(
        async: manga,
        builder: (values) => manga.build(values, (Manga? manga) => _body(context, manga)),
      ),
    );
  }

  Widget _body(BuildContext context, Manga? manga) {
    if (manga == null) {
      return const ProgressCenter();
    }

    final value = ref.watch(getSourceStreamProvider(title: manga.source!, lang: manga.lang!)).combiner();

    return AsyncValueWidget(
      async: value,
      builder: (values) => value.build(values, (bool sourceExists) {
        final view = MangaDetailsView(
          manga: manga,
          sourceExist: sourceExists,
          checkForUpdate: (sourceExists ? (bool initial) => _update(true, initial) : (bool initial) {}),
        );

        if (!sourceExists) {
          return view;
        }

        return RefreshIndicator(
          onRefresh: () => _update(false, false),
          child: Stack(
            children: [
              view,
              if (_isLoading) const OverlayRefreshCenter(),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _update(bool manual, bool initial) async {
    if (_isLoading) {
      return;
    }

    if (manual) {
      setState(() => _isLoading = true);
    }

    try {
      await ref.read(updateMangaDetailProvider(mangaId: widget.mangaId, isInit: initial).future);
    } finally {
      if (mounted && manual) {
        setState(() => _isLoading = false);
      }
    }
  }
}
