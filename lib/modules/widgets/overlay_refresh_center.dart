import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/refresh_center.dart';

class OverlayRefreshCenter extends StatelessWidget {
  const OverlayRefreshCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: RefreshCenter(),
      ),
    );
  }
}
