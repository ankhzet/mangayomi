// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updates.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getWatchedEntries)
final getWatchedEntriesProvider = GetWatchedEntriesProvider._();

final class GetWatchedEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Manga>>,
          List<Manga>,
          Stream<List<Manga>>
        >
    with $FutureModifier<List<Manga>>, $StreamProvider<List<Manga>> {
  GetWatchedEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getWatchedEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getWatchedEntriesHash();

  @$internal
  @override
  $StreamProviderElement<List<Manga>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Manga>> create(Ref ref) {
    return getWatchedEntries(ref);
  }
}

String _$getWatchedEntriesHash() => r'cdbe73d066c6b684f7d457750548307d91fc51a4';
