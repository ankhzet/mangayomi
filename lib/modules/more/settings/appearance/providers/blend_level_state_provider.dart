import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'blend_level_state_provider.g.dart';

@riverpod
class BlendLevelState extends _$BlendLevelState {
  @override
  double build() {
    return isar.settings.first.flexColorSchemeBlendLevel!;
  }

  void setBlendLevel(double blendLevelValue, {bool end = false}) {
    final settings = isar.settings.first;
    state = blendLevelValue;
    if (end) {
      isar.writeTxnSync(() =>
          isar.settings.putSync(settings..flexColorSchemeBlendLevel = state));
    }
  }
}
