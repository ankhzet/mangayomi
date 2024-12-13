import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/detail/chapters_list_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_providers.g.dart';

@riverpod
Stream<Manga?> getMangaDetailStream(Ref ref, {required int mangaId}) async* {
  yield* isar.mangas.watchObject(mangaId, fireImmediately: true);
}

@riverpod
Stream<List<Chapter>> getChaptersStream(Ref ref, {required int mangaId}) async* {
  yield* isar.chapters.filter().manga((q) => q.idEqualTo(mangaId)).watch(fireImmediately: true);
}

class ChaptersStreamTransformer implements StreamTransformer<List<Chapter>, List<Chapter>> {
  final StreamController<List<Chapter>> _controller = StreamController();

  final ChaptersListModel model;

  ChaptersStreamTransformer({
    required this.model,
  });

  @override
  Stream<List<Chapter>> bind(Stream<List<Chapter>> stream) {
    stream.listen((value) {
      _controller.add(model.build(value)); // emit current sum to our listener
    });

    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}

@riverpod
Stream<List<Chapter>> getChaptersFilteredStream(
  Ref ref, {
  required int mangaId,
  required ChapterFilterModel filter,
  required ChapterSortModel sort,
}) async* {
  final model = ChaptersListModel(
    filter: filter,
    sort: sort,
  );

  yield* isar.chapters
      .filter()
      .manga((q) => q.idEqualTo(mangaId))
      .watch(fireImmediately: true)
      .transform(ChaptersStreamTransformer(model: model));
}
