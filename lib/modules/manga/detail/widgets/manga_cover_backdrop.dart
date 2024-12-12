import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/utils/cached_network.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/constant.dart';

class MangaCoverBackdrop extends StatelessWidget {
  final Manga manga;
  final bool active;

  const MangaCoverBackdrop({
    super.key,
    required this.manga,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return Container();
    }

    final width = context.width(1);

    return Positioned(
      top: 0,
      child: Stack(children: [
        _buildImage(),
        Stack(children: [
          Container(
            width: width,
            height: 465 + AppBar().preferredSize.height,
            color: context.isTablet
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: 100,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildImage() {
    return Consumer(builder: (context, ref, child) {
      if (manga.customCoverImage != null) {
        return Image.memory(
          manga.customCoverImage as Uint8List,
          width: context.width(1),
          height: 300,
          fit: BoxFit.cover,
        );
      }

      return cachedNetworkImage(
        headers: manga.isLocalArchive! ? null : ref.watch(headersProvider(source: manga.source!, lang: manga.lang!)),
        imageUrl: toImgUrl(manga.customCoverFromTracker ?? manga.imageUrl ?? ""),
        width: context.width(1),
        height: 300,
        fit: BoxFit.cover,
      );
    });
  }
}
