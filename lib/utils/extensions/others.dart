import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/headers.dart';

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) {
    return block(this);
  }
}

extension ListUnique<T> on Iterable<T> {
  List<T> toUnique({bool growable = true}) => toSet().toList(growable: growable);
}

extension IterableUtils<T> on Iterable<T> {
  List<T> sorted(Comparator<T> comparator) {
    final result = [...this];
    result.sort(comparator);

    return result;
  }

  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } on StateError {
      return null;
    }
  }

  T? lastWhereOrNull(bool Function(T) test) {
    try {
      return lastWhere(test);
    } on StateError {
      return null;
    }
  }
}

extension Trimmable on String {
  String normalize() => toString().trim().trimLeft().trimRight(); // why .trimLeft().trimRight()???
}

extension ImageProviderExtension on ImageProvider {
  Future<Uint8List?> getBytes(BuildContext context, {ImageByteFormat format = ImageByteFormat.png}) async {
    final Completer<Uint8List?> completer = Completer<Uint8List?>();
    final ImageStreamListener listener = ImageStreamListener((imageInfo, synchronousCall) async {
      final bytes = await imageInfo.image.toByteData(format: format);
      if (!completer.isCompleted) {
        completer.complete(bytes?.buffer.asUint8List());
      }
    });
    final imageStream = resolve(createLocalImageConfiguration(context));

    imageStream.addListener(listener);

    try {
      return await completer.future;
    } finally {
      imageStream.removeListener(listener);
    }
  }
}

extension UChapDataPreloadExtensions on UChapDataPreload {
  Future<Uint8List?> get getImageBytes async {
    Uint8List? imageBytes;

    if (archiveImage != null) {
      imageBytes = archiveImage;
    } else if (isLocal) {
      imageBytes = preloadFile.readAsBytesSync();
    } else {
      File? cachedImage;

      if (pageUrl != null) {
        cachedImage = await getCachedImageFile(pageUrl!.url);
      }

      if (cachedImage == null) {
        await Future.delayed(const Duration(seconds: 3));
        cachedImage = await getCachedImageFile(pageUrl!.url);
      }

      imageBytes = cachedImage?.readAsBytesSync();
    }

    return imageBytes;
  }

  ImageProvider<Object> getImageProvider(WidgetRef ref, bool showCloudFlareError) {
    final cropBorders = ref.watch(cropBordersStateProvider);

    if (cropBorders && cropImage != null) {
      return ExtendedMemoryImageProvider(cropImage!);
    }

    if (isLocal) {
      return archiveImage != null
          ? ExtendedMemoryImageProvider(archiveImage!)
          : ExtendedFileImageProvider(preloadFile);
    }

    return CustomExtendedNetworkImageProvider(
      pageUrl!.url.normalize(),
      cache: true,
      cacheMaxAge: const Duration(days: 7),
      showCloudFlareError: showCloudFlareError,
      imageCacheFolderName: "cacheimagemanga",
      headers: {
        ...pageUrl!.headers ?? {},
        ...ref
            .watch(headersProvider(source: chapter.manga.value!.source!, lang: chapter.manga.value!.lang!))
      },
    );
  }
}
