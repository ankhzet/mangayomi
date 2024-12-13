import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state_provider.g.dart';

@riverpod
class SubtitleSettingsState extends _$SubtitleSettingsState {
  @override
  PlayerSubtitleSettings build() {
    final subSets = isar.settings.first.playerSubtitleSettings;
    if (subSets == null || subSets.backgroundColorA == null) {
      set(PlayerSubtitleSettings(), true);
      return PlayerSubtitleSettings();
    }
    return subSets;
  }

  void set(PlayerSubtitleSettings value, bool end) {
    final settings = isar.settings.first;
    state = value;
    if (end) {
      isar.settings.first = settings..playerSubtitleSettings = value;
    }
  }

  void resetColor() {
    state = PlayerSubtitleSettings(fontSize: state.fontSize, useBold: state.useBold, useItalic: state.useItalic);

    isar.settings.first = isar.settings.first..playerSubtitleSettings = state;
  }
}
