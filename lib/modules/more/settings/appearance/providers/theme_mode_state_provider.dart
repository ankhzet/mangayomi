import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/flex_scheme_color_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_state_provider.g.dart';

@riverpod
class ThemeModeState extends _$ThemeModeState {
  @override
  bool build() {
    return isar.settings.first.themeIsDark!;
  }

  void setLightTheme() {
    final settings = isar.settings.first;
    state = false;
    ref
        .read(flexSchemeColorStateProvider.notifier)
        .setTheme(ThemeAA.schemes[settings.flexSchemeColorIndex!].light, settings.flexSchemeColorIndex!);
    isar.settings.first = settings..themeIsDark = state;
  }

  void setDarkTheme() {
    final settings = isar.settings.first;
    state = true;
    ref
        .read(flexSchemeColorStateProvider.notifier)
        .setTheme(ThemeAA.schemes[settings.flexSchemeColorIndex!].dark, settings.flexSchemeColorIndex!);
    isar.settings.first = settings..themeIsDark = state;
  }
}
