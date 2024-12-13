import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'pure_black_dark_mode_state_provider.g.dart';

@riverpod
class PureBlackDarkModeState extends _$PureBlackDarkModeState {
  @override
  bool build() {
    return isar.settings.first.pureBlackDarkMode!;
  }

  void set(bool value) {
    final settings = isar.settings.first;
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..pureBlackDarkMode = value));
  }
}
