import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/dto/preload_task.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/widgets/retry_widget.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';

class ImageView extends ConsumerWidget {
  final PreloadTask data;
  final BackgroundColor backgroundColor;
  final bool horizontal;

  final Function(PreloadTask data) onLongPressData;
  final Function(ExtendedImageGestureState state)? onDoubleTap;
  final Function(bool hasError)? onLoadError;
  final GestureConfig Function(ExtendedImageState state)? initGestureConfigHandler;

  const ImageView({
    super.key,
    required this.data,
    required this.backgroundColor,
    required this.onLongPressData,
    this.horizontal = false,
    this.onDoubleTap,
    this.onLoadError,
    this.initGestureConfigHandler,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (colorBlendMode, color) = chapterColorFilterValues(context, ref);

    final imageWidget = ExtendedImage(
      image: data.getImageProvider(ref, true),
      colorBlendMode: colorBlendMode,
      color: color,
      filterQuality: FilterQuality.medium,
      handleLoadingProgress: true,
      fit: getBoxFit(ref.watch(scaleTypeStateProvider)),
      mode: ExtendedImageMode.gesture,
      initGestureConfigHandler: initGestureConfigHandler,
      onDoubleTap: onDoubleTap,
      loadStateChanged: (state) => _loadStateChanged(context, state),
    );

    return GestureDetector(
      onLongPress: _onLongPress,
      child:
          horizontal
              ? imageWidget
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [if (data.index == 0) SizedBox(height: MediaQuery.of(context).padding.top), imageWidget],
              ),
    );
  }

  void _onLongPress() {
    onLongPressData(data);
  }

  Widget? _loadStateChanged(BuildContext context, ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.loading) {
      final ImageChunkEvent? loadingProgress = state.loadingProgress;
      final double progress =
          (loadingProgress?.cumulativeBytesLoaded ?? 0) / (loadingProgress?.expectedTotalBytes ?? 1.0);

      return _center(context, CircularProgressIndicatorAnimateRotate(progress: progress));
    }

    if (state.extendedImageLoadState == LoadState.completed) {
      if (onLoadError != null) {
        onLoadError!(false);
      }

      return Image(image: state.imageProvider);
    }

    if (state.extendedImageLoadState == LoadState.failed) {
      if (onLoadError != null) {
        onLoadError!(true);
      }

      return _center(context, RetryWidget(onPressed: () {
        state.reLoadImage();

        if (onLoadError != null) {
          onLoadError!(false);
        }
      }));
    }

    return const SizedBox.shrink();
  }

  Widget _center(BuildContext context, Widget child) {
    return Container(
      color: getBackgroundColor(backgroundColor),
      height: context.height(0.8),
      child: child,
    );
  }
}
