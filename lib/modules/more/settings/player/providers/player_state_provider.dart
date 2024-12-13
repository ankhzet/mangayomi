import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_state_provider.g.dart';

@riverpod
class MarkEpisodeAsSeenTypeState extends _$MarkEpisodeAsSeenTypeState {
  @override
  int build() {
    return isar.settings.first.markEpisodeAsSeenType ?? 75;
  }

  void set(int value) {
    final settings = isar.settings.first;
    state = value;

    isar.settings.first = settings..markEpisodeAsSeenType = value;
  }
}

@riverpod
class DefaultSkipIntroLengthState extends _$DefaultSkipIntroLengthState {
  @override
  int build() {
    return isar.settings.first.defaultSkipIntroLength ?? 85;
  }

  void set(int value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..defaultSkipIntroLength = value;
  }
}

@riverpod
class DefaultDoubleTapToSkipLengthState
    extends _$DefaultDoubleTapToSkipLengthState {
  @override
  int build() {
    return isar.settings.first.defaultDoubleTapToSkipLength ?? 10;
  }

  void set(int value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..defaultDoubleTapToSkipLength = value;
  }
}

@riverpod
class DefaultPlayBackSpeedState extends _$DefaultPlayBackSpeedState {
  @override
  double build() {
    return isar.settings.first.defaultPlayBackSpeed ?? 1.0;
  }

  void set(double value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..defaultPlayBackSpeed = value;
  }
}

@riverpod
class FullScreenPlayerState extends _$FullScreenPlayerState {
  @override
  bool build() {
    return isar.settings.first.fullScreenPlayer ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..fullScreenPlayer = value;
  }
}

@riverpod
class EnableAniSkipState extends _$EnableAniSkipState {
  @override
  bool build() {
    return isar.settings.first.enableAniSkip ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..enableAniSkip = value;
  }
}

@riverpod
class EnableAutoSkipState extends _$EnableAutoSkipState {
  @override
  bool build() {
    return isar.settings.first.enableAutoSkip ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..enableAutoSkip = value;
  }
}

@riverpod
class AniSkipTimeoutLengthState extends _$AniSkipTimeoutLengthState {
  @override
  int build() {
    return isar.settings.first.aniSkipTimeoutLength ?? 5;
  }

  void set(int value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..aniSkipTimeoutLength = value;
  }
}

@riverpod
class UseLibassState extends _$UseLibassState {
  @override
  bool build() {
    return isar.settings.first.useLibass ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..useLibass = value;
  }
}