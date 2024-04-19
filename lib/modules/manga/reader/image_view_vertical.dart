import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';

class ImageViewVertical extends ConsumerWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final bool cropBorders;
  final bool isHorizontal;

  final Function(bool) failedToLoadImage;

  const ImageViewVertical(
      {super.key,
      required this.data,
      required this.onLongPressData,
      required this.cropBorders,
      required this.failedToLoadImage,
      required this.isHorizontal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropImageExist = cropBorders && data.cropImage != null;

    return _imageView(cropImageExist ? true : data.isLocale!,
        cropImageExist ? data.cropImage : data.archiveImage, context, ref);
  }

  Widget _imageView(bool isLocale, Uint8List? archiveImage,
      BuildContext context, WidgetRef ref) {
    final image = isLocale
        ? archiveImage != null
            ? ExtendedMemoryImageProvider(archiveImage)
            : ExtendedFileImageProvider(
                File('${data.directory!.path}${padIndex(data.index! + 1)}.jpg'))
        : CustomExtendedNetworkImageProvider(
            data.url!.trim().trimLeft().trimRight(),
            cache: true,
            cacheMaxAge: const Duration(days: 7),
            headers: ref.watch(headersProvider(
                source: data.chapter!.manga.value!.source!,
                lang: data.chapter!.manga.value!.lang!)));
    final scaleType = ref.watch(scaleTypeStateProvider);
    final l10n = l10nLocalizations(context)!;
    final imageWidget = ExtendedImage(
        image: image as ImageProvider<Object>,
        filterQuality: FilterQuality.medium,
        handleLoadingProgress: true,
        fit: getBoxFit(scaleType),
        enableMemoryCache: true,
        enableLoadState: true,
        loadStateChanged: (state) {
          if (state.extendedImageLoadState == LoadState.completed) {
            failedToLoadImage(false);
          }
          if (state.extendedImageLoadState == LoadState.loading) {
            final ImageChunkEvent? loadingProgress = state.loadingProgress;
            final double progress = loadingProgress?.expectedTotalBytes != null
                ? loadingProgress!.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : 0;
            return Container(
              color: Colors.black,
              height: context.height(0.8),
              width: isHorizontal ? context.width(0.8) : null,
              child: CircularProgressIndicatorAnimateRotate(progress: progress),
            );
          }
          if (state.extendedImageLoadState == LoadState.failed) {
            failedToLoadImage(true);
            return Container(
                color: Colors.black,
                height: context.height(0.8),
                width: isHorizontal ? context.width(0.8) : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.image_loading_error,
                        style: TextStyle(color: Colors.white.withOpacity(0.7))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                          onLongPress: () {
                            state.reLoadImage();
                            failedToLoadImage(false);
                          },
                          onTap: () {
                            state.reLoadImage();
                            failedToLoadImage(false);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: context.primaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                l10n.retry,
                              ),
                            ),
                          )),
                    ),
                  ],
                ));
          }
          return null;
        });
    return GestureDetector(
      onLongPress: () => onLongPressData.call(data),
      child: ColorFilterWidget(
        child: isHorizontal
            ? imageWidget
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.index == 0)
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                  imageWidget
                ],
              ),
      ),
    );
  }
}
