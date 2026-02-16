// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_manga_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchMangaSourcesList)
final fetchMangaSourcesListProvider = FetchMangaSourcesListFamily._();

final class FetchMangaSourcesListProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  FetchMangaSourcesListProvider._({
    required FetchMangaSourcesListFamily super.from,
    required ({int? id, dynamic reFresh}) super.argument,
  }) : super(
         retry: null,
         name: r'fetchMangaSourcesListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchMangaSourcesListHash();

  @override
  String toString() {
    return r'fetchMangaSourcesListProvider'
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
    return fetchMangaSourcesList(
      ref,
      id: argument.id,
      reFresh: argument.reFresh,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMangaSourcesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchMangaSourcesListHash() =>
    r'87b15747e8aed54895d289578dc6898e124d3cfa';

final class FetchMangaSourcesListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<void>,
          ({int? id, dynamic reFresh})
        > {
  FetchMangaSourcesListFamily._()
    : super(
        retry: null,
        name: r'fetchMangaSourcesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  FetchMangaSourcesListProvider call({int? id, required dynamic reFresh}) =>
      FetchMangaSourcesListProvider._(
        argument: (id: id, reFresh: reFresh),
        from: this,
      );

  @override
  String toString() => r'fetchMangaSourcesListProvider';
}
