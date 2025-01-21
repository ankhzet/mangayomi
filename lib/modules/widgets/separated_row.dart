import 'package:flutter/material.dart';

class SeparatedRow extends StatelessWidget {
  final Widget separator;
  final Iterable<Widget?> children;

  const SeparatedRow({super.key, required this.separator, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.fold([], (result, child) {
        if (child != null) {
          if (result.isNotEmpty) {
            result.add(separator);
          }

          result.add(child);
        }

        return result;
      }),
    );
  }
}
