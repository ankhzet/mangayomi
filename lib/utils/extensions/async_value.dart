import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/async_value_widget.dart';
import 'package:mangayomi/utils/extensions/record.dart';

class AsyncValueCombiner<Values extends Record, Async extends Record>
    with Iterable<AsyncValue>
    implements CombinerLike<Values> {
  final Iterable<AsyncValue> values;

  const AsyncValueCombiner(this.values);

  static AsyncValueCombiner1<A> merge1<A>(AsyncValue<A> a) => AsyncValueCombiner1([a]);

  static AsyncValueCombiner2<A, B> merge2<A, B>(AsyncValue<A> a, AsyncValue<B> b) => AsyncValueCombiner2([a, b]);

  static AsyncValueCombiner3<A, B, C> merge3<A, B, C>(AsyncValue<A> a, AsyncValue<B> b, AsyncValue<C> c) =>
      AsyncValueCombiner3([a, b, c]);

  static AsyncValueCombiner4<A, B, C, D> merge4<A, B, C, D>(
          AsyncValue<A> a, AsyncValue<B> b, AsyncValue<C> c, AsyncValue<D> d) =>
      AsyncValueCombiner4([a, b, c, d]);

  static AsyncValueCombiner<Values, Async> merge<Values extends Record, Async extends Record>(Async values) =>
      AsyncValueCombiner(values.toList());

  @override
  Iterator<AsyncValue> get iterator => values.iterator;

  @override
  Widget make(Widget Function(List results) data, OnErrorCombine error, OnLoadingCombine loading) {
    return _makeConsumer(
      this,
      [],
      data,
      error,
      loading,
    );
  }

  Widget _makeConsumer(
    Iterable<AsyncValue> async,
    List results,
    Widget Function(List results) data,
    OnErrorCombine error,
    OnLoadingCombine loading,
  ) {
    if (async.isEmpty) {
      return data(results);
    }

    return async.first.when(
      data: (result) => _makeConsumer(async.skip(1), results..add(result), data, error, loading),
      error: error,
      loading: loading,
    );
  }
}

typedef AsyncRecord1<A> = (AsyncValue<A>,);
typedef AsyncRecord2<A, B> = (AsyncValue<A>, AsyncValue<B>);
typedef AsyncRecord3<A, B, C> = (AsyncValue<A>, AsyncValue<B>, AsyncValue<C>);
typedef AsyncRecord4<A, B, C, D> = (AsyncValue<A>, AsyncValue<B>, AsyncValue<C>, AsyncValue<D>);

class AsyncValueCombiner1<A> extends AsyncValueCombiner<(A,), AsyncRecord1<A>> {
  AsyncValueCombiner1(super.values);

  merge<B>(AsyncValue<B> next) => AsyncValueCombiner2([...values, next]);

  Widget build(List values, Widget Function(A) builder) {
    return Function.apply(builder, values.toList());
  }
}

class AsyncValueCombiner2<A, B> extends AsyncValueCombiner<(A, B), AsyncRecord2<A, B>> {
  AsyncValueCombiner2(super.values);

  merge<C>(AsyncValue<C> next) => AsyncValueCombiner3([...values, next]);

  Widget build(List values, Widget Function(A, B) builder) {
    return Function.apply(builder, values.toList());
  }
}

class AsyncValueCombiner3<A, B, C> extends AsyncValueCombiner<(A, B, C), AsyncRecord3<A, B, C>> {
  AsyncValueCombiner3(super.values);

  merge<D>(AsyncValue<D> next) => AsyncValueCombiner4([...values, next]);

  Widget build(List values, Widget Function(A, B, C) builder) {
    return Function.apply(builder, values.toList());
  }
}

class AsyncValueCombiner4<A, B, C, D> extends AsyncValueCombiner<(A, B, C, D), AsyncRecord4<A, B, C, D>> {
  AsyncValueCombiner4(super.values);

  Widget build(List values, Widget Function(A, B, C, D) builder) {
    return Function.apply(builder, values.toList());
  }
}

extension AsyncValueCombinerExt<A> on AsyncValue<A> {
  AsyncValueCombiner2<A, B> merge2<B>(AsyncValue<B> b) => AsyncValueCombiner2([this, b]);

  AsyncValueCombiner3<A, B, C> merge3<B, C>(
    AsyncValue<B> b,
    AsyncValue<C> c,
  ) =>
      AsyncValueCombiner3([this, b, c]);

  AsyncValueCombiner4<A, B, C, D> merge4<B, C, D>(
    AsyncValue<B> b,
    AsyncValue<C> c,
    AsyncValue<D> d,
  ) =>
      AsyncValueCombiner4([this, b, c, d]);

  AsyncValueCombiner1<A> combiner() => AsyncValueCombiner1<A>([this]);
}
