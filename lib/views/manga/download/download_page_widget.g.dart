// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_page_widget.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chapterPageDownloadsHash() =>
    r'0b3eaf9a3ca4786287616a87e5de62af24259b68';

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

abstract class _$ChapterPageDownloads
    extends BuildlessAutoDisposeNotifier<Widget> {
  late final ModelManga modelManga;
  late final int index;

  Widget build({
    required ModelManga modelManga,
    required int index,
  });
}

/// See also [ChapterPageDownloads].
@ProviderFor(ChapterPageDownloads)
const chapterPageDownloadsProvider = ChapterPageDownloadsFamily();

/// See also [ChapterPageDownloads].
class ChapterPageDownloadsFamily extends Family<Widget> {
  /// See also [ChapterPageDownloads].
  const ChapterPageDownloadsFamily();

  /// See also [ChapterPageDownloads].
  ChapterPageDownloadsProvider call({
    required ModelManga modelManga,
    required int index,
  }) {
    return ChapterPageDownloadsProvider(
      modelManga: modelManga,
      index: index,
    );
  }

  @override
  ChapterPageDownloadsProvider getProviderOverride(
    covariant ChapterPageDownloadsProvider provider,
  ) {
    return call(
      modelManga: provider.modelManga,
      index: provider.index,
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
  String? get name => r'chapterPageDownloadsProvider';
}

/// See also [ChapterPageDownloads].
class ChapterPageDownloadsProvider
    extends AutoDisposeNotifierProviderImpl<ChapterPageDownloads, Widget> {
  /// See also [ChapterPageDownloads].
  ChapterPageDownloadsProvider({
    required this.modelManga,
    required this.index,
  }) : super.internal(
          () => ChapterPageDownloads()
            ..modelManga = modelManga
            ..index = index,
          from: chapterPageDownloadsProvider,
          name: r'chapterPageDownloadsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterPageDownloadsHash,
          dependencies: ChapterPageDownloadsFamily._dependencies,
          allTransitiveDependencies:
              ChapterPageDownloadsFamily._allTransitiveDependencies,
        );

  final ModelManga modelManga;
  final int index;

  @override
  bool operator ==(Object other) {
    return other is ChapterPageDownloadsProvider &&
        other.modelManga == modelManga &&
        other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, modelManga.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  Widget runNotifierBuild(
    covariant ChapterPageDownloads notifier,
  ) {
    return notifier.build(
      modelManga: modelManga,
      index: index,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions