import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class GenreBadgeWidget extends StatelessWidget {
  final String genre;
  final double height;
  final void Function()? onPressed;

  const GenreBadgeWidget({
    super.key,
    required this.genre,
    this.height = 30,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: onPressed,
        child: Text(
          genre,
          style: TextStyle(fontSize: 11.5, color: context.isLight ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
