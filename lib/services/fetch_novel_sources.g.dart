// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_novel_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchNovelSourcesList)
final fetchNovelSourcesListProvider = FetchNovelSourcesListFamily._();

final class FetchNovelSourcesListProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  FetchNovelSourcesListProvider._({
    required FetchNovelSourcesListFamily super.from,
    required ({int? id, dynamic reFresh}) super.argument,
  }) : super(
         retry: null,
         name: r'fetchNovelSourcesListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchNovelSourcesListHash();

  @override
  String toString() {
    return r'fetchNovelSourcesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({int? id, dynamic reFresh});
    return fetchNovelSourcesList(
      ref,
      id: argument.id,
      reFresh: argument.reFresh,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchNovelSourcesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchNovelSourcesListHash() =>
    r'882ee56332290a6fe71d38a8378de847e4386e3a';

final class FetchNovelSourcesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({int? id, dynamic reFresh})
        > {
  FetchNovelSourcesListFamily._()
    : super(
        retry: null,
        name: r'fetchNovelSourcesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  FetchNovelSourcesListProvider call({int? id, required dynamic reFresh}) =>
      FetchNovelSourcesListProvider._(
        argument: (id: id, reFresh: reFresh),
        from: this,
      );

  @override
  String toString() => r'fetchNovelSourcesListProvider';
}
