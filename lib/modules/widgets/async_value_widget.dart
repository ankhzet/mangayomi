import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/extensions/async_value.dart';

typedef OnErrorCombine = Widget Function(Object error, StackTrace stackTrace);

typedef OnLoadingCombine = Widget Function();

abstract interface class CombinerLike<Values extends Record> implements Iterable<AsyncValue> {
  Widget make(
    Widget Function(List results) builder,
    Widget Function(Object, StackTrace) error,
    Widget Function() loading,
  );
}

class AsyncValueWidget<Values extends Record, Async extends Record> extends StatelessWidget {
  final AsyncValueCombiner<Values, Async> async;
  final Widget Function(List values) builder;
  final double spinnerSize;
  final Object? tag;

  const AsyncValueWidget({
    super.key,
    required this.async,
    required this.builder,
    this.spinnerSize = double.infinity,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return async.make(builder, error, loading);
  }

  Widget error(Object error, stackTrace) {
    return ErrorText(error, stackTrace: stackTrace);
  }

  Widget loading() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: spinnerSize,
        maxHeight: spinnerSize,
      ),
      child: const ProgressCenter(),
    );
  }
}
