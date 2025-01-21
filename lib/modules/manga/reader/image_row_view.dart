import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/dto/preload_task.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/images_slice.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageRowView extends StatefulWidget {
  final List<PreloadTask> data;
  final int offset;
  final int slides;
  final bool mirror;
  final bool horizontal;
  final bool vertical;
  final bool separator;
  final BackgroundColor backgroundColor;
  final Function(PreloadTask datas) onLongPressData;
  final Function(bool hasError)? onLoadError;

  const ImageRowView({
    super.key,
    required this.data,
    required this.offset,
    required this.slides,
    required this.mirror,
    required this.backgroundColor,
    required this.onLongPressData,
    this.onLoadError,
    this.horizontal = false,
    this.vertical = false,
    this.separator = false,
  });

  @override
  State<ImageRowView> createState() => _ImageRowViewState();
}

class _ImageRowViewState extends State<ImageRowView> with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController = PhotoViewScaleStateController();

  double get pixelRatio => View.of(context).devicePixelRatio;

  Size get size => View.of(context).physicalSize / pixelRatio;

  Alignment _computeAlignmentByTapOffset(Offset offset) {
    double dx = size.width / 2;
    double dy = size.height / 2;

    return Alignment(
      (offset.dx - dx) / dx,
      (offset.dy - dy) / dy,
    );
  }

  @override
  void initState() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: switch (isar.settings.first.doubleTapAnimationSpeed!) {
          0 => 10,
          1 => 800,
          _ => 200,
        },
      ),
    );
    _animation =
        Tween(begin: 1.0, end: 2.0).animate(CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController))
          ..addListener(() {
            _photoViewController.scale = _animation.value;
          });

    super.initState();
  }

  Iterable<PreloadTask?> getTasks() {
    final data = widget.data;
    int slides = widget.slides;
    int index = widget.offset * slides - 1;
    final target = min(index + slides, data.length) - 1;
    List<PreloadTask?> result = [];

    if (index < 0) {
      final task = data[0];

      if (task.isValid) {
        result.add(task);
      }
    } else {
      bool next = false;

      while (index <= target) {
        final task = data[index++];

        if (next && widget.separator) {
          result.add(null);
        } else {
          next = task.isValid;
        }

        if (task.isValid) {
          result.add(task);
        }
      }
    }

    return widget.mirror ? result.reversed : result;
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      itemCount: 1,
      builder: (context, _) => PhotoViewGalleryPageOptions.customChild(
        controller: _photoViewController,
        scaleStateController: _photoViewScaleStateController,
        basePosition: _scalePosition,
        onScaleEnd: _onScaleEnd,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onDoubleTapDown: _toggleScale,
          child: ImagesSlice(
            preloads: getTasks(),
            backgroundColor: widget.backgroundColor,
            onLongPressData: widget.onLongPressData,
            onLoadError: widget.onLoadError,
            horizontal: widget.horizontal,
            vertical: widget.vertical,
          ),
        ),
      ),
    );
  }

  void _toggleScale(TapDownDetails details) {
    if ((!mounted) || _scaleAnimationController.isAnimating) {
      return;
    }

    setState(() {
      if (_photoViewController.scale == 1.0) {
        _scalePosition = _computeAlignmentByTapOffset(details.globalPosition);

        if (_scaleAnimationController.isCompleted) {
          _scaleAnimationController.reset();
        }

        _scaleAnimationController.forward();
        return;
      }

      if (_photoViewController.scale == 2.0) {
        _scaleAnimationController.reverse();
        return;
      }

      _photoViewScaleStateController.reset();
    });
  }

  void _onScaleEnd(BuildContext context, ScaleEndDetails details, PhotoViewControllerValue controllerValue) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }
}
