// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_anime_sources.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchAnimeSourcesList)
final fetchAnimeSourcesListProvider = FetchAnimeSourcesListFamily._();

final class FetchAnimeSourcesListProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  FetchAnimeSourcesListProvider._({
    required FetchAnimeSourcesListFamily super.from,
    required ({int? id, bool reFresh}) super.argument,
  }) : super(
         retry: null,
         name: r'fetchAnimeSourcesListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchAnimeSourcesListHash();

  @override
  String toString() {
    return r'fetchAnimeSourcesListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    final argument = this.argument as ({int? id, bool reFresh});
    return fetchAnimeSourcesList(
      ref,
      id: argument.id,
      reFresh: argument.reFresh,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAnimeSourcesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchAnimeSourcesListHash() =>
    r'e7f673d37239c74f3403de3a234bbc1d6e171332';

final class FetchAnimeSourcesListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<void>, ({int? id, bool reFresh})> {
  FetchAnimeSourcesListFamily._()
    : super(
        retry: null,
        name: r'fetchAnimeSourcesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  FetchAnimeSourcesListProvider call({int? id, required bool reFresh}) =>
      FetchAnimeSourcesListProvider._(
        argument: (id: id, reFresh: reFresh),
        from: this,
      );

  @override
  String toString() => r'fetchAnimeSourcesListProvider';
}
