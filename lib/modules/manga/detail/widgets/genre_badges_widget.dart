import 'package:flutter/material.dart';

import 'genre_badge_widget.dart';

class GenreBadgesWidget extends StatelessWidget {
  final List<String> genres;
  final bool multiline;
  final double height;
  final void Function(String genre)? onPressed;

  const GenreBadgesWidget({
    super.key,
    required this.genres,
    this.multiline = false,
    this.height = 30,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return SizedBox(
        height: height,
      );
    }

    final items = [
      for (var i = 0; i < genres.length; i++)
        Padding(
          padding: multiline
              ? const EdgeInsets.only(left: 2, right: 2, bottom: 5)
              : const EdgeInsets.symmetric(horizontal: 2),
          child: GenreBadgeWidget(
            genre: genres[i],
            height: height,
            onPressed: onPressed != null ? () => onPressed!(genres[i]) : null,
          ),
        ),
    ];

    return multiline
        ? Wrap(children: items)
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: items,
            ),
          );
  }
}
