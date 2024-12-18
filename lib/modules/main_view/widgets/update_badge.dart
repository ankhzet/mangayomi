import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class UpdateBadge extends StatelessWidget {
  final int count;
  final Color color;

  const UpdateBadge({
    super.key,
    required this.count,
    this.color = const Color.fromARGB(255, 176, 46, 37),
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            count.toString(),
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize ?? 10,
                color: context.dynamicBlackWhiteColor),
          ),
        ),
      ),
    );
  }
}
