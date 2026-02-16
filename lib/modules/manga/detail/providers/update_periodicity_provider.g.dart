// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_periodicity_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(updatePeriodicity)
final updatePeriodicityProvider = UpdatePeriodicityFamily._();

final class UpdatePeriodicityProvider
    extends
        $FunctionalProvider<
          AsyncValue<Iterable<MangaPeriodicity>>,
          Iterable<MangaPeriodicity>,
          Stream<Iterable<MangaPeriodicity>>
        >
    with
        $FutureModifier<Iterable<MangaPeriodicity>>,
        $StreamProvider<Iterable<MangaPeriodicity>> {
  UpdatePeriodicityProvider._({
    required UpdatePeriodicityFamily super.from,
    required ({ItemType type, int granularity}) super.argument,
  }) : super(
         retry: null,
         name: r'updatePeriodicityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updatePeriodicityHash();

  @override
  String toString() {
    return r'updatePeriodicityProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Iterable<MangaPeriodicity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Iterable<MangaPeriodicity>> create(Ref ref) {
    final argument = this.argument as ({ItemType type, int granularity});
    return updatePeriodicity(
      ref,
      type: argument.type,
      granularity: argument.granularity,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UpdatePeriodicityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updatePeriodicityHash() => r'16a588dfe0a041ae4ad2ce23f89f931242fe9972';

final class UpdatePeriodicityFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Iterable<MangaPeriodicity>>,
          ({ItemType type, int granularity})
        > {
  UpdatePeriodicityFamily._()
    : super(
        retry: null,
        name: r'updatePeriodicityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdatePeriodicityProvider call({
    required ItemType type,
    int granularity = defaultGranularity,
  }) => UpdatePeriodicityProvider._(
    argument: (type: type, granularity: granularity),
    from: this,
  );

  @override
  String toString() => r'updatePeriodicityProvider';
}
