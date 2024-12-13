import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/providers/color_filter_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/widgets/custom_popup_menu_button.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

class CustomColorSelector extends ConsumerWidget {
  const CustomColorSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final customColorFilter = ref.watch(customColorFilterStateProvider);
    final enableCustomColorFilter = ref.watch(enableCustomColorFilterStateProvider);
    int r = customColorFilter?.r ?? 0;
    int g = customColorFilter?.g ?? 0;
    int b = customColorFilter?.b ?? 0;
    int a = customColorFilter?.a ?? 0;
    final colorFilterBlendMode = ref.watch(colorFilterBlendModeStateProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
                value: enableCustomColorFilter,
                title: Text(
                  l10n.custom_color_filter,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.9), fontSize: 14),
                ),
                onChanged: (value) {
                  ref.read(enableCustomColorFilterStateProvider.notifier).set(value);
                }),
            if (enableCustomColorFilter) ...[
              rgbaFilterWidget(a, r, g, b, (val) {
                if (val.$3 == "r") {
                  ref.read(customColorFilterStateProvider.notifier).set(a, val.$1.toInt(), g, b, val.$2);
                } else if (val.$3 == "g") {
                  ref.read(customColorFilterStateProvider.notifier).set(a, r, val.$1.toInt(), b, val.$2);
                } else if (val.$3 == "b") {
                  ref.read(customColorFilterStateProvider.notifier).set(a, r, g, val.$1.toInt(), val.$2);
                } else {
                  ref.read(customColorFilterStateProvider.notifier).set(val.$1.toInt(), r, g, b, val.$2);
                }
              }, context),
              CustomPopupMenuButton<ColorFilterBlendMode>(
                label: l10n.color_filter_blend_mode,
                title: getColorFilterBlendModeName(colorFilterBlendMode, context),
                onSelected: (value) {
                  ref.read(colorFilterBlendModeStateProvider.notifier).set(value);
                },
                value: colorFilterBlendMode,
                list: ColorFilterBlendMode.values,
                itemText: (va) {
                  return getColorFilterBlendModeName(va, context);
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
