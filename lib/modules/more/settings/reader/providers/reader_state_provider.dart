import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reader_state_provider.g.dart';

@riverpod
class DefaultReadingModeState extends _$DefaultReadingModeState {
  @override
  ReaderMode build() {
    return isar.settings.first.defaultReaderMode;
  }

  void set(ReaderMode value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..defaultReaderMode = value));
  }
}

@riverpod
class AnimatePageTransitionsState extends _$AnimatePageTransitionsState {
  @override
  bool build() {
    return isar.settings.first.animatePageTransitions!;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..animatePageTransitions = value));
  }
}

@riverpod
class DoubleTapAnimationSpeedState extends _$DoubleTapAnimationSpeedState {
  @override
  int build() {
    return isar.settings.first.doubleTapAnimationSpeed!;
  }

  void set(int value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings..doubleTapAnimationSpeed = value));
  }
}

@riverpod
class CropBordersState extends _$CropBordersState {
  @override
  bool build() {
    return isar.settings.first.cropBorders ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..cropBorders = value));
  }
}

@riverpod
class ScaleTypeState extends _$ScaleTypeState {
  @override
  ScaleType build() {
    return isar.settings.first.scaleType;
  }

  void set(ScaleType value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..scaleType = value));
  }
}

@riverpod
class PagePreloadAmountState extends _$PagePreloadAmountState {
  @override
  int build() {
    return isar.settings.first.pagePreloadAmount ?? 6;
  }

  void set(int value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..pagePreloadAmount = value));
  }
}

@riverpod
class BackgroundColorState extends _$BackgroundColorState {
  @override
  BackgroundColor build() {
    return isar.settings.first.backgroundColor;
  }

  void set(BackgroundColor value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..backgroundColor = value));
  }
}

@riverpod
class UsePageTapZonesState extends _$UsePageTapZonesState {
  @override
  bool build() {
    return isar.settings.first.usePageTapZones ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..usePageTapZones = value));
  }
}

@riverpod
class FullScreenReaderState extends _$FullScreenReaderState {
  @override
  bool build() {
    return isar.settings.first.fullScreenReader ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..fullScreenReader = value));
  }
}
