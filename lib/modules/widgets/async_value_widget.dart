import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> async;
  final Widget Function(T value) builder;

  const AsyncValueWidget({super.key, required this.async, required this.builder});

  @override
  Widget build(BuildContext context) {
    return async.when(
      data: (value) => builder(value),
      error: (error, stackTrace) => ErrorText(error),
      loading: () => const ProgressCenter(),
    );
  }
}
