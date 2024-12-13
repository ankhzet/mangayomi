import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/backup_and_restore/providers/backup.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_backup.g.dart';

@riverpod
class BackupFrequencyState extends _$BackupFrequencyState {
  @override
  int build() {
    return isar.settings.first.backupFrequency ?? 0;
  }

  void set(int value) {
    state = value;
    _setBackupFrequency(value);
  }
}

@riverpod
class BackupFrequencyOptionsState extends _$BackupFrequencyOptionsState {
  @override
  List<int> build() {
    return isar.settings.first.backupFrequencyOptions ?? [0, 1, 2, 3];
  }

  void set(List<int> values) {
    final settings = isar.settings.first;
    state = values;
    isar.settings.first = settings..backupFrequencyOptions = values;
  }
}

@riverpod
class AutoBackupLocationState extends _$AutoBackupLocationState {
  late final settings = isar.settings.first;

  @override
  (String, String) build() {
    return ("", isar.settings.first.autoBackupLocation ?? "");
  }

  void set(String location) {
    state = ("${_storagePath}backup", location);
    isar.settings.first = settings..autoBackupLocation = location;
  }

  String? _storagePath;

  Future refresh() async {
    _storagePath = await StorageProvider.getBackupDirectory();
    state = (_storagePath!, settings.autoBackupLocation ?? '');
  }
}

@riverpod
Future<void> checkAndBackup(Ref ref) async {
  final settings = isar.settings.first;
  if (settings.backupFrequency != null) {
    final backupFrequency = _duration(settings.backupFrequency);
    if (backupFrequency != null) {
      if (settings.startDatebackup != null) {
        final startBackupDate = DateTime.fromMillisecondsSinceEpoch(settings.startDatebackup!);

        if (DateTime.now().isAfter(startBackupDate)) {
          _setBackupFrequency(settings.backupFrequency!);
          await StorageProvider.requestPermission();
          final backupLocation = ref.watch(autoBackupLocationStateProvider).$2;

          Directory backupDirectory =
              Directory(backupLocation.isEmpty ? await StorageProvider.getBackupDirectory() : backupLocation);

          await backupDirectory.create(recursive: true);

          ref.watch(doBackUpProvider(
            list: ref.watch(backupFrequencyOptionsStateProvider),
            path: backupDirectory.path,
            context: null,
          ));
        }
      }
    }
  }
}

Duration? _duration(int? backupFrequency) {
  return switch (backupFrequency) {
    1 => const Duration(hours: 6),
    2 => const Duration(hours: 12),
    3 => const Duration(days: 1),
    4 => const Duration(days: 2),
    5 => const Duration(days: 7),
    _ => null
  };
}

void _setBackupFrequency(int value) {
  final settings = isar.settings.first;
  final duration = _duration(value);
  final now = DateTime.now();
  final startDate = duration != null ? now.add(duration) : null;
  isar.settings.first = settings
    ..backupFrequency = value
    ..startDatebackup = startDate?.millisecondsSinceEpoch;
}
