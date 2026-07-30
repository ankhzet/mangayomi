import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class CountStack extends StatelessWidget {
  final Widget child;
  final int count;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final Color color;
  final double? fontSize;
  final EdgeInsets padding;

  const CountStack({
    super.key,
    required this.child,
    required this.count,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.fontSize = 10,
    this.color = const Color.fromARGB(255, 176, 46, 37),
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          child: CountBadge(count: count, color: color),
        ),
      ],
    );
  }
}

class CountBadge extends StatelessWidget {
  final int count;
  final Color color;
  final double? fontSize;
  final EdgeInsets padding;

  const CountBadge({
    super.key,
    required this.count,
    this.color = const Color.fromARGB(255, 176, 46, 37),
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return Container();
    }

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withValues(alpha: 0.6),
        ),
        child: Padding(
          padding: padding,
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: fontSize ?? Theme.of(context).textTheme.labelSmall?.fontSize ?? 10,
              color: context.dynamicBlackWhiteColor,
            ),
            softWrap: false,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
