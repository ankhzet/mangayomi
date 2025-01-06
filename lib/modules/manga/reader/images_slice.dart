import 'package:flutter/material.dart';
import 'package:mangayomi/models/dto/preload_task.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view.dart';

class ImagesSlice extends StatelessWidget {
  final Iterable<PreloadTask?> preloads;
  final BackgroundColor backgroundColor;
  final bool horizontal;
  final bool vertical;
  final Function(bool)? onLoadError;
  final Function(PreloadTask datas) onLongPressData;

  const ImagesSlice({
    super.key,
    required this.preloads,
    required this.backgroundColor,
    required this.onLongPressData,
    required this.onLoadError,
    this.horizontal = false,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final separator = const SizedBox(width: 10);
    final images = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: preloads
          .map((preload) => (preload == null
              ? separator
              : Flexible(
                  child: ImageView(
                  data: preload,
                  backgroundColor: backgroundColor,
                  onLongPressData: onLongPressData,
                  onLoadError: onLoadError,
                  horizontal: horizontal,
                ))))
          .toList(),
    );

    if (vertical) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (preloads.first?.index == 0) SizedBox(height: MediaQuery.of(context).padding.top),
          images,
        ],
      );
    }

    return images;
  }
}
