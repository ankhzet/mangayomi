import 'package:flutter/material.dart';

class RefreshCenter extends StatelessWidget {
  const RefreshCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RefreshProgressIndicator(),
    );
  }
}
