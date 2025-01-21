import 'dart:math';

import 'package:flutter/material.dart';

class PageSlider extends StatelessWidget {
  final Color backgroundColor;

  final int pages;
  final int currentIndex;
  final int divisions;
  final bool active;
  final bool mirror;

  final String Function(int index) indexToLabel;
  final void Function(int index) onChange;
  final void Function(int index) onApply;

  const PageSlider({
    super.key,
    required this.backgroundColor,
    required this.pages,
    required this.currentIndex,
    required this.divisions,
    required this.indexToLabel,
    required this.onChange,
    required this.onApply,
    this.active = true,
    this.mirror = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    final label = indexToLabel(currentIndex);
    final first = SizedBox(
      width: 55,
      child: Center(child: Text(indexToLabel(currentIndex), style: style)),
    );
    final last = SizedBox(
      width: 55,
      child: Center(child: Text("$pages", style: style)),
    );
    final minValue = 0.0;
    final maxValue = max(minValue, divisions.toDouble());
    final value = min(
      max(minValue, currentIndex.toDouble()),
      maxValue,
    );

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          mirror ? Transform.scale(scaleX: -1, child: first) : first,
          if (active)
            Flexible(
              flex: 14,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
                ),
                child: Slider(
                  onChanged: (value) => onChange(value.toInt()),
                  onChangeEnd: (value) => onApply(value.toInt()),
                  divisions: pages == 1 ? null : max(1, divisions),
                  value: value,
                  label: label,
                  min: minValue,
                  max: maxValue,
                ),
              ),
            ),
          mirror ? Transform.scale(scaleX: -1, child: last) : last,
        ],
      ),
    );
  }
}
