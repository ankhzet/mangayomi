import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'incognito_mode_state_provider.g.dart';

@riverpod
class IncognitoModeState extends _$IncognitoModeState {
  @override
  bool build() {
    return isar.settings.first.incognitoMode!;
  }

  void setIncognitoMode(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.settings.first = settings..incognitoMode = state;
  }
}
