import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'browse_state_provider.g.dart';

@riverpod
class OnlyIncludePinnedSourceState extends _$OnlyIncludePinnedSourceState {
  @override
  bool build() {
    return isar.settings.first.onlyIncludePinnedSources!;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..onlyIncludePinnedSources = value;
  }
}

@riverpod
class AutoUpdateExtensionsState extends _$AutoUpdateExtensionsState {
  @override
  bool build() {
    return isar.settings.first.autoExtensionsUpdates ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..autoExtensionsUpdates = value;
  }
}

@riverpod
class CheckForExtensionsUpdateState extends _$CheckForExtensionsUpdateState {
  @override
  bool build() {
    return isar.settings.first.checkForExtensionUpdates ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..checkForExtensionUpdates = value;
  }
}
