import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class ReadMoreWidget extends StatefulWidget {
  const ReadMoreWidget({
    super.key,
    required this.text,
    required this.onChanged,
    this.initial = true,
  });

  final Function(bool) onChanged;
  final String text;
  final bool initial;

  @override
  ReadMoreWidgetState createState() => ReadMoreWidgetState();
}

class ReadMoreWidgetState extends State<ReadMoreWidget> with TickerProviderStateMixin {
  late bool expanded = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;

    return widget.text.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(l10n.no_description)],
          )
        : Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ExpandableText(
                      widget.text.trim(),
                      expanded: expanded,
                      onExpandedChanged: (value) {
                        setState(() => expanded = value);
                        widget.onChanged(value);
                      },
                      animationDuration: const Duration(milliseconds: 500),
                      expandText: '',
                      prefixText: '',
                      maxLines: 3,
                      linkColor: Theme.of(context).scaffoldBackgroundColor,
                      animation: true,
                      expandOnTextTap: true,
                      collapseOnTextTap: true,
                    ),
                  ),
                  if (!expanded)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: IgnorePointer(child: Container(
                        width: context.width(1),
                        height: 30,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
                              Theme.of(context).scaffoldBackgroundColor
                            ],
                            stops: const [0, .9],
                          ),
                        ),
                        child: const Icon(Icons.keyboard_arrow_down_sharp),
                      )),
                    ),
                ],
              ),
              if (expanded)
                SizedBox(
                  width: context.width(1),
                  height: 20,
                  child: const Icon(Icons.keyboard_arrow_up_sharp),
                )
            ],
          );
  }
}
