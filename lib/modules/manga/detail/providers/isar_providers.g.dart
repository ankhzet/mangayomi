// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMangaDetailStreamHash() =>
    r'6e7c5dc20ee7d32a091e884ac6980e191f698c8c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getMangaDetailStream].
@ProviderFor(getMangaDetailStream)
const getMangaDetailStreamProvider = GetMangaDetailStreamFamily();

/// See also [getMangaDetailStream].
class GetMangaDetailStreamFamily extends Family<AsyncValue<Manga?>> {
  /// See also [getMangaDetailStream].
  const GetMangaDetailStreamFamily();

  /// See also [getMangaDetailStream].
  GetMangaDetailStreamProvider call({
    required int mangaId,
  }) {
    return GetMangaDetailStreamProvider(
      mangaId: mangaId,
    );
  }

  @override
  GetMangaDetailStreamProvider getProviderOverride(
    covariant GetMangaDetailStreamProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getMangaDetailStreamProvider';
}

/// See also [getMangaDetailStream].
class GetMangaDetailStreamProvider extends AutoDisposeStreamProvider<Manga?> {
  /// See also [getMangaDetailStream].
  GetMangaDetailStreamProvider({
    required int mangaId,
  }) : this._internal(
          (ref) => getMangaDetailStream(
            ref as GetMangaDetailStreamRef,
            mangaId: mangaId,
          ),
          from: getMangaDetailStreamProvider,
          name: r'getMangaDetailStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMangaDetailStreamHash,
          dependencies: GetMangaDetailStreamFamily._dependencies,
          allTransitiveDependencies:
              GetMangaDetailStreamFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  GetMangaDetailStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final int mangaId;

  @override
  Override overrideWith(
    Stream<Manga?> Function(GetMangaDetailStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMangaDetailStreamProvider._internal(
        (ref) => create(ref as GetMangaDetailStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Manga?> createElement() {
    return _GetMangaDetailStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMangaDetailStreamProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMangaDetailStreamRef on AutoDisposeStreamProviderRef<Manga?> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;
}

class _GetMangaDetailStreamProviderElement
    extends AutoDisposeStreamProviderElement<Manga?>
    with GetMangaDetailStreamRef {
  _GetMangaDetailStreamProviderElement(super.provider);

  @override
  int get mangaId => (origin as GetMangaDetailStreamProvider).mangaId;
}

String _$getChaptersStreamHash() => r'0f03db54c5a639c4356a81e4bad50fa8a077ceac';

/// See also [getChaptersStream].
@ProviderFor(getChaptersStream)
const getChaptersStreamProvider = GetChaptersStreamFamily();

/// See also [getChaptersStream].
class GetChaptersStreamFamily extends Family<AsyncValue<List<Chapter>>> {
  /// See also [getChaptersStream].
  const GetChaptersStreamFamily();

  /// See also [getChaptersStream].
  GetChaptersStreamProvider call({
    required int mangaId,
  }) {
    return GetChaptersStreamProvider(
      mangaId: mangaId,
    );
  }

  @override
  GetChaptersStreamProvider getProviderOverride(
    covariant GetChaptersStreamProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getChaptersStreamProvider';
}

/// See also [getChaptersStream].
class GetChaptersStreamProvider
    extends AutoDisposeStreamProvider<List<Chapter>> {
  /// See also [getChaptersStream].
  GetChaptersStreamProvider({
    required int mangaId,
  }) : this._internal(
          (ref) => getChaptersStream(
            ref as GetChaptersStreamRef,
            mangaId: mangaId,
          ),
          from: getChaptersStreamProvider,
          name: r'getChaptersStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChaptersStreamHash,
          dependencies: GetChaptersStreamFamily._dependencies,
          allTransitiveDependencies:
              GetChaptersStreamFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  GetChaptersStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final int mangaId;

  @override
  Override overrideWith(
    Stream<List<Chapter>> Function(GetChaptersStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChaptersStreamProvider._internal(
        (ref) => create(ref as GetChaptersStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Chapter>> createElement() {
    return _GetChaptersStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChaptersStreamProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetChaptersStreamRef on AutoDisposeStreamProviderRef<List<Chapter>> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;
}

class _GetChaptersStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Chapter>>
    with GetChaptersStreamRef {
  _GetChaptersStreamProviderElement(super.provider);

  @override
  int get mangaId => (origin as GetChaptersStreamProvider).mangaId;
}

String _$getChaptersFilteredStreamHash() =>
    r'55dc99be8e4d5ed4c5e5c2768afb7943c9f604e6';

/// See also [getChaptersFilteredStream].
@ProviderFor(getChaptersFilteredStream)
const getChaptersFilteredStreamProvider = GetChaptersFilteredStreamFamily();

/// See also [getChaptersFilteredStream].
class GetChaptersFilteredStreamFamily
    extends Family<AsyncValue<List<Chapter>>> {
  /// See also [getChaptersFilteredStream].
  const GetChaptersFilteredStreamFamily();

  /// See also [getChaptersFilteredStream].
  GetChaptersFilteredStreamProvider call({
    required int mangaId,
    required ChapterFilterModel filter,
    required ChapterSortModel sort,
  }) {
    return GetChaptersFilteredStreamProvider(
      mangaId: mangaId,
      filter: filter,
      sort: sort,
    );
  }

  @override
  GetChaptersFilteredStreamProvider getProviderOverride(
    covariant GetChaptersFilteredStreamProvider provider,
  ) {
    return call(
      mangaId: provider.mangaId,
      filter: provider.filter,
      sort: provider.sort,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getChaptersFilteredStreamProvider';
}

/// See also [getChaptersFilteredStream].
class GetChaptersFilteredStreamProvider
    extends AutoDisposeStreamProvider<List<Chapter>> {
  /// See also [getChaptersFilteredStream].
  GetChaptersFilteredStreamProvider({
    required int mangaId,
    required ChapterFilterModel filter,
    required ChapterSortModel sort,
  }) : this._internal(
          (ref) => getChaptersFilteredStream(
            ref as GetChaptersFilteredStreamRef,
            mangaId: mangaId,
            filter: filter,
            sort: sort,
          ),
          from: getChaptersFilteredStreamProvider,
          name: r'getChaptersFilteredStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getChaptersFilteredStreamHash,
          dependencies: GetChaptersFilteredStreamFamily._dependencies,
          allTransitiveDependencies:
              GetChaptersFilteredStreamFamily._allTransitiveDependencies,
          mangaId: mangaId,
          filter: filter,
          sort: sort,
        );

  GetChaptersFilteredStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
    required this.filter,
    required this.sort,
  }) : super.internal();

  final int mangaId;
  final ChapterFilterModel filter;
  final ChapterSortModel sort;

  @override
  Override overrideWith(
    Stream<List<Chapter>> Function(GetChaptersFilteredStreamRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetChaptersFilteredStreamProvider._internal(
        (ref) => create(ref as GetChaptersFilteredStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
        filter: filter,
        sort: sort,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Chapter>> createElement() {
    return _GetChaptersFilteredStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetChaptersFilteredStreamProvider &&
        other.mangaId == mangaId &&
        other.filter == filter &&
        other.sort == sort;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);
    hash = _SystemHash.combine(hash, sort.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetChaptersFilteredStreamRef
    on AutoDisposeStreamProviderRef<List<Chapter>> {
  /// The parameter `mangaId` of this provider.
  int get mangaId;

  /// The parameter `filter` of this provider.
  ChapterFilterModel get filter;

  /// The parameter `sort` of this provider.
  ChapterSortModel get sort;
}

class _GetChaptersFilteredStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Chapter>>
    with GetChaptersFilteredStreamRef {
  _GetChaptersFilteredStreamProviderElement(super.provider);

  @override
  int get mangaId => (origin as GetChaptersFilteredStreamProvider).mangaId;
  @override
  ChapterFilterModel get filter =>
      (origin as GetChaptersFilteredStreamProvider).filter;
  @override
  ChapterSortModel get sort =>
      (origin as GetChaptersFilteredStreamProvider).sort;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
