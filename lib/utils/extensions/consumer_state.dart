import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ConsumerStateText on ConsumerState {
  double measureTextWidth(String text, TextStyle style, {double padding = 0.0}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width + padding;
  }
}
