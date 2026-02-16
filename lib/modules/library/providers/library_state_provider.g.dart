// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryDisplayTypeState)
final libraryDisplayTypeStateProvider = LibraryDisplayTypeStateFamily._();

final class LibraryDisplayTypeStateProvider
    extends $NotifierProvider<LibraryDisplayTypeState, DisplayType> {
  LibraryDisplayTypeStateProvider._({
    required LibraryDisplayTypeStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryDisplayTypeStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryDisplayTypeStateHash();

  @override
  String toString() {
    return r'libraryDisplayTypeStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryDisplayTypeState create() => LibraryDisplayTypeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisplayType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisplayType>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDisplayTypeStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryDisplayTypeStateHash() =>
    r'395cdbf1f2d7d335d099c18439bd575082caeb64';

final class LibraryDisplayTypeStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryDisplayTypeState,
          DisplayType,
          DisplayType,
          DisplayType,
          ({ItemType itemType, Settings settings})
        > {
  LibraryDisplayTypeStateFamily._()
    : super(
        retry: null,
        name: r'libraryDisplayTypeStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryDisplayTypeStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryDisplayTypeStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryDisplayTypeStateProvider';
}

abstract class _$LibraryDisplayTypeState extends $Notifier<DisplayType> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  DisplayType build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DisplayType, DisplayType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DisplayType, DisplayType>,
              DisplayType,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryGridSizeState)
final libraryGridSizeStateProvider = LibraryGridSizeStateFamily._();

final class LibraryGridSizeStateProvider
    extends $NotifierProvider<LibraryGridSizeState, int?> {
  LibraryGridSizeStateProvider._({
    required LibraryGridSizeStateFamily super.from,
    required ItemType super.argument,
  }) : super(
         retry: null,
         name: r'libraryGridSizeStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryGridSizeStateHash();

  @override
  String toString() {
    return r'libraryGridSizeStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LibraryGridSizeState create() => LibraryGridSizeState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryGridSizeStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryGridSizeStateHash() =>
    r'9c0748259efe8cce423ba4ef9f3a99a73ee3f2de';

final class LibraryGridSizeStateFamily extends $Family
    with
        $ClassFamilyOverride<LibraryGridSizeState, int?, int?, int?, ItemType> {
  LibraryGridSizeStateFamily._()
    : super(
        retry: null,
        name: r'libraryGridSizeStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryGridSizeStateProvider call({required ItemType itemType}) =>
      LibraryGridSizeStateProvider._(argument: itemType, from: this);

  @override
  String toString() => r'libraryGridSizeStateProvider';
}

abstract class _$LibraryGridSizeState extends $Notifier<int?> {
  late final _$args = ref.$arg as ItemType;
  ItemType get itemType => _$args;

  int? build({required ItemType itemType});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(itemType: _$args));
  }
}

@ProviderFor(MangaFiltersState)
final mangaFiltersStateProvider = MangaFiltersStateFamily._();

final class MangaFiltersStateProvider
    extends $NotifierProvider<MangaFiltersState, MangaFilter> {
  MangaFiltersStateProvider._({
    required MangaFiltersStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'mangaFiltersStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangaFiltersStateHash();

  @override
  String toString() {
    return r'mangaFiltersStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangaFiltersState create() => MangaFiltersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MangaFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MangaFilter>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangaFiltersStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangaFiltersStateHash() => r'20a9a9ab1b1ba7b9b5ff332da74cf934b35dc28b';

final class MangaFiltersStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangaFiltersState,
          MangaFilter,
          MangaFilter,
          MangaFilter,
          ({ItemType itemType, Settings settings})
        > {
  MangaFiltersStateFamily._()
    : super(
        retry: null,
        name: r'mangaFiltersStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangaFiltersStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => MangaFiltersStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangaFiltersStateProvider';
}

abstract class _$MangaFiltersState extends $Notifier<MangaFilter> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  MangaFilter build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MangaFilter, MangaFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MangaFilter, MangaFilter>,
              MangaFilter,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(MangasFilterResultState)
final mangasFilterResultStateProvider = MangasFilterResultStateFamily._();

final class MangasFilterResultStateProvider
    extends $NotifierProvider<MangasFilterResultState, bool> {
  MangasFilterResultStateProvider._({
    required MangasFilterResultStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'mangasFilterResultStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangasFilterResultStateHash();

  @override
  String toString() {
    return r'mangasFilterResultStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MangasFilterResultState create() => MangasFilterResultState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangasFilterResultStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangasFilterResultStateHash() =>
    r'a01bc6668724e3f9336c6c86392bcf5c209f16c7';

final class MangasFilterResultStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangasFilterResultState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  MangasFilterResultStateFamily._()
    : super(
        retry: null,
        name: r'mangasFilterResultStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangasFilterResultStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => MangasFilterResultStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'mangasFilterResultStateProvider';
}

abstract class _$MangasFilterResultState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryShowCategoryTabsState)
final libraryShowCategoryTabsStateProvider =
    LibraryShowCategoryTabsStateFamily._();

final class LibraryShowCategoryTabsStateProvider
    extends $NotifierProvider<LibraryShowCategoryTabsState, bool> {
  LibraryShowCategoryTabsStateProvider._({
    required LibraryShowCategoryTabsStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryShowCategoryTabsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryShowCategoryTabsStateHash();

  @override
  String toString() {
    return r'libraryShowCategoryTabsStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryShowCategoryTabsState create() => LibraryShowCategoryTabsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowCategoryTabsStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryShowCategoryTabsStateHash() =>
    r'59bbef3139c88b91e54c743dfd6fbd7f8090ab0d';

final class LibraryShowCategoryTabsStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryShowCategoryTabsState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryShowCategoryTabsStateFamily._()
    : super(
        retry: null,
        name: r'libraryShowCategoryTabsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryShowCategoryTabsStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryShowCategoryTabsStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryShowCategoryTabsStateProvider';
}

abstract class _$LibraryShowCategoryTabsState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryDownloadedChaptersState)
final libraryDownloadedChaptersStateProvider =
    LibraryDownloadedChaptersStateFamily._();

final class LibraryDownloadedChaptersStateProvider
    extends $NotifierProvider<LibraryDownloadedChaptersState, bool> {
  LibraryDownloadedChaptersStateProvider._({
    required LibraryDownloadedChaptersStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryDownloadedChaptersStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryDownloadedChaptersStateHash();

  @override
  String toString() {
    return r'libraryDownloadedChaptersStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryDownloadedChaptersState create() => LibraryDownloadedChaptersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDownloadedChaptersStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryDownloadedChaptersStateHash() =>
    r'87552c70dbe83509a4e7d2940b4e5e3a2d1bbe43';

final class LibraryDownloadedChaptersStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryDownloadedChaptersState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryDownloadedChaptersStateFamily._()
    : super(
        retry: null,
        name: r'libraryDownloadedChaptersStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryDownloadedChaptersStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryDownloadedChaptersStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryDownloadedChaptersStateProvider';
}

abstract class _$LibraryDownloadedChaptersState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryUnreadChaptersState)
final libraryUnreadChaptersStateProvider = LibraryUnreadChaptersStateFamily._();

final class LibraryUnreadChaptersStateProvider
    extends $NotifierProvider<LibraryUnreadChaptersState, bool> {
  LibraryUnreadChaptersStateProvider._({
    required LibraryUnreadChaptersStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryUnreadChaptersStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryUnreadChaptersStateHash();

  @override
  String toString() {
    return r'libraryUnreadChaptersStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryUnreadChaptersState create() => LibraryUnreadChaptersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryUnreadChaptersStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryUnreadChaptersStateHash() =>
    r'5835430b88d7903f83932cd6c9e0a07c97c4cae0';

final class LibraryUnreadChaptersStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryUnreadChaptersState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryUnreadChaptersStateFamily._()
    : super(
        retry: null,
        name: r'libraryUnreadChaptersStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryUnreadChaptersStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryUnreadChaptersStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryUnreadChaptersStateProvider';
}

abstract class _$LibraryUnreadChaptersState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryLanguageState)
final libraryLanguageStateProvider = LibraryLanguageStateFamily._();

final class LibraryLanguageStateProvider
    extends $NotifierProvider<LibraryLanguageState, bool> {
  LibraryLanguageStateProvider._({
    required LibraryLanguageStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryLanguageStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryLanguageStateHash();

  @override
  String toString() {
    return r'libraryLanguageStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryLanguageState create() => LibraryLanguageState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLanguageStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryLanguageStateHash() =>
    r'8d65ce133148f78fb604fc07f2914343ad2edf2a';

final class LibraryLanguageStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryLanguageState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryLanguageStateFamily._()
    : super(
        retry: null,
        name: r'libraryLanguageStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryLanguageStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryLanguageStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryLanguageStateProvider';
}

abstract class _$LibraryLanguageState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryLocalSourceState)
final libraryLocalSourceStateProvider = LibraryLocalSourceStateFamily._();

final class LibraryLocalSourceStateProvider
    extends $NotifierProvider<LibraryLocalSourceState, bool> {
  LibraryLocalSourceStateProvider._({
    required LibraryLocalSourceStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryLocalSourceStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryLocalSourceStateHash();

  @override
  String toString() {
    return r'libraryLocalSourceStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryLocalSourceState create() => LibraryLocalSourceState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryLocalSourceStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryLocalSourceStateHash() =>
    r'4b632da7d310c540bfb047c47ade2681c5a6554f';

final class LibraryLocalSourceStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryLocalSourceState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryLocalSourceStateFamily._()
    : super(
        retry: null,
        name: r'libraryLocalSourceStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryLocalSourceStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryLocalSourceStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryLocalSourceStateProvider';
}

abstract class _$LibraryLocalSourceState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryShowNumbersOfItemsState)
final libraryShowNumbersOfItemsStateProvider =
    LibraryShowNumbersOfItemsStateFamily._();

final class LibraryShowNumbersOfItemsStateProvider
    extends $NotifierProvider<LibraryShowNumbersOfItemsState, bool> {
  LibraryShowNumbersOfItemsStateProvider._({
    required LibraryShowNumbersOfItemsStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryShowNumbersOfItemsStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryShowNumbersOfItemsStateHash();

  @override
  String toString() {
    return r'libraryShowNumbersOfItemsStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryShowNumbersOfItemsState create() => LibraryShowNumbersOfItemsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowNumbersOfItemsStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryShowNumbersOfItemsStateHash() =>
    r'ad8a3a975ea05020aaa5a9b2f4ffd34323b1ee6e';

final class LibraryShowNumbersOfItemsStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryShowNumbersOfItemsState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryShowNumbersOfItemsStateFamily._()
    : super(
        retry: null,
        name: r'libraryShowNumbersOfItemsStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryShowNumbersOfItemsStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryShowNumbersOfItemsStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryShowNumbersOfItemsStateProvider';
}

abstract class _$LibraryShowNumbersOfItemsState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(LibraryShowContinueReadingButtonState)
final libraryShowContinueReadingButtonStateProvider =
    LibraryShowContinueReadingButtonStateFamily._();

final class LibraryShowContinueReadingButtonStateProvider
    extends $NotifierProvider<LibraryShowContinueReadingButtonState, bool> {
  LibraryShowContinueReadingButtonStateProvider._({
    required LibraryShowContinueReadingButtonStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryShowContinueReadingButtonStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() =>
      _$libraryShowContinueReadingButtonStateHash();

  @override
  String toString() {
    return r'libraryShowContinueReadingButtonStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryShowContinueReadingButtonState create() =>
      LibraryShowContinueReadingButtonState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryShowContinueReadingButtonStateProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryShowContinueReadingButtonStateHash() =>
    r'd415c6b72f2fc74290f1f8600ef859312dd0db2b';

final class LibraryShowContinueReadingButtonStateFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryShowContinueReadingButtonState,
          bool,
          bool,
          bool,
          ({ItemType itemType, Settings settings})
        > {
  LibraryShowContinueReadingButtonStateFamily._()
    : super(
        retry: null,
        name: r'libraryShowContinueReadingButtonStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryShowContinueReadingButtonStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => LibraryShowContinueReadingButtonStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'libraryShowContinueReadingButtonStateProvider';
}

abstract class _$LibraryShowContinueReadingButtonState extends $Notifier<bool> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  bool build({required ItemType itemType, required Settings settings});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(SortLibraryMangaState)
final sortLibraryMangaStateProvider = SortLibraryMangaStateFamily._();

final class SortLibraryMangaStateProvider
    extends $NotifierProvider<SortLibraryMangaState, SortLibraryManga> {
  SortLibraryMangaStateProvider._({
    required SortLibraryMangaStateFamily super.from,
    required ({ItemType itemType, Settings settings}) super.argument,
  }) : super(
         retry: null,
         name: r'sortLibraryMangaStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sortLibraryMangaStateHash();

  @override
  String toString() {
    return r'sortLibraryMangaStateProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SortLibraryMangaState create() => SortLibraryMangaState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortLibraryManga value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortLibraryManga>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SortLibraryMangaStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sortLibraryMangaStateHash() =>
    r'8aaa1c25bd707c96d811edb0ef66131196240b96';

final class SortLibraryMangaStateFamily extends $Family
    with
        $ClassFamilyOverride<
          SortLibraryMangaState,
          SortLibraryManga,
          SortLibraryManga,
          SortLibraryManga,
          ({ItemType itemType, Settings settings})
        > {
  SortLibraryMangaStateFamily._()
    : super(
        retry: null,
        name: r'sortLibraryMangaStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SortLibraryMangaStateProvider call({
    required ItemType itemType,
    required Settings settings,
  }) => SortLibraryMangaStateProvider._(
    argument: (itemType: itemType, settings: settings),
    from: this,
  );

  @override
  String toString() => r'sortLibraryMangaStateProvider';
}

abstract class _$SortLibraryMangaState extends $Notifier<SortLibraryManga> {
  late final _$args = ref.$arg as ({ItemType itemType, Settings settings});
  ItemType get itemType => _$args.itemType;
  Settings get settings => _$args.settings;

  SortLibraryManga build({
    required ItemType itemType,
    required Settings settings,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SortLibraryManga, SortLibraryManga>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortLibraryManga, SortLibraryManga>,
              SortLibraryManga,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(itemType: _$args.itemType, settings: _$args.settings),
    );
  }
}

@ProviderFor(MangasListState)
final mangasListStateProvider = MangasListStateProvider._();

final class MangasListStateProvider
    extends $NotifierProvider<MangasListState, List<int>> {
  MangasListStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mangasListStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mangasListStateHash();

  @$internal
  @override
  MangasListState create() => MangasListState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<int>>(value),
    );
  }
}

String _$mangasListStateHash() => r'5a3f1a7aec1576af25bd071db4081654fc600b62';

abstract class _$MangasListState extends $Notifier<List<int>> {
  List<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<int>, List<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<int>, List<int>>,
              List<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(IsLongPressedMangaState)
final isLongPressedMangaStateProvider = IsLongPressedMangaStateProvider._();

final class IsLongPressedMangaStateProvider
    extends $NotifierProvider<IsLongPressedMangaState, bool> {
  IsLongPressedMangaStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isLongPressedMangaStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isLongPressedMangaStateHash();

  @$internal
  @override
  IsLongPressedMangaState create() => IsLongPressedMangaState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isLongPressedMangaStateHash() =>
    r'f77076b0335e92df26a75ea0c338d4214a330184';

abstract class _$IsLongPressedMangaState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(MangasSetIsReadState)
final mangasSetIsReadStateProvider = MangasSetIsReadStateFamily._();

final class MangasSetIsReadStateProvider
    extends $NotifierProvider<MangasSetIsReadState, void> {
  MangasSetIsReadStateProvider._({
    required MangasSetIsReadStateFamily super.from,
    required List<int> super.argument,
  }) : super(
         retry: null,
         name: r'mangasSetIsReadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangasSetIsReadStateHash();

  @override
  String toString() {
    return r'mangasSetIsReadStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MangasSetIsReadState create() => MangasSetIsReadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangasSetIsReadStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangasSetIsReadStateHash() =>
    r'44ccdd3ba522c2ad479c50f2e8ce74562991e18c';

final class MangasSetIsReadStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangasSetIsReadState,
          void,
          void,
          void,
          List<int>
        > {
  MangasSetIsReadStateFamily._()
    : super(
        retry: null,
        name: r'mangasSetIsReadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangasSetIsReadStateProvider call({required List<int> mangaIds}) =>
      MangasSetIsReadStateProvider._(argument: mangaIds, from: this);

  @override
  String toString() => r'mangasSetIsReadStateProvider';
}

abstract class _$MangasSetIsReadState extends $Notifier<void> {
  late final _$args = ref.$arg as List<int>;
  List<int> get mangaIds => _$args;

  void build({required List<int> mangaIds});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(mangaIds: _$args));
  }
}

@ProviderFor(MangasSetUnReadState)
final mangasSetUnReadStateProvider = MangasSetUnReadStateFamily._();

final class MangasSetUnReadStateProvider
    extends $NotifierProvider<MangasSetUnReadState, void> {
  MangasSetUnReadStateProvider._({
    required MangasSetUnReadStateFamily super.from,
    required List<int> super.argument,
  }) : super(
         retry: null,
         name: r'mangasSetUnReadStateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mangasSetUnReadStateHash();

  @override
  String toString() {
    return r'mangasSetUnReadStateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MangasSetUnReadState create() => MangasSetUnReadState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MangasSetUnReadStateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mangasSetUnReadStateHash() =>
    r'a5303cc9fa47d4fa778be5ec90da002cf099ebf3';

final class MangasSetUnReadStateFamily extends $Family
    with
        $ClassFamilyOverride<
          MangasSetUnReadState,
          void,
          void,
          void,
          List<int>
        > {
  MangasSetUnReadStateFamily._()
    : super(
        retry: null,
        name: r'mangasSetUnReadStateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MangasSetUnReadStateProvider call({required List<int> mangaIds}) =>
      MangasSetUnReadStateProvider._(argument: mangaIds, from: this);

  @override
  String toString() => r'mangasSetUnReadStateProvider';
}

abstract class _$MangasSetUnReadState extends $Notifier<void> {
  late final _$args = ref.$arg as List<int>;
  List<int> get mangaIds => _$args;

  void build({required List<int> mangaIds});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(mangaIds: _$args));
  }
}
