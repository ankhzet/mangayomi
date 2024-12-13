// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryDisplayTypeStateHash() =>
    r'd8bc64f8d51b7e59601fc9b88b3e679ec256ffde';

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

abstract class _$LibraryDisplayTypeState
    extends BuildlessAutoDisposeNotifier<DisplayType> {
  late final bool isManga;
  late final Settings settings;

  DisplayType build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryDisplayTypeState].
@ProviderFor(LibraryDisplayTypeState)
const libraryDisplayTypeStateProvider = LibraryDisplayTypeStateFamily();

/// See also [LibraryDisplayTypeState].
class LibraryDisplayTypeStateFamily extends Family<DisplayType> {
  /// See also [LibraryDisplayTypeState].
  const LibraryDisplayTypeStateFamily();

  /// See also [LibraryDisplayTypeState].
  LibraryDisplayTypeStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryDisplayTypeStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryDisplayTypeStateProvider getProviderOverride(
    covariant LibraryDisplayTypeStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryDisplayTypeStateProvider';
}

/// See also [LibraryDisplayTypeState].
class LibraryDisplayTypeStateProvider extends AutoDisposeNotifierProviderImpl<
    LibraryDisplayTypeState, DisplayType> {
  /// See also [LibraryDisplayTypeState].
  LibraryDisplayTypeStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryDisplayTypeState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryDisplayTypeStateProvider,
          name: r'libraryDisplayTypeStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryDisplayTypeStateHash,
          dependencies: LibraryDisplayTypeStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryDisplayTypeStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryDisplayTypeStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  DisplayType runNotifierBuild(
    covariant LibraryDisplayTypeState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(LibraryDisplayTypeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryDisplayTypeStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryDisplayTypeState, DisplayType>
      createElement() {
    return _LibraryDisplayTypeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDisplayTypeStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryDisplayTypeStateRef
    on AutoDisposeNotifierProviderRef<DisplayType> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryDisplayTypeStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryDisplayTypeState,
        DisplayType> with LibraryDisplayTypeStateRef {
  _LibraryDisplayTypeStateProviderElement(super.provider);

  @override
  bool get isManga => (origin as LibraryDisplayTypeStateProvider).isManga;
  @override
  Settings get settings => (origin as LibraryDisplayTypeStateProvider).settings;
}

String _$libraryGridSizeStateHash() =>
    r'783d25b4e7d9f1ddcbac74adde7fd3735c7cc646';

abstract class _$LibraryGridSizeState
    extends BuildlessAutoDisposeNotifier<int?> {
  late final bool isManga;

  int? build({
    required bool isManga,
  });
}

/// See also [LibraryGridSizeState].
@ProviderFor(LibraryGridSizeState)
const libraryGridSizeStateProvider = LibraryGridSizeStateFamily();

/// See also [LibraryGridSizeState].
class LibraryGridSizeStateFamily extends Family<int?> {
  /// See also [LibraryGridSizeState].
  const LibraryGridSizeStateFamily();

  /// See also [LibraryGridSizeState].
  LibraryGridSizeStateProvider call({
    required bool isManga,
  }) {
    return LibraryGridSizeStateProvider(
      isManga: isManga,
    );
  }

  @override
  LibraryGridSizeStateProvider getProviderOverride(
    covariant LibraryGridSizeStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
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
  String? get name => r'libraryGridSizeStateProvider';
}

/// See also [LibraryGridSizeState].
class LibraryGridSizeStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryGridSizeState, int?> {
  /// See also [LibraryGridSizeState].
  LibraryGridSizeStateProvider({
    required bool isManga,
  }) : this._internal(
          () => LibraryGridSizeState()..isManga = isManga,
          from: libraryGridSizeStateProvider,
          name: r'libraryGridSizeStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryGridSizeStateHash,
          dependencies: LibraryGridSizeStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryGridSizeStateFamily._allTransitiveDependencies,
          isManga: isManga,
        );

  LibraryGridSizeStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
  }) : super.internal();

  final bool isManga;

  @override
  int? runNotifierBuild(
    covariant LibraryGridSizeState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
    );
  }

  @override
  Override overrideWith(LibraryGridSizeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryGridSizeStateProvider._internal(
        () => create()..isManga = isManga,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryGridSizeState, int?>
      createElement() {
    return _LibraryGridSizeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryGridSizeStateProvider && other.isManga == isManga;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryGridSizeStateRef on AutoDisposeNotifierProviderRef<int?> {
  /// The parameter `isManga` of this provider.
  bool get isManga;
}

class _LibraryGridSizeStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryGridSizeState, int?>
    with LibraryGridSizeStateRef {
  _LibraryGridSizeStateProviderElement(super.provider);

  @override
  bool get isManga => (origin as LibraryGridSizeStateProvider).isManga;
}

String _$mangaFilterDownloadedStateHash() =>
    r'74020eb7d3e79eb55599867d6f5fe4012d66ad86';

abstract class _$MangaFilterDownloadedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  });
}

/// See also [MangaFilterDownloadedState].
@ProviderFor(MangaFilterDownloadedState)
const mangaFilterDownloadedStateProvider = MangaFilterDownloadedStateFamily();

/// See also [MangaFilterDownloadedState].
class MangaFilterDownloadedStateFamily extends Family<int> {
  /// See also [MangaFilterDownloadedState].
  const MangaFilterDownloadedStateFamily();

  /// See also [MangaFilterDownloadedState].
  MangaFilterDownloadedStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) {
    return MangaFilterDownloadedStateProvider(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  MangaFilterDownloadedStateProvider getProviderOverride(
    covariant MangaFilterDownloadedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'mangaFilterDownloadedStateProvider';
}

/// See also [MangaFilterDownloadedState].
class MangaFilterDownloadedStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterDownloadedState, int> {
  /// See also [MangaFilterDownloadedState].
  MangaFilterDownloadedStateProvider({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => MangaFilterDownloadedState()
            ..mangaList = mangaList
            ..isManga = isManga
            ..settings = settings,
          from: mangaFilterDownloadedStateProvider,
          name: r'mangaFilterDownloadedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterDownloadedStateHash,
          dependencies: MangaFilterDownloadedStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterDownloadedStateFamily._allTransitiveDependencies,
          mangaList: mangaList,
          isManga: isManga,
          settings: settings,
        );

  MangaFilterDownloadedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final bool isManga;
  final Settings settings;

  @override
  int runNotifierBuild(
    covariant MangaFilterDownloadedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterDownloadedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterDownloadedStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterDownloadedState, int>
      createElement() {
    return _MangaFilterDownloadedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterDownloadedStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterDownloadedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterDownloadedStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterDownloadedState, int>
    with MangaFilterDownloadedStateRef {
  _MangaFilterDownloadedStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterDownloadedStateProvider).mangaList;
  @override
  bool get isManga => (origin as MangaFilterDownloadedStateProvider).isManga;
  @override
  Settings get settings =>
      (origin as MangaFilterDownloadedStateProvider).settings;
}

String _$mangaFilterUnreadStateHash() =>
    r'66dcf3c88adab9a297be93f609584f0e1988578e';

abstract class _$MangaFilterUnreadState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  });
}

/// See also [MangaFilterUnreadState].
@ProviderFor(MangaFilterUnreadState)
const mangaFilterUnreadStateProvider = MangaFilterUnreadStateFamily();

/// See also [MangaFilterUnreadState].
class MangaFilterUnreadStateFamily extends Family<int> {
  /// See also [MangaFilterUnreadState].
  const MangaFilterUnreadStateFamily();

  /// See also [MangaFilterUnreadState].
  MangaFilterUnreadStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) {
    return MangaFilterUnreadStateProvider(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  MangaFilterUnreadStateProvider getProviderOverride(
    covariant MangaFilterUnreadStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'mangaFilterUnreadStateProvider';
}

/// See also [MangaFilterUnreadState].
class MangaFilterUnreadStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterUnreadState, int> {
  /// See also [MangaFilterUnreadState].
  MangaFilterUnreadStateProvider({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => MangaFilterUnreadState()
            ..mangaList = mangaList
            ..isManga = isManga
            ..settings = settings,
          from: mangaFilterUnreadStateProvider,
          name: r'mangaFilterUnreadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterUnreadStateHash,
          dependencies: MangaFilterUnreadStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterUnreadStateFamily._allTransitiveDependencies,
          mangaList: mangaList,
          isManga: isManga,
          settings: settings,
        );

  MangaFilterUnreadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final bool isManga;
  final Settings settings;

  @override
  int runNotifierBuild(
    covariant MangaFilterUnreadState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterUnreadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterUnreadStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterUnreadState, int>
      createElement() {
    return _MangaFilterUnreadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterUnreadStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterUnreadStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterUnreadStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterUnreadState, int>
    with MangaFilterUnreadStateRef {
  _MangaFilterUnreadStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterUnreadStateProvider).mangaList;
  @override
  bool get isManga => (origin as MangaFilterUnreadStateProvider).isManga;
  @override
  Settings get settings => (origin as MangaFilterUnreadStateProvider).settings;
}

String _$mangaFilterStartedStateHash() =>
    r'efa905f9035f3f16a692d4e9e5e87576edf25bcc';

abstract class _$MangaFilterStartedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  });
}

/// See also [MangaFilterStartedState].
@ProviderFor(MangaFilterStartedState)
const mangaFilterStartedStateProvider = MangaFilterStartedStateFamily();

/// See also [MangaFilterStartedState].
class MangaFilterStartedStateFamily extends Family<int> {
  /// See also [MangaFilterStartedState].
  const MangaFilterStartedStateFamily();

  /// See also [MangaFilterStartedState].
  MangaFilterStartedStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) {
    return MangaFilterStartedStateProvider(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  MangaFilterStartedStateProvider getProviderOverride(
    covariant MangaFilterStartedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'mangaFilterStartedStateProvider';
}

/// See also [MangaFilterStartedState].
class MangaFilterStartedStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterStartedState, int> {
  /// See also [MangaFilterStartedState].
  MangaFilterStartedStateProvider({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => MangaFilterStartedState()
            ..mangaList = mangaList
            ..isManga = isManga
            ..settings = settings,
          from: mangaFilterStartedStateProvider,
          name: r'mangaFilterStartedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterStartedStateHash,
          dependencies: MangaFilterStartedStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterStartedStateFamily._allTransitiveDependencies,
          mangaList: mangaList,
          isManga: isManga,
          settings: settings,
        );

  MangaFilterStartedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final bool isManga;
  final Settings settings;

  @override
  int runNotifierBuild(
    covariant MangaFilterStartedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterStartedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterStartedStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterStartedState, int>
      createElement() {
    return _MangaFilterStartedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterStartedStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterStartedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterStartedStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterStartedState, int>
    with MangaFilterStartedStateRef {
  _MangaFilterStartedStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterStartedStateProvider).mangaList;
  @override
  bool get isManga => (origin as MangaFilterStartedStateProvider).isManga;
  @override
  Settings get settings => (origin as MangaFilterStartedStateProvider).settings;
}

String _$mangaFilterBookmarkedStateHash() =>
    r'79c35342a6f5457a5070c3d7fd2e1cf3783e9816';

abstract class _$MangaFilterBookmarkedState
    extends BuildlessAutoDisposeNotifier<int> {
  late final List<Manga> mangaList;
  late final bool isManga;
  late final Settings settings;

  int build({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  });
}

/// See also [MangaFilterBookmarkedState].
@ProviderFor(MangaFilterBookmarkedState)
const mangaFilterBookmarkedStateProvider = MangaFilterBookmarkedStateFamily();

/// See also [MangaFilterBookmarkedState].
class MangaFilterBookmarkedStateFamily extends Family<int> {
  /// See also [MangaFilterBookmarkedState].
  const MangaFilterBookmarkedStateFamily();

  /// See also [MangaFilterBookmarkedState].
  MangaFilterBookmarkedStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) {
    return MangaFilterBookmarkedStateProvider(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  MangaFilterBookmarkedStateProvider getProviderOverride(
    covariant MangaFilterBookmarkedStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'mangaFilterBookmarkedStateProvider';
}

/// See also [MangaFilterBookmarkedState].
class MangaFilterBookmarkedStateProvider
    extends AutoDisposeNotifierProviderImpl<MangaFilterBookmarkedState, int> {
  /// See also [MangaFilterBookmarkedState].
  MangaFilterBookmarkedStateProvider({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => MangaFilterBookmarkedState()
            ..mangaList = mangaList
            ..isManga = isManga
            ..settings = settings,
          from: mangaFilterBookmarkedStateProvider,
          name: r'mangaFilterBookmarkedStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaFilterBookmarkedStateHash,
          dependencies: MangaFilterBookmarkedStateFamily._dependencies,
          allTransitiveDependencies:
              MangaFilterBookmarkedStateFamily._allTransitiveDependencies,
          mangaList: mangaList,
          isManga: isManga,
          settings: settings,
        );

  MangaFilterBookmarkedStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final bool isManga;
  final Settings settings;

  @override
  int runNotifierBuild(
    covariant MangaFilterBookmarkedState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangaFilterBookmarkedState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangaFilterBookmarkedStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangaFilterBookmarkedState, int>
      createElement() {
    return _MangaFilterBookmarkedStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFilterBookmarkedStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangaFilterBookmarkedStateRef on AutoDisposeNotifierProviderRef<int> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangaFilterBookmarkedStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangaFilterBookmarkedState, int>
    with MangaFilterBookmarkedStateRef {
  _MangaFilterBookmarkedStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangaFilterBookmarkedStateProvider).mangaList;
  @override
  bool get isManga => (origin as MangaFilterBookmarkedStateProvider).isManga;
  @override
  Settings get settings =>
      (origin as MangaFilterBookmarkedStateProvider).settings;
}

String _$mangasFilterResultStateHash() =>
    r'059fbe356805144bb533d4827d2c91b82aa3be10';

abstract class _$MangasFilterResultState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final List<Manga> mangaList;
  late final bool isManga;
  late final Settings settings;

  bool build({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  });
}

/// See also [MangasFilterResultState].
@ProviderFor(MangasFilterResultState)
const mangasFilterResultStateProvider = MangasFilterResultStateFamily();

/// See also [MangasFilterResultState].
class MangasFilterResultStateFamily extends Family<bool> {
  /// See also [MangasFilterResultState].
  const MangasFilterResultStateFamily();

  /// See also [MangasFilterResultState].
  MangasFilterResultStateProvider call({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) {
    return MangasFilterResultStateProvider(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  MangasFilterResultStateProvider getProviderOverride(
    covariant MangasFilterResultStateProvider provider,
  ) {
    return call(
      mangaList: provider.mangaList,
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'mangasFilterResultStateProvider';
}

/// See also [MangasFilterResultState].
class MangasFilterResultStateProvider
    extends AutoDisposeNotifierProviderImpl<MangasFilterResultState, bool> {
  /// See also [MangasFilterResultState].
  MangasFilterResultStateProvider({
    required List<Manga> mangaList,
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => MangasFilterResultState()
            ..mangaList = mangaList
            ..isManga = isManga
            ..settings = settings,
          from: mangasFilterResultStateProvider,
          name: r'mangasFilterResultStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangasFilterResultStateHash,
          dependencies: MangasFilterResultStateFamily._dependencies,
          allTransitiveDependencies:
              MangasFilterResultStateFamily._allTransitiveDependencies,
          mangaList: mangaList,
          isManga: isManga,
          settings: settings,
        );

  MangasFilterResultStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaList,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final List<Manga> mangaList;
  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant MangasFilterResultState notifier,
  ) {
    return notifier.build(
      mangaList: mangaList,
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(MangasFilterResultState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangasFilterResultStateProvider._internal(
        () => create()
          ..mangaList = mangaList
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaList: mangaList,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangasFilterResultState, bool>
      createElement() {
    return _MangasFilterResultStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangasFilterResultStateProvider &&
        other.mangaList == mangaList &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaList.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangasFilterResultStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `mangaList` of this provider.
  List<Manga> get mangaList;

  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _MangasFilterResultStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangasFilterResultState, bool>
    with MangasFilterResultStateRef {
  _MangasFilterResultStateProviderElement(super.provider);

  @override
  List<Manga> get mangaList =>
      (origin as MangasFilterResultStateProvider).mangaList;
  @override
  bool get isManga => (origin as MangasFilterResultStateProvider).isManga;
  @override
  Settings get settings => (origin as MangasFilterResultStateProvider).settings;
}

String _$libraryShowCategoryTabsStateHash() =>
    r'a524ac1cc70a3e95ad18922c1ee0f5cd5a053bba';

abstract class _$LibraryShowCategoryTabsState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;
  late final Settings settings;

  bool build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryShowCategoryTabsState].
@ProviderFor(LibraryShowCategoryTabsState)
const libraryShowCategoryTabsStateProvider =
    LibraryShowCategoryTabsStateFamily();

/// See also [LibraryShowCategoryTabsState].
class LibraryShowCategoryTabsStateFamily extends Family<bool> {
  /// See also [LibraryShowCategoryTabsState].
  const LibraryShowCategoryTabsStateFamily();

  /// See also [LibraryShowCategoryTabsState].
  LibraryShowCategoryTabsStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryShowCategoryTabsStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryShowCategoryTabsStateProvider getProviderOverride(
    covariant LibraryShowCategoryTabsStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryShowCategoryTabsStateProvider';
}

/// See also [LibraryShowCategoryTabsState].
class LibraryShowCategoryTabsStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryShowCategoryTabsState,
        bool> {
  /// See also [LibraryShowCategoryTabsState].
  LibraryShowCategoryTabsStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryShowCategoryTabsState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryShowCategoryTabsStateProvider,
          name: r'libraryShowCategoryTabsStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryShowCategoryTabsStateHash,
          dependencies: LibraryShowCategoryTabsStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryShowCategoryTabsStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryShowCategoryTabsStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryShowCategoryTabsState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(LibraryShowCategoryTabsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryShowCategoryTabsStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryShowCategoryTabsState, bool>
      createElement() {
    return _LibraryShowCategoryTabsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowCategoryTabsStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryShowCategoryTabsStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryShowCategoryTabsStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryShowCategoryTabsState,
        bool> with LibraryShowCategoryTabsStateRef {
  _LibraryShowCategoryTabsStateProviderElement(super.provider);

  @override
  bool get isManga => (origin as LibraryShowCategoryTabsStateProvider).isManga;
  @override
  Settings get settings =>
      (origin as LibraryShowCategoryTabsStateProvider).settings;
}

String _$libraryDownloadedChaptersStateHash() =>
    r'05c54e4b3c1c72471a45c0111689632c61b02270';

abstract class _$LibraryDownloadedChaptersState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;
  late final Settings settings;

  bool build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryDownloadedChaptersState].
@ProviderFor(LibraryDownloadedChaptersState)
const libraryDownloadedChaptersStateProvider =
    LibraryDownloadedChaptersStateFamily();

/// See also [LibraryDownloadedChaptersState].
class LibraryDownloadedChaptersStateFamily extends Family<bool> {
  /// See also [LibraryDownloadedChaptersState].
  const LibraryDownloadedChaptersStateFamily();

  /// See also [LibraryDownloadedChaptersState].
  LibraryDownloadedChaptersStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryDownloadedChaptersStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryDownloadedChaptersStateProvider getProviderOverride(
    covariant LibraryDownloadedChaptersStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryDownloadedChaptersStateProvider';
}

/// See also [LibraryDownloadedChaptersState].
class LibraryDownloadedChaptersStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryDownloadedChaptersState,
        bool> {
  /// See also [LibraryDownloadedChaptersState].
  LibraryDownloadedChaptersStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryDownloadedChaptersState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryDownloadedChaptersStateProvider,
          name: r'libraryDownloadedChaptersStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryDownloadedChaptersStateHash,
          dependencies: LibraryDownloadedChaptersStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryDownloadedChaptersStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryDownloadedChaptersStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryDownloadedChaptersState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(LibraryDownloadedChaptersState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryDownloadedChaptersStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryDownloadedChaptersState, bool>
      createElement() {
    return _LibraryDownloadedChaptersStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDownloadedChaptersStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryDownloadedChaptersStateRef
    on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryDownloadedChaptersStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryDownloadedChaptersState,
        bool> with LibraryDownloadedChaptersStateRef {
  _LibraryDownloadedChaptersStateProviderElement(super.provider);

  @override
  bool get isManga =>
      (origin as LibraryDownloadedChaptersStateProvider).isManga;
  @override
  Settings get settings =>
      (origin as LibraryDownloadedChaptersStateProvider).settings;
}

String _$libraryLanguageStateHash() =>
    r'cb1de769720e61fd817cb399093d645c63849523';

abstract class _$LibraryLanguageState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;
  late final Settings settings;

  bool build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryLanguageState].
@ProviderFor(LibraryLanguageState)
const libraryLanguageStateProvider = LibraryLanguageStateFamily();

/// See also [LibraryLanguageState].
class LibraryLanguageStateFamily extends Family<bool> {
  /// See also [LibraryLanguageState].
  const LibraryLanguageStateFamily();

  /// See also [LibraryLanguageState].
  LibraryLanguageStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryLanguageStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryLanguageStateProvider getProviderOverride(
    covariant LibraryLanguageStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryLanguageStateProvider';
}

/// See also [LibraryLanguageState].
class LibraryLanguageStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryLanguageState, bool> {
  /// See also [LibraryLanguageState].
  LibraryLanguageStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryLanguageState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryLanguageStateProvider,
          name: r'libraryLanguageStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryLanguageStateHash,
          dependencies: LibraryLanguageStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryLanguageStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryLanguageStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryLanguageState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(LibraryLanguageState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryLanguageStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryLanguageState, bool>
      createElement() {
    return _LibraryLanguageStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLanguageStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryLanguageStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryLanguageStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryLanguageState, bool>
    with LibraryLanguageStateRef {
  _LibraryLanguageStateProviderElement(super.provider);

  @override
  bool get isManga => (origin as LibraryLanguageStateProvider).isManga;
  @override
  Settings get settings => (origin as LibraryLanguageStateProvider).settings;
}

String _$libraryLocalSourceStateHash() =>
    r'fe0e297b299d2dbb9dea8d47a7c644a0779a5206';

abstract class _$LibraryLocalSourceState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;
  late final Settings settings;

  bool build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryLocalSourceState].
@ProviderFor(LibraryLocalSourceState)
const libraryLocalSourceStateProvider = LibraryLocalSourceStateFamily();

/// See also [LibraryLocalSourceState].
class LibraryLocalSourceStateFamily extends Family<bool> {
  /// See also [LibraryLocalSourceState].
  const LibraryLocalSourceStateFamily();

  /// See also [LibraryLocalSourceState].
  LibraryLocalSourceStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryLocalSourceStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryLocalSourceStateProvider getProviderOverride(
    covariant LibraryLocalSourceStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryLocalSourceStateProvider';
}

/// See also [LibraryLocalSourceState].
class LibraryLocalSourceStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryLocalSourceState, bool> {
  /// See also [LibraryLocalSourceState].
  LibraryLocalSourceStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryLocalSourceState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryLocalSourceStateProvider,
          name: r'libraryLocalSourceStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryLocalSourceStateHash,
          dependencies: LibraryLocalSourceStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryLocalSourceStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryLocalSourceStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryLocalSourceState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(LibraryLocalSourceState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryLocalSourceStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryLocalSourceState, bool>
      createElement() {
    return _LibraryLocalSourceStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLocalSourceStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryLocalSourceStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryLocalSourceStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryLocalSourceState, bool>
    with LibraryLocalSourceStateRef {
  _LibraryLocalSourceStateProviderElement(super.provider);

  @override
  bool get isManga => (origin as LibraryLocalSourceStateProvider).isManga;
  @override
  Settings get settings => (origin as LibraryLocalSourceStateProvider).settings;
}

String _$libraryShowNumbersOfItemsStateHash() =>
    r'4845c2b9d553f12b74b7f7f33ad0802310e7820c';

abstract class _$LibraryShowNumbersOfItemsState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;
  late final Settings settings;

  bool build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryShowNumbersOfItemsState].
@ProviderFor(LibraryShowNumbersOfItemsState)
const libraryShowNumbersOfItemsStateProvider =
    LibraryShowNumbersOfItemsStateFamily();

/// See also [LibraryShowNumbersOfItemsState].
class LibraryShowNumbersOfItemsStateFamily extends Family<bool> {
  /// See also [LibraryShowNumbersOfItemsState].
  const LibraryShowNumbersOfItemsStateFamily();

  /// See also [LibraryShowNumbersOfItemsState].
  LibraryShowNumbersOfItemsStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryShowNumbersOfItemsStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryShowNumbersOfItemsStateProvider getProviderOverride(
    covariant LibraryShowNumbersOfItemsStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryShowNumbersOfItemsStateProvider';
}

/// See also [LibraryShowNumbersOfItemsState].
class LibraryShowNumbersOfItemsStateProvider
    extends AutoDisposeNotifierProviderImpl<LibraryShowNumbersOfItemsState,
        bool> {
  /// See also [LibraryShowNumbersOfItemsState].
  LibraryShowNumbersOfItemsStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryShowNumbersOfItemsState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryShowNumbersOfItemsStateProvider,
          name: r'libraryShowNumbersOfItemsStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryShowNumbersOfItemsStateHash,
          dependencies: LibraryShowNumbersOfItemsStateFamily._dependencies,
          allTransitiveDependencies:
              LibraryShowNumbersOfItemsStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryShowNumbersOfItemsStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryShowNumbersOfItemsState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(LibraryShowNumbersOfItemsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryShowNumbersOfItemsStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryShowNumbersOfItemsState, bool>
      createElement() {
    return _LibraryShowNumbersOfItemsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowNumbersOfItemsStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryShowNumbersOfItemsStateRef
    on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryShowNumbersOfItemsStateProviderElement
    extends AutoDisposeNotifierProviderElement<LibraryShowNumbersOfItemsState,
        bool> with LibraryShowNumbersOfItemsStateRef {
  _LibraryShowNumbersOfItemsStateProviderElement(super.provider);

  @override
  bool get isManga =>
      (origin as LibraryShowNumbersOfItemsStateProvider).isManga;
  @override
  Settings get settings =>
      (origin as LibraryShowNumbersOfItemsStateProvider).settings;
}

String _$libraryShowContinueReadingButtonStateHash() =>
    r'2506c6fca9f930a37cb4dfc8efab8914c0e577e8';

abstract class _$LibraryShowContinueReadingButtonState
    extends BuildlessAutoDisposeNotifier<bool> {
  late final bool isManga;
  late final Settings settings;

  bool build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [LibraryShowContinueReadingButtonState].
@ProviderFor(LibraryShowContinueReadingButtonState)
const libraryShowContinueReadingButtonStateProvider =
    LibraryShowContinueReadingButtonStateFamily();

/// See also [LibraryShowContinueReadingButtonState].
class LibraryShowContinueReadingButtonStateFamily extends Family<bool> {
  /// See also [LibraryShowContinueReadingButtonState].
  const LibraryShowContinueReadingButtonStateFamily();

  /// See also [LibraryShowContinueReadingButtonState].
  LibraryShowContinueReadingButtonStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return LibraryShowContinueReadingButtonStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  LibraryShowContinueReadingButtonStateProvider getProviderOverride(
    covariant LibraryShowContinueReadingButtonStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'libraryShowContinueReadingButtonStateProvider';
}

/// See also [LibraryShowContinueReadingButtonState].
class LibraryShowContinueReadingButtonStateProvider
    extends AutoDisposeNotifierProviderImpl<
        LibraryShowContinueReadingButtonState, bool> {
  /// See also [LibraryShowContinueReadingButtonState].
  LibraryShowContinueReadingButtonStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => LibraryShowContinueReadingButtonState()
            ..isManga = isManga
            ..settings = settings,
          from: libraryShowContinueReadingButtonStateProvider,
          name: r'libraryShowContinueReadingButtonStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$libraryShowContinueReadingButtonStateHash,
          dependencies:
              LibraryShowContinueReadingButtonStateFamily._dependencies,
          allTransitiveDependencies: LibraryShowContinueReadingButtonStateFamily
              ._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  LibraryShowContinueReadingButtonStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  bool runNotifierBuild(
    covariant LibraryShowContinueReadingButtonState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(
      LibraryShowContinueReadingButtonState Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryShowContinueReadingButtonStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<LibraryShowContinueReadingButtonState,
      bool> createElement() {
    return _LibraryShowContinueReadingButtonStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowContinueReadingButtonStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryShowContinueReadingButtonStateRef
    on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _LibraryShowContinueReadingButtonStateProviderElement
    extends AutoDisposeNotifierProviderElement<
        LibraryShowContinueReadingButtonState,
        bool> with LibraryShowContinueReadingButtonStateRef {
  _LibraryShowContinueReadingButtonStateProviderElement(super.provider);

  @override
  bool get isManga =>
      (origin as LibraryShowContinueReadingButtonStateProvider).isManga;
  @override
  Settings get settings =>
      (origin as LibraryShowContinueReadingButtonStateProvider).settings;
}

String _$sortLibraryMangaStateHash() =>
    r'28ed314e823a489eb520501479bdccebbbedb0e8';

abstract class _$SortLibraryMangaState
    extends BuildlessAutoDisposeNotifier<SortLibraryManga> {
  late final bool isManga;
  late final Settings settings;

  SortLibraryManga build({
    required bool isManga,
    required Settings settings,
  });
}

/// See also [SortLibraryMangaState].
@ProviderFor(SortLibraryMangaState)
const sortLibraryMangaStateProvider = SortLibraryMangaStateFamily();

/// See also [SortLibraryMangaState].
class SortLibraryMangaStateFamily extends Family<SortLibraryManga> {
  /// See also [SortLibraryMangaState].
  const SortLibraryMangaStateFamily();

  /// See also [SortLibraryMangaState].
  SortLibraryMangaStateProvider call({
    required bool isManga,
    required Settings settings,
  }) {
    return SortLibraryMangaStateProvider(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  SortLibraryMangaStateProvider getProviderOverride(
    covariant SortLibraryMangaStateProvider provider,
  ) {
    return call(
      isManga: provider.isManga,
      settings: provider.settings,
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
  String? get name => r'sortLibraryMangaStateProvider';
}

/// See also [SortLibraryMangaState].
class SortLibraryMangaStateProvider extends AutoDisposeNotifierProviderImpl<
    SortLibraryMangaState, SortLibraryManga> {
  /// See also [SortLibraryMangaState].
  SortLibraryMangaStateProvider({
    required bool isManga,
    required Settings settings,
  }) : this._internal(
          () => SortLibraryMangaState()
            ..isManga = isManga
            ..settings = settings,
          from: sortLibraryMangaStateProvider,
          name: r'sortLibraryMangaStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sortLibraryMangaStateHash,
          dependencies: SortLibraryMangaStateFamily._dependencies,
          allTransitiveDependencies:
              SortLibraryMangaStateFamily._allTransitiveDependencies,
          isManga: isManga,
          settings: settings,
        );

  SortLibraryMangaStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.isManga,
    required this.settings,
  }) : super.internal();

  final bool isManga;
  final Settings settings;

  @override
  SortLibraryManga runNotifierBuild(
    covariant SortLibraryMangaState notifier,
  ) {
    return notifier.build(
      isManga: isManga,
      settings: settings,
    );
  }

  @override
  Override overrideWith(SortLibraryMangaState Function() create) {
    return ProviderOverride(
      origin: this,
      override: SortLibraryMangaStateProvider._internal(
        () => create()
          ..isManga = isManga
          ..settings = settings,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        isManga: isManga,
        settings: settings,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SortLibraryMangaState, SortLibraryManga>
      createElement() {
    return _SortLibraryMangaStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SortLibraryMangaStateProvider &&
        other.isManga == isManga &&
        other.settings == settings;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, isManga.hashCode);
    hash = _SystemHash.combine(hash, settings.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SortLibraryMangaStateRef
    on AutoDisposeNotifierProviderRef<SortLibraryManga> {
  /// The parameter `isManga` of this provider.
  bool get isManga;

  /// The parameter `settings` of this provider.
  Settings get settings;
}

class _SortLibraryMangaStateProviderElement
    extends AutoDisposeNotifierProviderElement<SortLibraryMangaState,
        SortLibraryManga> with SortLibraryMangaStateRef {
  _SortLibraryMangaStateProviderElement(super.provider);

  @override
  bool get isManga => (origin as SortLibraryMangaStateProvider).isManga;
  @override
  Settings get settings => (origin as SortLibraryMangaStateProvider).settings;
}

String _$mangasListStateHash() => r'5a3f1a7aec1576af25bd071db4081654fc600b62';

/// See also [MangasListState].
@ProviderFor(MangasListState)
final mangasListStateProvider =
    AutoDisposeNotifierProvider<MangasListState, List<int>>.internal(
  MangasListState.new,
  name: r'mangasListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mangasListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MangasListState = AutoDisposeNotifier<List<int>>;
String _$isLongPressedMangaStateHash() =>
    r'f77076b0335e92df26a75ea0c338d4214a330184';

/// See also [IsLongPressedMangaState].
@ProviderFor(IsLongPressedMangaState)
final isLongPressedMangaStateProvider =
    AutoDisposeNotifierProvider<IsLongPressedMangaState, bool>.internal(
  IsLongPressedMangaState.new,
  name: r'isLongPressedMangaStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLongPressedMangaStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsLongPressedMangaState = AutoDisposeNotifier<bool>;
String _$mangasSetIsReadStateHash() =>
    r'cb88914fe1c47c1e3a29d43c23a6652b0e8f2ac1';

abstract class _$MangasSetIsReadState
    extends BuildlessAutoDisposeNotifier<void> {
  late final List<int> mangaIds;

  void build({
    required List<int> mangaIds,
  });
}

/// See also [MangasSetIsReadState].
@ProviderFor(MangasSetIsReadState)
const mangasSetIsReadStateProvider = MangasSetIsReadStateFamily();

/// See also [MangasSetIsReadState].
class MangasSetIsReadStateFamily extends Family<void> {
  /// See also [MangasSetIsReadState].
  const MangasSetIsReadStateFamily();

  /// See also [MangasSetIsReadState].
  MangasSetIsReadStateProvider call({
    required List<int> mangaIds,
  }) {
    return MangasSetIsReadStateProvider(
      mangaIds: mangaIds,
    );
  }

  @override
  MangasSetIsReadStateProvider getProviderOverride(
    covariant MangasSetIsReadStateProvider provider,
  ) {
    return call(
      mangaIds: provider.mangaIds,
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
  String? get name => r'mangasSetIsReadStateProvider';
}

/// See also [MangasSetIsReadState].
class MangasSetIsReadStateProvider
    extends AutoDisposeNotifierProviderImpl<MangasSetIsReadState, void> {
  /// See also [MangasSetIsReadState].
  MangasSetIsReadStateProvider({
    required List<int> mangaIds,
  }) : this._internal(
          () => MangasSetIsReadState()..mangaIds = mangaIds,
          from: mangasSetIsReadStateProvider,
          name: r'mangasSetIsReadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangasSetIsReadStateHash,
          dependencies: MangasSetIsReadStateFamily._dependencies,
          allTransitiveDependencies:
              MangasSetIsReadStateFamily._allTransitiveDependencies,
          mangaIds: mangaIds,
        );

  MangasSetIsReadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaIds,
  }) : super.internal();

  final List<int> mangaIds;

  @override
  void runNotifierBuild(
    covariant MangasSetIsReadState notifier,
  ) {
    return notifier.build(
      mangaIds: mangaIds,
    );
  }

  @override
  Override overrideWith(MangasSetIsReadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangasSetIsReadStateProvider._internal(
        () => create()..mangaIds = mangaIds,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaIds: mangaIds,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangasSetIsReadState, void>
      createElement() {
    return _MangasSetIsReadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangasSetIsReadStateProvider && other.mangaIds == mangaIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangasSetIsReadStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `mangaIds` of this provider.
  List<int> get mangaIds;
}

class _MangasSetIsReadStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangasSetIsReadState, void>
    with MangasSetIsReadStateRef {
  _MangasSetIsReadStateProviderElement(super.provider);

  @override
  List<int> get mangaIds => (origin as MangasSetIsReadStateProvider).mangaIds;
}

String _$mangasSetUnReadStateHash() =>
    r'7b2f4c579f9cb392830ed4d70aff9ccc3e7952a0';

abstract class _$MangasSetUnReadState
    extends BuildlessAutoDisposeNotifier<void> {
  late final List<int> mangaIds;

  void build({
    required List<int> mangaIds,
  });
}

/// See also [MangasSetUnReadState].
@ProviderFor(MangasSetUnReadState)
const mangasSetUnReadStateProvider = MangasSetUnReadStateFamily();

/// See also [MangasSetUnReadState].
class MangasSetUnReadStateFamily extends Family<void> {
  /// See also [MangasSetUnReadState].
  const MangasSetUnReadStateFamily();

  /// See also [MangasSetUnReadState].
  MangasSetUnReadStateProvider call({
    required List<int> mangaIds,
  }) {
    return MangasSetUnReadStateProvider(
      mangaIds: mangaIds,
    );
  }

  @override
  MangasSetUnReadStateProvider getProviderOverride(
    covariant MangasSetUnReadStateProvider provider,
  ) {
    return call(
      mangaIds: provider.mangaIds,
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
  String? get name => r'mangasSetUnReadStateProvider';
}

/// See also [MangasSetUnReadState].
class MangasSetUnReadStateProvider
    extends AutoDisposeNotifierProviderImpl<MangasSetUnReadState, void> {
  /// See also [MangasSetUnReadState].
  MangasSetUnReadStateProvider({
    required List<int> mangaIds,
  }) : this._internal(
          () => MangasSetUnReadState()..mangaIds = mangaIds,
          from: mangasSetUnReadStateProvider,
          name: r'mangasSetUnReadStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangasSetUnReadStateHash,
          dependencies: MangasSetUnReadStateFamily._dependencies,
          allTransitiveDependencies:
              MangasSetUnReadStateFamily._allTransitiveDependencies,
          mangaIds: mangaIds,
        );

  MangasSetUnReadStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaIds,
  }) : super.internal();

  final List<int> mangaIds;

  @override
  void runNotifierBuild(
    covariant MangasSetUnReadState notifier,
  ) {
    return notifier.build(
      mangaIds: mangaIds,
    );
  }

  @override
  Override overrideWith(MangasSetUnReadState Function() create) {
    return ProviderOverride(
      origin: this,
      override: MangasSetUnReadStateProvider._internal(
        () => create()..mangaIds = mangaIds,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaIds: mangaIds,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<MangasSetUnReadState, void>
      createElement() {
    return _MangasSetUnReadStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangasSetUnReadStateProvider && other.mangaIds == mangaIds;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaIds.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MangasSetUnReadStateRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `mangaIds` of this provider.
  List<int> get mangaIds;
}

class _MangasSetUnReadStateProviderElement
    extends AutoDisposeNotifierProviderElement<MangasSetUnReadState, void>
    with MangasSetUnReadStateRef {
  _MangasSetUnReadStateProviderElement(super.provider);

  @override
  List<int> get mangaIds => (origin as MangasSetUnReadStateProvider).mangaIds;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
