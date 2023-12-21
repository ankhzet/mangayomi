import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'player_state_provider.g.dart';

@riverpod
class MarkEpisodeAsSeenTypeState extends _$MarkEpisodeAsSeenTypeState {
  @override
  int build() {
    return isar.settings.getSync(227)!.markEpisodeAsSeenType ?? 75;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..markEpisodeAsSeenType = value));
  }
}

@riverpod
class DefaultSkipIntroLengthState extends _$DefaultSkipIntroLengthState {
  @override
  int build() {
    return isar.settings.getSync(227)!.defaultSkipIntroLength ?? 85;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..defaultSkipIntroLength = value));
  }
}

@riverpod
class DefaultDoubleTapToSkipLengthState
    extends _$DefaultDoubleTapToSkipLengthState {
  @override
  int build() {
    return isar.settings.getSync(227)!.defaultDoubleTapToSkipLength ?? 10;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..defaultDoubleTapToSkipLength = value));
  }
}

@riverpod
class DefaultPlayBackSpeedState extends _$DefaultPlayBackSpeedState {
  @override
  double build() {
    return isar.settings.getSync(227)!.defaultPlayBackSpeed ?? 1.0;
  }

  void set(double value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..defaultPlayBackSpeed = value));
  }
}
