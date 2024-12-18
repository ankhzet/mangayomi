import 'package:flutter/material.dart';

class RoundNavButton extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;

  final void Function()? onPressed;

  const RoundNavButton({
    super.key,
    required this.backgroundColor,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 23,
        backgroundColor: backgroundColor,
        child: IconButton(
          onPressed: onPressed,
          icon: Transform.scale(
            scaleX: 1,
            child: Icon(
              icon,
              color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: onPressed == null ? 0.4 : 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
