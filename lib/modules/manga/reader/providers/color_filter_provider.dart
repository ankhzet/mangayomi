import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_filter_provider.g.dart';

@riverpod
class CustomColorFilterState extends _$CustomColorFilterState {
  @override
  CustomColorFilter? build() {
    if (!ref.watch(enableCustomColorFilterStateProvider)) return null;
    return isar.settings.first.customColorFilter;
  }

  void set(int a, int r, int g, int b, bool end) {
    final settings = isar.settings.first;
    var value = CustomColorFilter()
      ..a = a
      ..r = r
      ..g = g
      ..b = b;
    if (end) {
      isar.settings.first = settings..customColorFilter = value;
    }
    state = value;
  }
}

@riverpod
class EnableCustomColorFilterState extends _$EnableCustomColorFilterState {
  @override
  bool build() {
    return isar.settings.first.enableCustomColorFilter ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.first;

    isar.settings.first = settings..enableCustomColorFilter = value;
    state = value;
  }
}

@riverpod
class ColorFilterBlendModeState extends _$ColorFilterBlendModeState {
  @override
  ColorFilterBlendMode build() {
    return isar.settings.first.colorFilterBlendMode;
  }

  void set(ColorFilterBlendMode value) {
    final settings = isar.settings.first;

    isar.settings.first = settings..colorFilterBlendMode = value;
    state = value;
  }
}
