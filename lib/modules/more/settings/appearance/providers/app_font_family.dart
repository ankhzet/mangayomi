import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_font_family.g.dart';

@riverpod
class AppFontFamily extends _$AppFontFamily {
  @override
  String? build() {
    final fontFamily = isar.settings.first.appFontFamily;
    if (fontFamily == null) return null;

    return GoogleFonts.asMap()
        .entries
        .toList()
        .firstWhere((element) => element.value().fontFamily! == fontFamily)
        .value()
        .fontFamily;
  }

  void set(String? fontFamily) {
    final settings = isar.settings.first;
    state = fontFamily;
    isar.settings.first = settings..appFontFamily = fontFamily;
  }
}
