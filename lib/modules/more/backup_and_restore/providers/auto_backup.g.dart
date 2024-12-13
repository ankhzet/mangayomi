// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkAndBackupHash() => r'b5b5ce5ac43b4805ed3e21e14e60364999ddb865';

/// See also [checkAndBackup].
@ProviderFor(checkAndBackup)
final checkAndBackupProvider = AutoDisposeFutureProvider<void>.internal(
  checkAndBackup,
  name: r'checkAndBackupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkAndBackupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckAndBackupRef = AutoDisposeFutureProviderRef<void>;
String _$backupFrequencyStateHash() =>
    r'8bffb8677cfb0582cbeaecd6381922050c0c94b3';

/// See also [BackupFrequencyState].
@ProviderFor(BackupFrequencyState)
final backupFrequencyStateProvider =
    AutoDisposeNotifierProvider<BackupFrequencyState, int>.internal(
  BackupFrequencyState.new,
  name: r'backupFrequencyStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupFrequencyStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupFrequencyState = AutoDisposeNotifier<int>;
String _$backupFrequencyOptionsStateHash() =>
    r'0172d0356c67cbb78304dba5997c901c0b6d3941';

/// See also [BackupFrequencyOptionsState].
@ProviderFor(BackupFrequencyOptionsState)
final backupFrequencyOptionsStateProvider = AutoDisposeNotifierProvider<
    BackupFrequencyOptionsState, List<int>>.internal(
  BackupFrequencyOptionsState.new,
  name: r'backupFrequencyOptionsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backupFrequencyOptionsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackupFrequencyOptionsState = AutoDisposeNotifier<List<int>>;
String _$autoBackupLocationStateHash() =>
    r'a66f6e9ca00b1c126db0a2560e62f14cce18d32c';

/// See also [AutoBackupLocationState].
@ProviderFor(AutoBackupLocationState)
final autoBackupLocationStateProvider = AutoDisposeNotifierProvider<
    AutoBackupLocationState, (String, String)>.internal(
  AutoBackupLocationState.new,
  name: r'autoBackupLocationStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$autoBackupLocationStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AutoBackupLocationState = AutoDisposeNotifier<(String, String)>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
